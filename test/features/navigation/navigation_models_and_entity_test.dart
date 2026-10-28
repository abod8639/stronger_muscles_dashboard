import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/mappers/navigation_mapper.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/models/navigation_badges_model.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_badges_entity.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_tab.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_state.dart';

void main() {
  group('NavigationTab Tests', () {
    test('values are indexed sequentially from 0 to 8', () {
      expect(NavigationTab.dashboard.tabIndex, 0);
      expect(NavigationTab.categories.tabIndex, 1);
      expect(NavigationTab.products.tabIndex, 2);
      expect(NavigationTab.promos.tabIndex, 3);
      expect(NavigationTab.orders.tabIndex, 4);
      expect(NavigationTab.users.tabIndex, 5);
      expect(NavigationTab.notifications.tabIndex, 6);
      expect(NavigationTab.settings.tabIndex, 7);
      expect(NavigationTab.support.tabIndex, 8);
    });

    test('fromIndex returns corresponding tab with fallback to dashboard', () {
      expect(NavigationTab.fromIndex(0), NavigationTab.dashboard);
      expect(NavigationTab.fromIndex(4), NavigationTab.orders);
      expect(NavigationTab.fromIndex(8), NavigationTab.support);
      expect(NavigationTab.fromIndex(99), NavigationTab.dashboard);
      expect(NavigationTab.fromIndex(-1), NavigationTab.dashboard);
    });

    test('title returns correct localized Arabic and English titles', () {
      expect(NavigationTab.dashboard.title('ar'), 'الرئيسية');
      expect(NavigationTab.dashboard.title('en'), 'Dashboard');
      expect(NavigationTab.orders.title('ar'), 'الطلبات');
      expect(NavigationTab.orders.title('en'), 'Orders');
    });
  });

  group('NavigationBadgesEntity Tests', () {
    test('initial factory produces all-zero badge counters', () {
      const badges = NavigationBadgesEntity.initial();

      expect(badges.pendingOrdersCount, 0);
      expect(badges.unreadNotificationsCount, 0);
      expect(badges.openTicketsCount, 0);
      expect(badges.lowStockProductsCount, 0);
    });

    test('copyWith updates specified counts correctly', () {
      const initial = NavigationBadgesEntity.initial();
      final updated = initial.copyWith(
        pendingOrdersCount: 5,
        unreadNotificationsCount: 12,
      );

      expect(updated.pendingOrdersCount, 5);
      expect(updated.unreadNotificationsCount, 12);
      expect(updated.openTicketsCount, 0);
      expect(updated.lowStockProductsCount, 0);
    });

    test('equality and hashCode work as expected', () {
      const b1 = NavigationBadgesEntity(
        pendingOrdersCount: 3,
        unreadNotificationsCount: 7,
        openTicketsCount: 1,
        lowStockProductsCount: 2,
      );
      const b2 = NavigationBadgesEntity(
        pendingOrdersCount: 3,
        unreadNotificationsCount: 7,
        openTicketsCount: 1,
        lowStockProductsCount: 2,
      );
      const b3 = NavigationBadgesEntity(
        pendingOrdersCount: 1,
        unreadNotificationsCount: 7,
        openTicketsCount: 1,
        lowStockProductsCount: 2,
      );

      expect(b1, equals(b2));
      expect(b1.hashCode, equals(b2.hashCode));
      expect(b1, isNot(equals(b3)));
    });
  });

  group('NavigationBadgesModel & Mapper Tests', () {
    test('fromJson deserializes standard backend map correctly', () {
      final json = {
        'pending_orders': 4,
        'unread_notifications': 10,
        'open_tickets': 2,
        'low_stock_products': 6,
      };

      final model = NavigationBadgesModel.fromJson(json);

      expect(model.pendingOrdersCount, 4);
      expect(model.unreadNotificationsCount, 10);
      expect(model.openTicketsCount, 2);
      expect(model.lowStockProductsCount, 6);
    });

    test('fromJson handles alternative camelCase and string values safely', () {
      final json = {
        'pendingOrdersCount': '8',
        'unreadNotificationsCount': 15.0,
        'open_tickets_count': null,
      };

      final model = NavigationBadgesModel.fromJson(json);

      expect(model.pendingOrdersCount, 8);
      expect(model.unreadNotificationsCount, 15);
      expect(model.openTicketsCount, 0);
      expect(model.lowStockProductsCount, 0);
    });

    test('toJson produces expected serializable map', () {
      const model = NavigationBadgesModel(
        pendingOrdersCount: 3,
        unreadNotificationsCount: 5,
        openTicketsCount: 1,
        lowStockProductsCount: 4,
      );

      final json = model.toJson();

      expect(json['pending_orders'], 3);
      expect(json['unread_notifications'], 5);
      expect(json['open_tickets'], 1);
      expect(json['low_stock_products'], 4);
    });

    test('toEntity and toModel map bidirectionally', () {
      const model = NavigationBadgesModel(
        pendingOrdersCount: 9,
        unreadNotificationsCount: 21,
        openTicketsCount: 4,
        lowStockProductsCount: 11,
      );

      final entity = model.toEntity();

      expect(entity.pendingOrdersCount, model.pendingOrdersCount);
      expect(entity.unreadNotificationsCount, model.unreadNotificationsCount);
      expect(entity.openTicketsCount, model.openTicketsCount);
      expect(entity.lowStockProductsCount, model.lowStockProductsCount);

      final backToModel = entity.toModel();

      expect(backToModel, equals(model));
    });
  });

  group('NavigationState Tests', () {
    test('initial factory produces expected defaults', () {
      final state = NavigationState.initial(userRole: 'admin');

      expect(state.selectedIndex, 0);
      expect(state.isDrawerOpen, isFalse);
      expect(state.badges, const NavigationBadgesEntity.initial());
      expect(state.userRole, 'admin');
    });

    test('copyWith updates state correctly while preserving other values', () {
      final initial = NavigationState.initial();
      final updated = initial.copyWith(
        selectedIndex: 4,
        isDrawerOpen: true,
      );

      expect(updated.selectedIndex, 4);
      expect(updated.isDrawerOpen, isTrue);
      expect(updated.userRole, 'admin');
    });
  });
}
