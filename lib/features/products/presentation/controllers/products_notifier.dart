import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'products_providers.dart';

/// AsyncNotifier managing the products list state, mutations, and caching lifecycle.
/// 100% free of raw try-catch blocks via fpdart Either handling.
class ProductsNotifier extends AsyncNotifier<List<ProductEntity>> {
  final GetProductsUseCase? _injectedGetProductsUseCase;
  final AddProductUseCase? _injectedAddProductUseCase;
  final UpdateProductUseCase? _injectedUpdateProductUseCase;
  final DeleteProductUseCase? _injectedDeleteProductUseCase;

  ProductsNotifier({
    GetProductsUseCase? getProductsUseCase,
    AddProductUseCase? addProductUseCase,
    UpdateProductUseCase? updateProductUseCase,
    DeleteProductUseCase? deleteProductUseCase,
  }) : _injectedGetProductsUseCase = getProductsUseCase,
       _injectedAddProductUseCase = addProductUseCase,
       _injectedUpdateProductUseCase = updateProductUseCase,
       _injectedDeleteProductUseCase = deleteProductUseCase;

  GetProductsUseCase get _getProductsUseCase =>
      _injectedGetProductsUseCase ?? ref.read(getProductsUseCaseProvider);

  AddProductUseCase get _addProductUseCase =>
      _injectedAddProductUseCase ?? ref.read(addProductUseCaseProvider);

  UpdateProductUseCase get _updateProductUseCase =>
      _injectedUpdateProductUseCase ?? ref.read(updateProductUseCaseProvider);

  DeleteProductUseCase get _deleteProductUseCase =>
      _injectedDeleteProductUseCase ?? ref.read(deleteProductUseCaseProvider);

  @override
  FutureOr<List<ProductEntity>> build() {
    return _fetchProducts(forceRefresh: false);
  }

  Future<List<ProductEntity>> _fetchProducts({
    bool forceRefresh = false,
  }) async {
    final result = await _getProductsUseCase(forceRefresh: forceRefresh);
    return result.fold((failure) => throw failure, (products) => products);
  }

  /// Reloads products forcing Hive cache invalidation
  Future<void> refreshProducts({bool forceRefresh = true}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetchProducts(forceRefresh: forceRefresh),
    );
  }

  /// Adds a new product and prepends to the state immutably
  Future<Either<Failure, ProductEntity>> addProduct(
    Map<String, dynamic> data,
  ) async {
    final previous = state;
    final result = await _addProductUseCase(data);

    result.fold((failure) {}, (newProduct) {
      final current = List<ProductEntity>.from(previous.value ?? const []);
      state = AsyncValue.data([newProduct, ...current]);
    });

    return result;
  }

  /// Updates an existing product and updates state immutably
  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    final previous = state;
    final result = await _updateProductUseCase(id, data);

    result.fold((failure) {}, (updatedProduct) {
      final current = List<ProductEntity>.from(previous.value ?? const []);
      final index = current.indexWhere((p) => p.id == id);
      if (index != -1) {
        current[index] = updatedProduct;
        state = AsyncValue.data(current);
      }
    });

    return result;
  }

  /// Deletes a product and removes it from the state immutably
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    final previous = state;
    final result = await _deleteProductUseCase(id);

    result.fold((failure) {}, (success) {
      if (success) {
        final current = List<ProductEntity>.from(previous.value ?? const []);
        current.removeWhere((p) => p.id == id);
        state = AsyncValue.data(current);
      }
    });

    return result;
  }

  /// Clears error state safely
  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(state.value ?? const []);
    }
  }
}
