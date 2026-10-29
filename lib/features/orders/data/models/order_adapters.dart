import 'package:hive/hive.dart';
import '../../domain/entities/order_entity.dart';

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 9;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.pending;
      case 1:
        return OrderStatus.processing;
      case 2:
        return OrderStatus.shipped;
      case 3:
        return OrderStatus.delivered;
      case 4:
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.pending:
        writer.writeByte(0);
        break;
      case OrderStatus.processing:
        writer.writeByte(1);
        break;
      case OrderStatus.shipped:
        writer.writeByte(2);
        break;
      case OrderStatus.delivered:
        writer.writeByte(3);
        break;
      case OrderStatus.cancelled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentStatusAdapter extends TypeAdapter<PaymentStatus> {
  @override
  final int typeId = 10;

  @override
  PaymentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentStatus.pending;
      case 1:
        return PaymentStatus.paid;
      case 2:
        return PaymentStatus.failed;
      case 3:
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentStatus obj) {
    switch (obj) {
      case PaymentStatus.pending:
        writer.writeByte(0);
        break;
      case PaymentStatus.paid:
        writer.writeByte(1);
        break;
      case PaymentStatus.failed:
        writer.writeByte(2);
        break;
      case PaymentStatus.refunded:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
