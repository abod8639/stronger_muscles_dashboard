import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'orders_providers.dart';

/// State Notifier orchestrating orders list state and status modifications.
/// Adheres strictly to Clean Architecture:
/// - Constructor Dependency Injection for 100% testability
/// - Zero try-catch blocks (Functional error handling via fpdart Either)
class OrdersNotifier extends AsyncNotifier<List<OrderEntity>> {
  final GetOrdersUseCase? _injectedGetOrdersUseCase;
  final UpdateOrderStatusUseCase? _injectedUpdateOrderStatusUseCase;

  OrdersNotifier({
    GetOrdersUseCase? getOrdersUseCase,
    UpdateOrderStatusUseCase? updateOrderStatusUseCase,
  }) : _injectedGetOrdersUseCase = getOrdersUseCase,
       _injectedUpdateOrderStatusUseCase = updateOrderStatusUseCase;

  @override
  FutureOr<List<OrderEntity>> build() async {
    final GetOrdersUseCase useCase =
        _injectedGetOrdersUseCase ?? ref.watch(getOrdersUseCaseProvider);
    final result = await useCase();

    return result.fold((failure) => throw failure, (orders) => orders);
  }

  /// Reloads orders list with optional cache bypass.
  Future<void> refreshOrders({bool forceRefresh = true}) async {
    state = const AsyncValue.loading();
    final GetOrdersUseCase useCase =
        _injectedGetOrdersUseCase ?? ref.read(getOrdersUseCaseProvider);
    final result = await useCase(forceRefresh: forceRefresh);

    if (ref.mounted) {
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (orders) => AsyncValue.data(orders),
      );
    }
  }

  /// Updates an order status and optimistically updates local list state.
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    final UpdateOrderStatusUseCase useCase =
        _injectedUpdateOrderStatusUseCase ??
        ref.read(updateOrderStatusUseCaseProvider);
    final previousState = state;

    final result = await useCase(orderId, newStatus);

    result.fold((failure) {}, (updatedOrder) {
      final currentList = List<OrderEntity>.from(
        previousState.value ?? const [],
      );
      final index = currentList.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        currentList[index] = updatedOrder;
        state = AsyncValue.data(currentList);
      }
    });

    return result;
  }

  /// Clears any transient error state without losing cached data.
  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(state.value ?? const []);
    }
  }
}
