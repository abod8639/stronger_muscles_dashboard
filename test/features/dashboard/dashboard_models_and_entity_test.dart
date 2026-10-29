import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/mappers/dashboard_mapper.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/utils/dashboard_chart_calculator.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

void main() {
  group('DashboardStatsEntity Tests', () {
    test(
      'initial() factory produces valid initial entity with zero metrics',
      () {
        const entity = DashboardStatsEntity.initial();

        expect(entity.totalOrders, 0);
        expect(entity.pendingOrders, 0);
        expect(entity.processingOrders, 0);
        expect(entity.shippedOrders, 0);
        expect(entity.deliveredOrders, 0);
        expect(entity.cancelledOrders, 0);
        expect(entity.totalProducts, 0);
        expect(entity.lowStock, 0);
        expect(entity.outOfStock, 0);
        expect(entity.inStock, 0);
        expect(entity.totalUsers, 0);
        expect(entity.totalRevenue, 0.0);
        expect(entity.orders, isEmpty);
        expect(entity.products, isEmpty);
        expect(entity.categories, isEmpty);
      },
    );

    test(
      'copyWith updates specified fields correctly while preserving others',
      () {
        const initial = DashboardStatsEntity.initial();
        final updated = initial.copyWith(
          totalOrders: 42,
          totalRevenue: 1500.50,
          totalUsers: 10,
        );

        expect(updated.totalOrders, 42);
        expect(updated.totalRevenue, 1500.50);
        expect(updated.totalUsers, 10);
        expect(updated.totalProducts, 0);
      },
    );

    test('equality and hashCode work as expected for identical state', () {
      final e1 = const DashboardStatsEntity.initial().copyWith(
        totalOrders: 10,
        totalRevenue: 250.0,
      );
      final e2 = const DashboardStatsEntity.initial().copyWith(
        totalOrders: 10,
        totalRevenue: 250.0,
      );
      final e3 = const DashboardStatsEntity.initial().copyWith(
        totalOrders: 5,
        totalRevenue: 100.0,
      );

      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));
      expect(e1, isNot(equals(e3)));
    });
  });

  group('DashboardStatsModel & Mappers Tests', () {
    test('fromJson deserializes complete backend JSON map correctly', () {
      final json = {
        'total_orders': 15,
        'pending_orders': 3,
        'processing_orders': 2,
        'shipped_orders': 4,
        'delivered_orders': 10,
        'cancelled_orders': 2,
        'total_products': 50,
        'in_stock': 40,
        'low_stock': 5,
        'out_of_stock': 5,
        'total_users': 120,
        'total_revenue': 4500.75,
      };

      final model = DashboardStatsModel.fromJson(json);

      expect(model.totalOrders, 15);
      expect(model.pendingOrders, 3);
      expect(model.processingOrders, 2);
      expect(model.shippedOrders, 4);
      expect(model.deliveredOrders, 10);
      expect(model.cancelledOrders, 2);
      expect(model.totalProducts, 50);
      expect(model.inStock, 40);
      expect(model.lowStock, 5);
      expect(model.outOfStock, 5);
      expect(model.totalUsers, 120);
      expect(model.totalRevenue, 4500.75);
    });

    test(
      'fromJson handles empty or null values safely with resilient fallbacks',
      () {
        final json = <String, dynamic>{};

        final model = DashboardStatsModel.fromJson(json);

        expect(model.totalOrders, 0);
        expect(model.totalRevenue, 0.0);
        expect(model.inStock, 0);
      },
    );

    test('toJson serializes model back to backend map', () {
      const model = DashboardStatsModel(
        totalRevenue: 200.0,
        totalOrders: 10,
        totalUsers: 25,
        totalProducts: 4,
        pendingOrders: 1,
        processingOrders: 1,
        shippedOrders: 1,
        deliveredOrders: 6,
        cancelledOrders: 1,
        inStock: 3,
        lowStock: 1,
        outOfStock: 0,
      );

      final json = model.toJson();

      expect(json['total_orders'], 10);
      expect(json['total_revenue'], 200.0);
      expect(json['total_products'], 4);
      expect(json['in_stock'], 3);
    });

    test('toEntity and toModel map bidirectionally', () {
      const model = DashboardStatsModel(
        totalRevenue: 9800.0,
        totalOrders: 20,
        totalUsers: 300,
        totalProducts: 80,
        pendingOrders: 5,
        processingOrders: 3,
        shippedOrders: 2,
        deliveredOrders: 12,
        cancelledOrders: 3,
        inStock: 70,
        lowStock: 6,
        outOfStock: 4,
      );

      final entity = model.toEntity();

      expect(entity.totalOrders, model.totalOrders);
      expect(entity.pendingOrders, model.pendingOrders);
      expect(entity.deliveredOrders, model.deliveredOrders);
      expect(entity.totalRevenue, model.totalRevenue);
      expect(entity.inStock, model.inStock);

      final backToModel = entity.toModel();

      expect(backToModel.totalOrders, entity.totalOrders);
      expect(backToModel.totalRevenue, entity.totalRevenue);
      expect(backToModel.lowStock, entity.lowStock);
    });
  });

  group('DashboardChartCalculator Tests', () {
    test('calculateOrdersChartData produces 7 data spots for week period', () {
      final orders = <OrderEntity>[];
      final chartData = DashboardChartCalculator.calculateOrdersChartData(
        orders,
        'week',
      );

      expect(chartData.spots.length, 7);
      expect(chartData.bottomTitles.length, 7);
      expect(chartData.totalPeriodOrders, 0);
    });

    test(
      'calculateOrdersChartData produces 30 data spots for month period',
      () {
        final orders = <OrderEntity>[];
        final chartData = DashboardChartCalculator.calculateOrdersChartData(
          orders,
          'month',
        );

        expect(chartData.spots.length, 30);
        expect(chartData.bottomTitles.length, 30);
        expect(chartData.totalPeriodOrders, 0);
      },
    );

    test('calculateOrdersChartData produces 12 data spots for year period', () {
      final orders = <OrderEntity>[];
      final chartData = DashboardChartCalculator.calculateOrdersChartData(
        orders,
        'year',
      );

      expect(chartData.spots.length, 12);
      expect(chartData.bottomTitles.length, 12);
      expect(chartData.totalPeriodOrders, 0);
    });

    test(
      'calculateStatusTrendData computes valid trend direction and spots',
      () {
        final orders = <OrderEntity>[];
        final trendData = DashboardChartCalculator.calculateStatusTrendData(
          orders,
          OrderStatus.pending,
          'week',
        );

        expect(trendData.spots.length, 7);
        expect(trendData.trend, '0%');
        expect(trendData.trendUp, isTrue);
      },
    );
  });
}
