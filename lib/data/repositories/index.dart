// Exporting Clean Architecture Repositories (Interfaces & Impls)
export '../../features/auth/domain/repositories/auth_repository.dart';
export '../../features/categories/domain/repositories/category_repository.dart';
export '../../features/products/domain/repositories/product_repository.dart';
export '../../features/orders/domain/repositories/order_repository.dart';

// Also export implementations for Binding usage if needed
export '../../features/auth/data/repositories/auth_repository_impl.dart';
export '../../features/categories/data/repositories/category_repository_impl.dart';
export '../../features/products/data/repositories/product_repository_impl.dart';
export '../../features/orders/data/repositories/order_repository_impl.dart';

// Remaining legacy repositories
export 'user_repository.dart';
