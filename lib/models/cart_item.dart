class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final List<String> imageUrls;
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrls,
    required this.addedAt,
  });

  double get subtotal => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      productId: json['product_id'].toString(),
      productName: json['product_name'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: int.parse(json['quantity'].toString()),
      imageUrls: List<String>.from((json['image_urls'] as List?) ?? []),
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'image_urls': imageUrls,
      'added_at': addedAt.toIso8601String(),
    };
  }
}
