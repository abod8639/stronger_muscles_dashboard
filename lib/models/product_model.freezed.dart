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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_price')
  double? get discountPrice =>
      throw _privateConstructorUsedError; // لاحظ استخدام اسم المفتاح الموحد الذي ننتجه في الدالة بالأسفل
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating')
  double get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_count')
  int get reviewCount => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'serving_size')
  String? get servingSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'servings_per_container')
  int? get servingsPerContainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_background_white')
  bool? get isBackgroundWhite => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  List<String>? get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'flavors')
  List<String>? get flavor => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_arrival')
  bool get newArrival => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_seller')
  bool get bestSeller => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sales')
  int get totalSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'views_count')
  int get viewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_weight')
  double? get shippingWeight => throw _privateConstructorUsedError;
  Map<String, dynamic>? get dimensions => throw _privateConstructorUsedError;
  List<String> get ingredients => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_instructions')
  String? get usageInstructions => throw _privateConstructorUsedError;
  String? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  @JsonKey(name: 'meta_title')
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'meta_description')
  String? get metaDescription => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      @JsonKey(name: 'discount_price') double? discountPrice,
      @JsonKey(name: 'image_urls') List<String> imageUrls,
      String description,
      @JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'stock_quantity') int stockQuantity,
      @JsonKey(name: 'average_rating') double averageRating,
      @JsonKey(name: 'review_count') int reviewCount,
      String? brand,
      @JsonKey(name: 'serving_size') String? servingSize,
      @JsonKey(name: 'servings_per_container') int? servingsPerContainer,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_background_white') bool? isBackgroundWhite,
      String? sku,
      List<String>? tags,
      double? weight,
      List<String>? size,
      @JsonKey(name: 'flavors') List<String>? flavor,
      @JsonKey(name: 'nutrition_facts') Map<String, dynamic>? nutritionFacts,
      bool featured,
      @JsonKey(name: 'new_arrival') bool newArrival,
      @JsonKey(name: 'best_seller') bool bestSeller,
      @JsonKey(name: 'total_sales') int totalSales,
      @JsonKey(name: 'views_count') int viewsCount,
      @JsonKey(name: 'shipping_weight') double? shippingWeight,
      Map<String, dynamic>? dimensions,
      List<String> ingredients,
      @JsonKey(name: 'usage_instructions') String? usageInstructions,
      String? warnings,
      @JsonKey(name: 'expiry_date') DateTime? expiryDate,
      String? manufacturer,
      @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
      @JsonKey(name: 'meta_title') String? metaTitle,
      @JsonKey(name: 'meta_description') String? metaDescription,
      String? slug});
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
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      @JsonKey(name: 'discount_price') double? discountPrice,
      @JsonKey(name: 'image_urls') List<String> imageUrls,
      String description,
      @JsonKey(name: 'category_id') String categoryId,
      @JsonKey(name: 'stock_quantity') int stockQuantity,
      @JsonKey(name: 'average_rating') double averageRating,
      @JsonKey(name: 'review_count') int reviewCount,
      String? brand,
      @JsonKey(name: 'serving_size') String? servingSize,
      @JsonKey(name: 'servings_per_container') int? servingsPerContainer,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_background_white') bool? isBackgroundWhite,
      String? sku,
      List<String>? tags,
      double? weight,
      List<String>? size,
      @JsonKey(name: 'flavors') List<String>? flavor,
      @JsonKey(name: 'nutrition_facts') Map<String, dynamic>? nutritionFacts,
      bool featured,
      @JsonKey(name: 'new_arrival') bool newArrival,
      @JsonKey(name: 'best_seller') bool bestSeller,
      @JsonKey(name: 'total_sales') int totalSales,
      @JsonKey(name: 'views_count') int viewsCount,
      @JsonKey(name: 'shipping_weight') double? shippingWeight,
      Map<String, dynamic>? dimensions,
      List<String> ingredients,
      @JsonKey(name: 'usage_instructions') String? usageInstructions,
      String? warnings,
      @JsonKey(name: 'expiry_date') DateTime? expiryDate,
      String? manufacturer,
      @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
      @JsonKey(name: 'meta_title') String? metaTitle,
      @JsonKey(name: 'meta_description') String? metaDescription,
      String? slug});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

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
    return _then(_$ProductModelImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl extends _ProductModel with DiagnosticableTreeMixin {
  const _$ProductModelImpl(
      {required this.id,
      required this.name,
      required this.price,
      @JsonKey(name: 'discount_price') this.discountPrice,
      @JsonKey(name: 'image_urls') final List<String> imageUrls = const [],
      required this.description,
      @JsonKey(name: 'category_id') required this.categoryId,
      @JsonKey(name: 'stock_quantity') this.stockQuantity = 0,
      @JsonKey(name: 'average_rating') this.averageRating = 0.0,
      @JsonKey(name: 'review_count') this.reviewCount = 0,
      this.brand,
      @JsonKey(name: 'serving_size') this.servingSize,
      @JsonKey(name: 'servings_per_container') this.servingsPerContainer,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_background_white') this.isBackgroundWhite = false,
      this.sku,
      final List<String>? tags = const [],
      this.weight,
      final List<String>? size = const [],
      @JsonKey(name: 'flavors') final List<String>? flavor = const [],
      @JsonKey(name: 'nutrition_facts')
      final Map<String, dynamic>? nutritionFacts,
      this.featured = false,
      @JsonKey(name: 'new_arrival') this.newArrival = false,
      @JsonKey(name: 'best_seller') this.bestSeller = false,
      @JsonKey(name: 'total_sales') this.totalSales = 0,
      @JsonKey(name: 'views_count') this.viewsCount = 0,
      @JsonKey(name: 'shipping_weight') this.shippingWeight,
      final Map<String, dynamic>? dimensions,
      final List<String> ingredients = const [],
      @JsonKey(name: 'usage_instructions') this.usageInstructions,
      this.warnings,
      @JsonKey(name: 'expiry_date') this.expiryDate,
      this.manufacturer,
      @JsonKey(name: 'country_of_origin') this.countryOfOrigin,
      @JsonKey(name: 'meta_title') this.metaTitle,
      @JsonKey(name: 'meta_description') this.metaDescription,
      this.slug})
      : _imageUrls = imageUrls,
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
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
// لاحظ استخدام اسم المفتاح الموحد الذي ننتجه في الدالة بالأسفل
  final List<String> _imageUrls;
// لاحظ استخدام اسم المفتاح الموحد الذي ننتجه في الدالة بالأسفل
  @override
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final String description;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @override
  @JsonKey(name: 'average_rating')
  final double averageRating;
  @override
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @override
  final String? brand;
  @override
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @override
  @JsonKey(name: 'servings_per_container')
  final int? servingsPerContainer;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_background_white')
  final bool? isBackgroundWhite;
  @override
  final String? sku;
  final List<String>? _tags;
  @override
  @JsonKey()
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? weight;
  final List<String>? _size;
  @override
  @JsonKey()
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
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey(name: 'new_arrival')
  final bool newArrival;
  @override
  @JsonKey(name: 'best_seller')
  final bool bestSeller;
  @override
  @JsonKey(name: 'total_sales')
  final int totalSales;
  @override
  @JsonKey(name: 'views_count')
  final int viewsCount;
  @override
  @JsonKey(name: 'shipping_weight')
  final double? shippingWeight;
  final Map<String, dynamic>? _dimensions;
  @override
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
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @JsonKey(name: 'usage_instructions')
  final String? usageInstructions;
  @override
  final String? warnings;
  @override
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @override
  final String? manufacturer;
  @override
  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;
  @override
  @JsonKey(name: 'meta_title')
  final String? metaTitle;
  @override
  @JsonKey(name: 'meta_description')
  final String? metaDescription;
  @override
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
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
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
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
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
            const DeepCollectionEquality()
                .equals(other._dimensions, _dimensions) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
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
        slug
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel(
      {required final String id,
      required final String name,
      required final double price,
      @JsonKey(name: 'discount_price') final double? discountPrice,
      @JsonKey(name: 'image_urls') final List<String> imageUrls,
      required final String description,
      @JsonKey(name: 'category_id') required final String categoryId,
      @JsonKey(name: 'stock_quantity') final int stockQuantity,
      @JsonKey(name: 'average_rating') final double averageRating,
      @JsonKey(name: 'review_count') final int reviewCount,
      final String? brand,
      @JsonKey(name: 'serving_size') final String? servingSize,
      @JsonKey(name: 'servings_per_container') final int? servingsPerContainer,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'is_background_white') final bool? isBackgroundWhite,
      final String? sku,
      final List<String>? tags,
      final double? weight,
      final List<String>? size,
      @JsonKey(name: 'flavors') final List<String>? flavor,
      @JsonKey(name: 'nutrition_facts')
      final Map<String, dynamic>? nutritionFacts,
      final bool featured,
      @JsonKey(name: 'new_arrival') final bool newArrival,
      @JsonKey(name: 'best_seller') final bool bestSeller,
      @JsonKey(name: 'total_sales') final int totalSales,
      @JsonKey(name: 'views_count') final int viewsCount,
      @JsonKey(name: 'shipping_weight') final double? shippingWeight,
      final Map<String, dynamic>? dimensions,
      final List<String> ingredients,
      @JsonKey(name: 'usage_instructions') final String? usageInstructions,
      final String? warnings,
      @JsonKey(name: 'expiry_date') final DateTime? expiryDate,
      final String? manufacturer,
      @JsonKey(name: 'country_of_origin') final String? countryOfOrigin,
      @JsonKey(name: 'meta_title') final String? metaTitle,
      @JsonKey(name: 'meta_description') final String? metaDescription,
      final String? slug}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  @JsonKey(name: 'discount_price')
  double? get discountPrice;
  @override // لاحظ استخدام اسم المفتاح الموحد الذي ننتجه في الدالة بالأسفل
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls;
  @override
  String get description;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity;
  @override
  @JsonKey(name: 'average_rating')
  double get averageRating;
  @override
  @JsonKey(name: 'review_count')
  int get reviewCount;
  @override
  String? get brand;
  @override
  @JsonKey(name: 'serving_size')
  String? get servingSize;
  @override
  @JsonKey(name: 'servings_per_container')
  int? get servingsPerContainer;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_background_white')
  bool? get isBackgroundWhite;
  @override
  String? get sku;
  @override
  List<String>? get tags;
  @override
  double? get weight;
  @override
  List<String>? get size;
  @override
  @JsonKey(name: 'flavors')
  List<String>? get flavor;
  @override
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts;
  @override
  bool get featured;
  @override
  @JsonKey(name: 'new_arrival')
  bool get newArrival;
  @override
  @JsonKey(name: 'best_seller')
  bool get bestSeller;
  @override
  @JsonKey(name: 'total_sales')
  int get totalSales;
  @override
  @JsonKey(name: 'views_count')
  int get viewsCount;
  @override
  @JsonKey(name: 'shipping_weight')
  double? get shippingWeight;
  @override
  Map<String, dynamic>? get dimensions;
  @override
  List<String> get ingredients;
  @override
  @JsonKey(name: 'usage_instructions')
  String? get usageInstructions;
  @override
  String? get warnings;
  @override
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;
  @override
  String? get manufacturer;
  @override
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin;
  @override
  @JsonKey(name: 'meta_title')
  String? get metaTitle;
  @override
  @JsonKey(name: 'meta_description')
  String? get metaDescription;
  @override
  String? get slug;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
