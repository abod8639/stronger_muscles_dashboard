import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
@HiveType(typeId: 14, adapterName: 'CartItemModelAdapter')
@JsonSerializable()
class CartItemModel with _$CartItemModel {
  const CartItemModel._(); 

  const factory CartItemModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'user_id') required String userId,
    @HiveField(2) @JsonKey(name: 'product_id') required String productId,
    @HiveField(3) @JsonKey(name: 'product_name') required String productName,
    @HiveField(4) @Default(0.0) double price,
    @HiveField(5) @Default(1) int quantity,
    @HiveField(6) @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    @HiveField(7) @JsonKey(name: 'added_at') required DateTime addedAt,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => 
      _$CartItemModelFromJson(json);

  double get subtotal => price * quantity;
}