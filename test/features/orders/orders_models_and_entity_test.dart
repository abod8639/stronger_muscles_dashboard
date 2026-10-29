import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/data/models/address_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/mappers/order_mapper.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

void main() {
  group('OrderEntity & OrderItemEntity Tests', () {
    test('OrderEntity equality and hashCode contract', () {
      final now = DateTime(2026, 1, 1);
      final o1 = OrderEntity(
        id: 'ord-1',
        userId: 'u-1',
        userName: 'Ahmed',
        userEmail: 'ahmed@example.com',
        phoneNumber: '0555555555',
        totalAmount: 150.0,
        subtotal: 130.0,
        shippingCost: 20.0,
        discount: 0.0,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'card',
        addressId: 'addr-1',
        orderDate: now,
        items: const [],
      );
      final o2 = OrderEntity(
        id: 'ord-1',
        userId: 'u-1',
        userName: 'Ahmed',
        userEmail: 'ahmed@example.com',
        phoneNumber: '0555555555',
        totalAmount: 150.0,
        subtotal: 130.0,
        shippingCost: 20.0,
        discount: 0.0,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'card',
        addressId: 'addr-1',
        orderDate: now,
        items: const [],
      );
      final o3 = o1.copyWith(status: OrderStatus.delivered);

      expect(o1, equals(o2));
      expect(o1.hashCode, equals(o2.hashCode));
      expect(o1, isNot(equals(o3)));
      expect(o3.status, equals(OrderStatus.delivered));
    });

    test('OrderItemEntity equality, copyWith, and hashCode contract', () {
      const item1 = OrderItemEntity(
        id: 'item-1',
        productId: 'prod-10',
        productName: 'Whey Protein',
        quantity: 2,
        unitPrice: 50.0,
        subtotal: 100.0,
        selectedFlavor: 'Vanilla',
        selectedSize: '2kg',
      );
      const item2 = OrderItemEntity(
        id: 'item-1',
        productId: 'prod-10',
        productName: 'Whey Protein',
        quantity: 2,
        unitPrice: 50.0,
        subtotal: 100.0,
        selectedFlavor: 'Vanilla',
        selectedSize: '2kg',
      );
      final item3 = item1.copyWith(quantity: 3, subtotal: 150.0);

      expect(item1, equals(item2));
      expect(item1.hashCode, equals(item2.hashCode));
      expect(item1, isNot(equals(item3)));
      expect(item3.quantity, 3);
      expect(item3.subtotal, 150.0);
    });

    test('AddressEntity coordinates and full address helper', () {
      const addr = AddressEntity(
        id: 1,
        userId: 1,
        street: 'King Fahd Rd',
        city: 'Riyadh',
        state: 'Riyadh Province',
        country: 'Saudi Arabia',
        postalCode: '12345',
        latitude: 24.7136,
        longitude: 46.6753,
      );

      expect(addr.hasCoordinates, isTrue);
      expect(addr.fullAddress, contains('King Fahd Rd'));
      expect(addr.fullAddress, contains('Riyadh'));

      const addrNoCoords = AddressEntity(
        id: 2,
        userId: 1,
        street: 'Main St',
        city: 'Jeddah',
      );
      expect(addrNoCoords.hasCoordinates, isFalse);
    });
  });

  group('Order Mappers Tests', () {
    test('OrderModel <-> OrderEntity mapping preserves all fields', () {
      final now = DateTime(2026, 2, 1);
      final model = OrderModel(
        id: 'ord-100',
        userId: 'u-100',
        orderDate: now,
        status: OrderStatus.processing,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'apple_pay',
        addressId: 'addr-5',
        subtotal: 200.0,
        shippingCost: 15.0,
        discount: 25.0,
        totalAmount: 190.0,
        trackingNumber: 'TRK-999',
        notes: 'Handle with care',
        phoneNumber: '0501234567',
        shippingAddress: const AddressModel(
          id: 5,
          userId: 100,
          street: 'Olaya St',
          city: 'Riyadh',
        ),
        items: const [
          OrderItemModel(
            id: 'item-1',
            orderId: 'ord-100',
            productId: 'p-1',
            productName: 'Creatine Monohydrate',
            quantity: 1,
            unitPrice: 70.0,
            subtotal: 70.0,
          ),
        ],
      );

      final entity = model.toEntity();

      expect(entity.id, 'ord-100');
      expect(entity.userId, 'u-100');
      expect(entity.status, OrderStatus.processing);
      expect(entity.paymentStatus, PaymentStatus.paid);
      expect(entity.totalAmount, 190.0);
      expect(entity.trackingNumber, 'TRK-999');
      expect(entity.shippingAddress?.street, 'Olaya St');
      expect(entity.items.length, 1);
      expect(entity.items.first.productName, 'Creatine Monohydrate');

      final roundTripModel = entity.toModel();
      expect(roundTripModel.id, entity.id);
      expect(roundTripModel.totalAmount, entity.totalAmount);
      expect(roundTripModel.status, entity.status);
    });

    test('OrderModel.fromJson reads the tax charged on the order', () {
      final model = OrderModel.fromJson({
        'id': 'order-tax',
        'user_id': '7',
        'order_date': '2026-10-29T10:00:00Z',
        'address_id': '3',
        'subtotal': 100,
        'shipping_cost': 50,
        'tax_amount': 14,
        'total_amount': 164,
      });

      expect(model.taxAmount, 14.0);
      expect(model.toEntity().taxAmount, 14.0);
      expect(model.toEntity().toModel().taxAmount, 14.0);
    });

    test(
      'OrderModel.fromJson defaults tax to 0 and includes it in a missing total',
      () {
        final withoutTax = OrderModel.fromJson({
          'id': 'order-old',
          'user_id': '7',
          'order_date': '2026-10-29T10:00:00Z',
          'address_id': '3',
          'subtotal': 100,
          'shippingCost': 50,
        });
        final missingTotal = OrderModel.fromJson({
          'id': 'order-no-total',
          'user_id': '7',
          'order_date': '2026-10-29T10:00:00Z',
          'address_id': '3',
          'subtotal': 100,
          'shippingCost': 50,
          'taxAmount': 14,
        });

        expect(withoutTax.taxAmount, 0.0);
        expect(withoutTax.totalAmount, 150.0);
        expect(missingTotal.totalAmount, 164.0);
      },
    );
  });
}
