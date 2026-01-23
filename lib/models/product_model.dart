import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 8, adapterName: 'ProductModelAdapter') // تأكد من رقم typeId فريد
@JsonSerializable(explicitToJson: true)
class ProductModel with _$ProductModel {
  const ProductModel._(); // ضروري لاستخدام الـ Getters

  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) @Default(0.0) double price,
    @HiveField(3) double? discountPrice,
    @HiveField(4) @Default([]) List<String> imageUrls,
    @HiveField(5) @Default('') String description,
    @HiveField(6) required String categoryId,
    @HiveField(7) @Default(0) int stockQuantity,
    @HiveField(8) @Default(0.0) double averageRating,
    @HiveField(9) @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @HiveField(11) String? servingSize,
    @HiveField(12) int? servingsPerContainer,
    @HiveField(13) @Default(true) bool isActive,
    @HiveField(14) @Default(false) bool isBackgroundWhite,

    // Basic Info
    @HiveField(15) String? sku,
    @HiveField(16) List<String>? tags,
    @HiveField(17) double? weight,
    @HiveField(18) @Default([]) List<String> size,
    @HiveField(19) @JsonKey(name: 'flavors') @Default([]) List<String> flavor,

    // Nutrition & Shipping (بشكل خرائط)
    @HiveField(20) Map<String, dynamic>? nutritionFacts,
    @HiveField(21) Map<String, dynamic>? dimensions,

    // Marketing
    @HiveField(22) @Default(false) bool featured,
    @HiveField(23) @Default(false) bool newArrival,
    @HiveField(24) @Default(false) bool bestSeller,
    @HiveField(25) @Default(0) int totalSales,
    @HiveField(26) @Default(0) int viewsCount,

    // Additional
    @HiveField(27) String? ingredients,
    @HiveField(28) String? usageInstructions,
    @HiveField(29) String? warnings,
    @HiveField(30) DateTime? expiryDate,
    @HiveField(31) String? manufacturer,
    @HiveField(32) String? countryOfOrigin,

    // SEO
    @HiveField(33) String? metaTitle,
    @HiveField(34) String? metaDescription,
    @HiveField(35) String? slug,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // معالجة أسماء الحقول المختلفة (snake_case to camelCase) يدوياً إذا لم يكن السيرفر موحداً
    // أو الاعتماد على @JsonKey(name: '...') داخل الـ factory
    return _$ProductModelFromJson(json);
  }

  // --- Getters المحسنة ---
  double get finalPrice => (discountPrice != null && discountPrice! < price) ? discountPrice! : price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  bool get isInStock => stockQuantity > 0;
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 10;
  
  double get discountPercentage {
    if (hasDiscount && price > 0) {
      return ((price - discountPrice!) / price * 100).roundToDouble();
    }
    return 0;
  }

  bool get isExpired => expiryDate != null && DateTime.now().isAfter(expiryDate!);
}