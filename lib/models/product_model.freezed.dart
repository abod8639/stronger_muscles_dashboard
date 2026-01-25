// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  double? get discountPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_urls')
  @HiveField(4)
  List<String> get imageUrls => throw _privateConstructorUsedError;
  @HiveField(5)
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  @HiveField(6)
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  @HiveField(7)
  int get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating')
  @HiveField(8)
  double get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_count')
  @HiveField(9)
  int get reviewCount => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'serving_size')
  @HiveField(11)
  String? get servingSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'servings_per_container')
  @HiveField(12)
  int? get servingsPerContainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  @HiveField(13)
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_background_white')
  @HiveField(14)
  bool? get isBackgroundWhite => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get sku => throw _privateConstructorUsedError;
  @HiveField(16)
  List<String>? get tags => throw _privateConstructorUsedError;
  @HiveField(17)
  double? get weight => throw _privateConstructorUsedError;
  @HiveField(18)
  List<String>? get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'flavors')
  @HiveField(19)
  List<String>? get flavor => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutrition_facts')
  @HiveField(20)
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError;
  @HiveField(21)
  bool get featured => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_arrival')
  @HiveField(22)
  bool get newArrival => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_seller')
  @HiveField(23)
  bool get bestSeller => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sales')
  @HiveField(24)
  int get totalSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'views_count')
  @HiveField(25)
  int get viewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_weight')
  @HiveField(26)
  double? get shippingWeight => throw _privateConstructorUsedError;
  @HiveField(27)
  Map<String, dynamic>? get dimensions => throw _privateConstructorUsedError;
  @HiveField(28)
  List<String> get ingredients => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_instructions')
  @HiveField(29)
  String? get usageInstructions => throw _privateConstructorUsedError;
  @HiveField(30)
  String? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  @HiveField(31)
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  @HiveField(32)
  String? get manufacturer => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_of_origin')
  @HiveField(33)
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  @JsonKey(name: 'meta_title')
  @HiveField(34)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'meta_description')
  @HiveField(35)
  String? get metaDescription => throw _privateConstructorUsedError;
  @HiveField(36)
  String? get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String name,
    @HiveField(2) double price,
    @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
    @JsonKey(name: 'image_urls') @HiveField(4) List<String> imageUrls,
    @HiveField(5) String description,
    @JsonKey(name: 'category_id') @HiveField(6) String categoryId,
    @JsonKey(name: 'stock_quantity') @HiveField(7) int stockQuantity,
    @JsonKey(name: 'average_rating') @HiveField(8) double averageRating,
    @JsonKey(name: 'review_count') @HiveField(9) int reviewCount,
    @HiveField(10) String? brand,
    @JsonKey(name: 'serving_size') @HiveField(11) String? servingSize,
    @JsonKey(name: 'servings_per_container')
    @HiveField(12)
    int? servingsPerContainer,
    @JsonKey(name: 'is_active') @HiveField(13) bool isActive,
    @JsonKey(name: 'is_background_white')
    @HiveField(14)
    bool? isBackgroundWhite,
    @HiveField(15) String? sku,
    @HiveField(16) List<String>? tags,
    @HiveField(17) double? weight,
    @HiveField(18) List<String>? size,
    @JsonKey(name: 'flavors') @HiveField(19) List<String>? flavor,
    @JsonKey(name: 'nutrition_facts')
    @HiveField(20)
    Map<String, dynamic>? nutritionFacts,
    @HiveField(21) bool featured,
    @JsonKey(name: 'new_arrival') @HiveField(22) bool newArrival,
    @JsonKey(name: 'best_seller') @HiveField(23) bool bestSeller,
    @JsonKey(name: 'total_sales') @HiveField(24) int totalSales,
    @JsonKey(name: 'views_count') @HiveField(25) int viewsCount,
    @JsonKey(name: 'shipping_weight') @HiveField(26) double? shippingWeight,
    @HiveField(27) Map<String, dynamic>? dimensions,
    @HiveField(28) List<String> ingredients,
    @JsonKey(name: 'usage_instructions')
    @HiveField(29)
    String? usageInstructions,
    @HiveField(30) String? warnings,
    @JsonKey(name: 'expiry_date') @HiveField(31) DateTime? expiryDate,
    @HiveField(32) String? manufacturer,
    @JsonKey(name: 'country_of_origin') @HiveField(33) String? countryOfOrigin,
    @JsonKey(name: 'meta_title') @HiveField(34) String? metaTitle,
    @JsonKey(name: 'meta_description') @HiveField(35) String? metaDescription,
    @HiveField(36) String? slug,
  });
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? imageUrls = null,
    Object? description = null,
    Object? categoryId = null,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? brand = freezed,
    Object? servingSize = freezed,
    Object? servingsPerContainer = freezed,
    Object? isActive = null,
    Object? isBackgroundWhite = freezed,
    Object? sku = freezed,
    Object? tags = freezed,
    Object? weight = freezed,
    Object? size = freezed,
    Object? flavor = freezed,
    Object? nutritionFacts = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? viewsCount = null,
    Object? shippingWeight = freezed,
    Object? dimensions = freezed,
    Object? ingredients = null,
    Object? usageInstructions = freezed,
    Object? warnings = freezed,
    Object? expiryDate = freezed,
    Object? manufacturer = freezed,
    Object? countryOfOrigin = freezed,
    Object? metaTitle = freezed,
    Object? metaDescription = freezed,
    Object? slug = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            discountPrice: freezed == discountPrice
                ? _value.discountPrice
                : discountPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            stockQuantity: null == stockQuantity
                ? _value.stockQuantity
                : stockQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            servingSize: freezed == servingSize
                ? _value.servingSize
                : servingSize // ignore: cast_nullable_to_non_nullable
                      as String?,
            servingsPerContainer: freezed == servingsPerContainer
                ? _value.servingsPerContainer
                : servingsPerContainer // ignore: cast_nullable_to_non_nullable
                      as int?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isBackgroundWhite: freezed == isBackgroundWhite
                ? _value.isBackgroundWhite
                : isBackgroundWhite // ignore: cast_nullable_to_non_nullable
                      as bool?,
            sku: freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            flavor: freezed == flavor
                ? _value.flavor
                : flavor // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            nutritionFacts: freezed == nutritionFacts
                ? _value.nutritionFacts
                : nutritionFacts // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            featured: null == featured
                ? _value.featured
                : featured // ignore: cast_nullable_to_non_nullable
                      as bool,
            newArrival: null == newArrival
                ? _value.newArrival
                : newArrival // ignore: cast_nullable_to_non_nullable
                      as bool,
            bestSeller: null == bestSeller
                ? _value.bestSeller
                : bestSeller // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalSales: null == totalSales
                ? _value.totalSales
                : totalSales // ignore: cast_nullable_to_non_nullable
                      as int,
            viewsCount: null == viewsCount
                ? _value.viewsCount
                : viewsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            shippingWeight: freezed == shippingWeight
                ? _value.shippingWeight
                : shippingWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            dimensions: freezed == dimensions
                ? _value.dimensions
                : dimensions // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            ingredients: null == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            usageInstructions: freezed == usageInstructions
                ? _value.usageInstructions
                : usageInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            warnings: freezed == warnings
                ? _value.warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            manufacturer: freezed == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryOfOrigin: freezed == countryOfOrigin
                ? _value.countryOfOrigin
                : countryOfOrigin // ignore: cast_nullable_to_non_nullable
                      as String?,
            metaTitle: freezed == metaTitle
                ? _value.metaTitle
                : metaTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            metaDescription: freezed == metaDescription
                ? _value.metaDescription
                : metaDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String name,
    @HiveField(2) double price,
    @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
    @JsonKey(name: 'image_urls') @HiveField(4) List<String> imageUrls,
    @HiveField(5) String description,
    @JsonKey(name: 'category_id') @HiveField(6) String categoryId,
    @JsonKey(name: 'stock_quantity') @HiveField(7) int stockQuantity,
    @JsonKey(name: 'average_rating') @HiveField(8) double averageRating,
    @JsonKey(name: 'review_count') @HiveField(9) int reviewCount,
    @HiveField(10) String? brand,
    @JsonKey(name: 'serving_size') @HiveField(11) String? servingSize,
    @JsonKey(name: 'servings_per_container')
    @HiveField(12)
    int? servingsPerContainer,
    @JsonKey(name: 'is_active') @HiveField(13) bool isActive,
    @JsonKey(name: 'is_background_white')
    @HiveField(14)
    bool? isBackgroundWhite,
    @HiveField(15) String? sku,
    @HiveField(16) List<String>? tags,
    @HiveField(17) double? weight,
    @HiveField(18) List<String>? size,
    @JsonKey(name: 'flavors') @HiveField(19) List<String>? flavor,
    @JsonKey(name: 'nutrition_facts')
    @HiveField(20)
    Map<String, dynamic>? nutritionFacts,
    @HiveField(21) bool featured,
    @JsonKey(name: 'new_arrival') @HiveField(22) bool newArrival,
    @JsonKey(name: 'best_seller') @HiveField(23) bool bestSeller,
    @JsonKey(name: 'total_sales') @HiveField(24) int totalSales,
    @JsonKey(name: 'views_count') @HiveField(25) int viewsCount,
    @JsonKey(name: 'shipping_weight') @HiveField(26) double? shippingWeight,
    @HiveField(27) Map<String, dynamic>? dimensions,
    @HiveField(28) List<String> ingredients,
    @JsonKey(name: 'usage_instructions')
    @HiveField(29)
    String? usageInstructions,
    @HiveField(30) String? warnings,
    @JsonKey(name: 'expiry_date') @HiveField(31) DateTime? expiryDate,
    @HiveField(32) String? manufacturer,
    @JsonKey(name: 'country_of_origin') @HiveField(33) String? countryOfOrigin,
    @JsonKey(name: 'meta_title') @HiveField(34) String? metaTitle,
    @JsonKey(name: 'meta_description') @HiveField(35) String? metaDescription,
    @HiveField(36) String? slug,
  });
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? imageUrls = null,
    Object? description = null,
    Object? categoryId = null,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? brand = freezed,
    Object? servingSize = freezed,
    Object? servingsPerContainer = freezed,
    Object? isActive = null,
    Object? isBackgroundWhite = freezed,
    Object? sku = freezed,
    Object? tags = freezed,
    Object? weight = freezed,
    Object? size = freezed,
    Object? flavor = freezed,
    Object? nutritionFacts = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? viewsCount = null,
    Object? shippingWeight = freezed,
    Object? dimensions = freezed,
    Object? ingredients = null,
    Object? usageInstructions = freezed,
    Object? warnings = freezed,
    Object? expiryDate = freezed,
    Object? manufacturer = freezed,
    Object? countryOfOrigin = freezed,
    Object? metaTitle = freezed,
    Object? metaDescription = freezed,
    Object? slug = freezed,
  }) {
    return _then(
      _$ProductModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        discountPrice: freezed == discountPrice
            ? _value.discountPrice
            : discountPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        stockQuantity: null == stockQuantity
            ? _value.stockQuantity
            : stockQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        servingSize: freezed == servingSize
            ? _value.servingSize
            : servingSize // ignore: cast_nullable_to_non_nullable
                  as String?,
        servingsPerContainer: freezed == servingsPerContainer
            ? _value.servingsPerContainer
            : servingsPerContainer // ignore: cast_nullable_to_non_nullable
                  as int?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isBackgroundWhite: freezed == isBackgroundWhite
            ? _value.isBackgroundWhite
            : isBackgroundWhite // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sku: freezed == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
        size: freezed == size
            ? _value._size
            : size // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        flavor: freezed == flavor
            ? _value._flavor
            : flavor // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        nutritionFacts: freezed == nutritionFacts
            ? _value._nutritionFacts
            : nutritionFacts // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        featured: null == featured
            ? _value.featured
            : featured // ignore: cast_nullable_to_non_nullable
                  as bool,
        newArrival: null == newArrival
            ? _value.newArrival
            : newArrival // ignore: cast_nullable_to_non_nullable
                  as bool,
        bestSeller: null == bestSeller
            ? _value.bestSeller
            : bestSeller // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalSales: null == totalSales
            ? _value.totalSales
            : totalSales // ignore: cast_nullable_to_non_nullable
                  as int,
        viewsCount: null == viewsCount
            ? _value.viewsCount
            : viewsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        shippingWeight: freezed == shippingWeight
            ? _value.shippingWeight
            : shippingWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        dimensions: freezed == dimensions
            ? _value._dimensions
            : dimensions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        ingredients: null == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        usageInstructions: freezed == usageInstructions
            ? _value.usageInstructions
            : usageInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        warnings: freezed == warnings
            ? _value.warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        manufacturer: freezed == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryOfOrigin: freezed == countryOfOrigin
            ? _value.countryOfOrigin
            : countryOfOrigin // ignore: cast_nullable_to_non_nullable
                  as String?,
        metaTitle: freezed == metaTitle
            ? _value.metaTitle
            : metaTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        metaDescription: freezed == metaDescription
            ? _value.metaDescription
            : metaDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl extends _ProductModel with DiagnosticableTreeMixin {
  const _$ProductModelImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.name,
    @HiveField(2) required this.price,
    @JsonKey(name: 'discount_price') @HiveField(3) this.discountPrice,
    @JsonKey(name: 'image_urls')
    @HiveField(4)
    final List<String> imageUrls = const [],
    @HiveField(5) required this.description,
    @JsonKey(name: 'category_id') @HiveField(6) required this.categoryId,
    @JsonKey(name: 'stock_quantity') @HiveField(7) this.stockQuantity = 0,
    @JsonKey(name: 'average_rating') @HiveField(8) this.averageRating = 0.0,
    @JsonKey(name: 'review_count') @HiveField(9) this.reviewCount = 0,
    @HiveField(10) this.brand,
    @JsonKey(name: 'serving_size') @HiveField(11) this.servingSize,
    @JsonKey(name: 'servings_per_container')
    @HiveField(12)
    this.servingsPerContainer,
    @JsonKey(name: 'is_active') @HiveField(13) this.isActive = true,
    @JsonKey(name: 'is_background_white')
    @HiveField(14)
    this.isBackgroundWhite = false,
    @HiveField(15) this.sku,
    @HiveField(16) final List<String>? tags = const [],
    @HiveField(17) this.weight,
    @HiveField(18) final List<String>? size = const [],
    @JsonKey(name: 'flavors')
    @HiveField(19)
    final List<String>? flavor = const [],
    @JsonKey(name: 'nutrition_facts')
    @HiveField(20)
    final Map<String, dynamic>? nutritionFacts,
    @HiveField(21) this.featured = false,
    @JsonKey(name: 'new_arrival') @HiveField(22) this.newArrival = false,
    @JsonKey(name: 'best_seller') @HiveField(23) this.bestSeller = false,
    @JsonKey(name: 'total_sales') @HiveField(24) this.totalSales = 0,
    @JsonKey(name: 'views_count') @HiveField(25) this.viewsCount = 0,
    @JsonKey(name: 'shipping_weight') @HiveField(26) this.shippingWeight,
    @HiveField(27) final Map<String, dynamic>? dimensions,
    @HiveField(28) final List<String> ingredients = const [],
    @JsonKey(name: 'usage_instructions') @HiveField(29) this.usageInstructions,
    @HiveField(30) this.warnings,
    @JsonKey(name: 'expiry_date') @HiveField(31) this.expiryDate,
    @HiveField(32) this.manufacturer,
    @JsonKey(name: 'country_of_origin') @HiveField(33) this.countryOfOrigin,
    @JsonKey(name: 'meta_title') @HiveField(34) this.metaTitle,
    @JsonKey(name: 'meta_description') @HiveField(35) this.metaDescription,
    @HiveField(36) this.slug,
  }) : _imageUrls = imageUrls,
       _tags = tags,
       _size = size,
       _flavor = flavor,
       _nutritionFacts = nutritionFacts,
       _dimensions = dimensions,
       _ingredients = ingredients,
       super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final double price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  final double? discountPrice;
  final List<String> _imageUrls;
  @override
  @JsonKey(name: 'image_urls')
  @HiveField(4)
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @HiveField(5)
  final String description;
  @override
  @JsonKey(name: 'category_id')
  @HiveField(6)
  final String categoryId;
  @override
  @JsonKey(name: 'stock_quantity')
  @HiveField(7)
  final int stockQuantity;
  @override
  @JsonKey(name: 'average_rating')
  @HiveField(8)
  final double averageRating;
  @override
  @JsonKey(name: 'review_count')
  @HiveField(9)
  final int reviewCount;
  @override
  @HiveField(10)
  final String? brand;
  @override
  @JsonKey(name: 'serving_size')
  @HiveField(11)
  final String? servingSize;
  @override
  @JsonKey(name: 'servings_per_container')
  @HiveField(12)
  final int? servingsPerContainer;
  @override
  @JsonKey(name: 'is_active')
  @HiveField(13)
  final bool isActive;
  @override
  @JsonKey(name: 'is_background_white')
  @HiveField(14)
  final bool? isBackgroundWhite;
  @override
  @HiveField(15)
  final String? sku;
  final List<String>? _tags;
  @override
  @JsonKey()
  @HiveField(16)
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(17)
  final double? weight;
  final List<String>? _size;
  @override
  @JsonKey()
  @HiveField(18)
  List<String>? get size {
    final value = _size;
    if (value == null) return null;
    if (_size is EqualUnmodifiableListView) return _size;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _flavor;
  @override
  @JsonKey(name: 'flavors')
  @HiveField(19)
  List<String>? get flavor {
    final value = _flavor;
    if (value == null) return null;
    if (_flavor is EqualUnmodifiableListView) return _flavor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _nutritionFacts;
  @override
  @JsonKey(name: 'nutrition_facts')
  @HiveField(20)
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  @HiveField(21)
  final bool featured;
  @override
  @JsonKey(name: 'new_arrival')
  @HiveField(22)
  final bool newArrival;
  @override
  @JsonKey(name: 'best_seller')
  @HiveField(23)
  final bool bestSeller;
  @override
  @JsonKey(name: 'total_sales')
  @HiveField(24)
  final int totalSales;
  @override
  @JsonKey(name: 'views_count')
  @HiveField(25)
  final int viewsCount;
  @override
  @JsonKey(name: 'shipping_weight')
  @HiveField(26)
  final double? shippingWeight;
  final Map<String, dynamic>? _dimensions;
  @override
  @HiveField(27)
  Map<String, dynamic>? get dimensions {
    final value = _dimensions;
    if (value == null) return null;
    if (_dimensions is EqualUnmodifiableMapView) return _dimensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _ingredients;
  @override
  @JsonKey()
  @HiveField(28)
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @JsonKey(name: 'usage_instructions')
  @HiveField(29)
  final String? usageInstructions;
  @override
  @HiveField(30)
  final String? warnings;
  @override
  @JsonKey(name: 'expiry_date')
  @HiveField(31)
  final DateTime? expiryDate;
  @override
  @HiveField(32)
  final String? manufacturer;
  @override
  @JsonKey(name: 'country_of_origin')
  @HiveField(33)
  final String? countryOfOrigin;
  @override
  @JsonKey(name: 'meta_title')
  @HiveField(34)
  final String? metaTitle;
  @override
  @JsonKey(name: 'meta_description')
  @HiveField(35)
  final String? metaDescription;
  @override
  @HiveField(36)
  final String? slug;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductModel(id: $id, name: $name, price: $price, discountPrice: $discountPrice, imageUrls: $imageUrls, description: $description, categoryId: $categoryId, stockQuantity: $stockQuantity, averageRating: $averageRating, reviewCount: $reviewCount, brand: $brand, servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, isActive: $isActive, isBackgroundWhite: $isBackgroundWhite, sku: $sku, tags: $tags, weight: $weight, size: $size, flavor: $flavor, nutritionFacts: $nutritionFacts, featured: $featured, newArrival: $newArrival, bestSeller: $bestSeller, totalSales: $totalSales, viewsCount: $viewsCount, shippingWeight: $shippingWeight, dimensions: $dimensions, ingredients: $ingredients, usageInstructions: $usageInstructions, warnings: $warnings, expiryDate: $expiryDate, manufacturer: $manufacturer, countryOfOrigin: $countryOfOrigin, metaTitle: $metaTitle, metaDescription: $metaDescription, slug: $slug)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('discountPrice', discountPrice))
      ..add(DiagnosticsProperty('imageUrls', imageUrls))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('categoryId', categoryId))
      ..add(DiagnosticsProperty('stockQuantity', stockQuantity))
      ..add(DiagnosticsProperty('averageRating', averageRating))
      ..add(DiagnosticsProperty('reviewCount', reviewCount))
      ..add(DiagnosticsProperty('brand', brand))
      ..add(DiagnosticsProperty('servingSize', servingSize))
      ..add(DiagnosticsProperty('servingsPerContainer', servingsPerContainer))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('isBackgroundWhite', isBackgroundWhite))
      ..add(DiagnosticsProperty('sku', sku))
      ..add(DiagnosticsProperty('tags', tags))
      ..add(DiagnosticsProperty('weight', weight))
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('flavor', flavor))
      ..add(DiagnosticsProperty('nutritionFacts', nutritionFacts))
      ..add(DiagnosticsProperty('featured', featured))
      ..add(DiagnosticsProperty('newArrival', newArrival))
      ..add(DiagnosticsProperty('bestSeller', bestSeller))
      ..add(DiagnosticsProperty('totalSales', totalSales))
      ..add(DiagnosticsProperty('viewsCount', viewsCount))
      ..add(DiagnosticsProperty('shippingWeight', shippingWeight))
      ..add(DiagnosticsProperty('dimensions', dimensions))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('usageInstructions', usageInstructions))
      ..add(DiagnosticsProperty('warnings', warnings))
      ..add(DiagnosticsProperty('expiryDate', expiryDate))
      ..add(DiagnosticsProperty('manufacturer', manufacturer))
      ..add(DiagnosticsProperty('countryOfOrigin', countryOfOrigin))
      ..add(DiagnosticsProperty('metaTitle', metaTitle))
      ..add(DiagnosticsProperty('metaDescription', metaDescription))
      ..add(DiagnosticsProperty('slug', slug));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.servingsPerContainer, servingsPerContainer) ||
                other.servingsPerContainer == servingsPerContainer) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isBackgroundWhite, isBackgroundWhite) ||
                other.isBackgroundWhite == isBackgroundWhite) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            const DeepCollectionEquality().equals(other._size, _size) &&
            const DeepCollectionEquality().equals(other._flavor, _flavor) &&
            const DeepCollectionEquality().equals(
              other._nutritionFacts,
              _nutritionFacts,
            ) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.newArrival, newArrival) ||
                other.newArrival == newArrival) &&
            (identical(other.bestSeller, bestSeller) ||
                other.bestSeller == bestSeller) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.shippingWeight, shippingWeight) ||
                other.shippingWeight == shippingWeight) &&
            const DeepCollectionEquality().equals(
              other._dimensions,
              _dimensions,
            ) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            (identical(other.usageInstructions, usageInstructions) ||
                other.usageInstructions == usageInstructions) &&
            (identical(other.warnings, warnings) ||
                other.warnings == warnings) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    price,
    discountPrice,
    const DeepCollectionEquality().hash(_imageUrls),
    description,
    categoryId,
    stockQuantity,
    averageRating,
    reviewCount,
    brand,
    servingSize,
    servingsPerContainer,
    isActive,
    isBackgroundWhite,
    sku,
    const DeepCollectionEquality().hash(_tags),
    weight,
    const DeepCollectionEquality().hash(_size),
    const DeepCollectionEquality().hash(_flavor),
    const DeepCollectionEquality().hash(_nutritionFacts),
    featured,
    newArrival,
    bestSeller,
    totalSales,
    viewsCount,
    shippingWeight,
    const DeepCollectionEquality().hash(_dimensions),
    const DeepCollectionEquality().hash(_ingredients),
    usageInstructions,
    warnings,
    expiryDate,
    manufacturer,
    countryOfOrigin,
    metaTitle,
    metaDescription,
    slug,
  ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel({
    @HiveField(0) required final String id,
    @HiveField(1) required final String name,
    @HiveField(2) required final double price,
    @JsonKey(name: 'discount_price') @HiveField(3) final double? discountPrice,
    @JsonKey(name: 'image_urls') @HiveField(4) final List<String> imageUrls,
    @HiveField(5) required final String description,
    @JsonKey(name: 'category_id')
    @HiveField(6)
    required final String categoryId,
    @JsonKey(name: 'stock_quantity') @HiveField(7) final int stockQuantity,
    @JsonKey(name: 'average_rating') @HiveField(8) final double averageRating,
    @JsonKey(name: 'review_count') @HiveField(9) final int reviewCount,
    @HiveField(10) final String? brand,
    @JsonKey(name: 'serving_size') @HiveField(11) final String? servingSize,
    @JsonKey(name: 'servings_per_container')
    @HiveField(12)
    final int? servingsPerContainer,
    @JsonKey(name: 'is_active') @HiveField(13) final bool isActive,
    @JsonKey(name: 'is_background_white')
    @HiveField(14)
    final bool? isBackgroundWhite,
    @HiveField(15) final String? sku,
    @HiveField(16) final List<String>? tags,
    @HiveField(17) final double? weight,
    @HiveField(18) final List<String>? size,
    @JsonKey(name: 'flavors') @HiveField(19) final List<String>? flavor,
    @JsonKey(name: 'nutrition_facts')
    @HiveField(20)
    final Map<String, dynamic>? nutritionFacts,
    @HiveField(21) final bool featured,
    @JsonKey(name: 'new_arrival') @HiveField(22) final bool newArrival,
    @JsonKey(name: 'best_seller') @HiveField(23) final bool bestSeller,
    @JsonKey(name: 'total_sales') @HiveField(24) final int totalSales,
    @JsonKey(name: 'views_count') @HiveField(25) final int viewsCount,
    @JsonKey(name: 'shipping_weight')
    @HiveField(26)
    final double? shippingWeight,
    @HiveField(27) final Map<String, dynamic>? dimensions,
    @HiveField(28) final List<String> ingredients,
    @JsonKey(name: 'usage_instructions')
    @HiveField(29)
    final String? usageInstructions,
    @HiveField(30) final String? warnings,
    @JsonKey(name: 'expiry_date') @HiveField(31) final DateTime? expiryDate,
    @HiveField(32) final String? manufacturer,
    @JsonKey(name: 'country_of_origin')
    @HiveField(33)
    final String? countryOfOrigin,
    @JsonKey(name: 'meta_title') @HiveField(34) final String? metaTitle,
    @JsonKey(name: 'meta_description')
    @HiveField(35)
    final String? metaDescription,
    @HiveField(36) final String? slug,
  }) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  double get price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  double? get discountPrice;
  @override
  @JsonKey(name: 'image_urls')
  @HiveField(4)
  List<String> get imageUrls;
  @override
  @HiveField(5)
  String get description;
  @override
  @JsonKey(name: 'category_id')
  @HiveField(6)
  String get categoryId;
  @override
  @JsonKey(name: 'stock_quantity')
  @HiveField(7)
  int get stockQuantity;
  @override
  @JsonKey(name: 'average_rating')
  @HiveField(8)
  double get averageRating;
  @override
  @JsonKey(name: 'review_count')
  @HiveField(9)
  int get reviewCount;
  @override
  @HiveField(10)
  String? get brand;
  @override
  @JsonKey(name: 'serving_size')
  @HiveField(11)
  String? get servingSize;
  @override
  @JsonKey(name: 'servings_per_container')
  @HiveField(12)
  int? get servingsPerContainer;
  @override
  @JsonKey(name: 'is_active')
  @HiveField(13)
  bool get isActive;
  @override
  @JsonKey(name: 'is_background_white')
  @HiveField(14)
  bool? get isBackgroundWhite;
  @override
  @HiveField(15)
  String? get sku;
  @override
  @HiveField(16)
  List<String>? get tags;
  @override
  @HiveField(17)
  double? get weight;
  @override
  @HiveField(18)
  List<String>? get size;
  @override
  @JsonKey(name: 'flavors')
  @HiveField(19)
  List<String>? get flavor;
  @override
  @JsonKey(name: 'nutrition_facts')
  @HiveField(20)
  Map<String, dynamic>? get nutritionFacts;
  @override
  @HiveField(21)
  bool get featured;
  @override
  @JsonKey(name: 'new_arrival')
  @HiveField(22)
  bool get newArrival;
  @override
  @JsonKey(name: 'best_seller')
  @HiveField(23)
  bool get bestSeller;
  @override
  @JsonKey(name: 'total_sales')
  @HiveField(24)
  int get totalSales;
  @override
  @JsonKey(name: 'views_count')
  @HiveField(25)
  int get viewsCount;
  @override
  @JsonKey(name: 'shipping_weight')
  @HiveField(26)
  double? get shippingWeight;
  @override
  @HiveField(27)
  Map<String, dynamic>? get dimensions;
  @override
  @HiveField(28)
  List<String> get ingredients;
  @override
  @JsonKey(name: 'usage_instructions')
  @HiveField(29)
  String? get usageInstructions;
  @override
  @HiveField(30)
  String? get warnings;
  @override
  @JsonKey(name: 'expiry_date')
  @HiveField(31)
  DateTime? get expiryDate;
  @override
  @HiveField(32)
  String? get manufacturer;
  @override
  @JsonKey(name: 'country_of_origin')
  @HiveField(33)
  String? get countryOfOrigin;
  @override
  @JsonKey(name: 'meta_title')
  @HiveField(34)
  String? get metaTitle;
  @override
  @JsonKey(name: 'meta_description')
  @HiveField(35)
  String? get metaDescription;
  @override
  @HiveField(36)
  String? get slug;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
