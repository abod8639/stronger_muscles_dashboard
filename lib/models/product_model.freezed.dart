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

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  double get price => throw _privateConstructorUsedError;
  @HiveField(3)
  double? get discountPrice => throw _privateConstructorUsedError;
  @HiveField(4)
  List<String> get imageUrls => throw _privateConstructorUsedError;
  @HiveField(5)
  String get description => throw _privateConstructorUsedError;
  @HiveField(6)
  String get categoryId => throw _privateConstructorUsedError;
  @HiveField(7)
  int get stockQuantity => throw _privateConstructorUsedError;
  @HiveField(8)
  double get averageRating => throw _privateConstructorUsedError;
  @HiveField(9)
  int get reviewCount => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get servingSize => throw _privateConstructorUsedError;
  @HiveField(12)
  int? get servingsPerContainer => throw _privateConstructorUsedError;
  @HiveField(13)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get isBackgroundWhite =>
      throw _privateConstructorUsedError; // Basic Info
  @HiveField(15)
  String? get sku => throw _privateConstructorUsedError;
  @HiveField(16)
  List<String>? get tags => throw _privateConstructorUsedError;
  @HiveField(17)
  double? get weight => throw _privateConstructorUsedError;
  @HiveField(18)
  List<String> get size => throw _privateConstructorUsedError;
  @HiveField(19)
  @JsonKey(name: 'flavors')
  List<String> get flavor =>
      throw _privateConstructorUsedError; // Nutrition & Shipping (بشكل خرائط)
  @HiveField(20)
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError;
  @HiveField(21)
  Map<String, dynamic>? get dimensions =>
      throw _privateConstructorUsedError; // Marketing
  @HiveField(22)
  bool get featured => throw _privateConstructorUsedError;
  @HiveField(23)
  bool get newArrival => throw _privateConstructorUsedError;
  @HiveField(24)
  bool get bestSeller => throw _privateConstructorUsedError;
  @HiveField(25)
  int get totalSales => throw _privateConstructorUsedError;
  @HiveField(26)
  int get viewsCount => throw _privateConstructorUsedError; // Additional
  @HiveField(27)
  String? get ingredients => throw _privateConstructorUsedError;
  @HiveField(28)
  String? get usageInstructions => throw _privateConstructorUsedError;
  @HiveField(29)
  String? get warnings => throw _privateConstructorUsedError;
  @HiveField(30)
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  @HiveField(31)
  String? get manufacturer => throw _privateConstructorUsedError;
  @HiveField(32)
  String? get countryOfOrigin => throw _privateConstructorUsedError; // SEO
  @HiveField(33)
  String? get metaTitle => throw _privateConstructorUsedError;
  @HiveField(34)
  String? get metaDescription => throw _privateConstructorUsedError;
  @HiveField(35)
  String? get slug => throw _privateConstructorUsedError;

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
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double price,
      @HiveField(3) double? discountPrice,
      @HiveField(4) List<String> imageUrls,
      @HiveField(5) String description,
      @HiveField(6) String categoryId,
      @HiveField(7) int stockQuantity,
      @HiveField(8) double averageRating,
      @HiveField(9) int reviewCount,
      @HiveField(10) String? brand,
      @HiveField(11) String? servingSize,
      @HiveField(12) int? servingsPerContainer,
      @HiveField(13) bool isActive,
      @HiveField(14) bool isBackgroundWhite,
      @HiveField(15) String? sku,
      @HiveField(16) List<String>? tags,
      @HiveField(17) double? weight,
      @HiveField(18) List<String> size,
      @HiveField(19) @JsonKey(name: 'flavors') List<String> flavor,
      @HiveField(20) Map<String, dynamic>? nutritionFacts,
      @HiveField(21) Map<String, dynamic>? dimensions,
      @HiveField(22) bool featured,
      @HiveField(23) bool newArrival,
      @HiveField(24) bool bestSeller,
      @HiveField(25) int totalSales,
      @HiveField(26) int viewsCount,
      @HiveField(27) String? ingredients,
      @HiveField(28) String? usageInstructions,
      @HiveField(29) String? warnings,
      @HiveField(30) DateTime? expiryDate,
      @HiveField(31) String? manufacturer,
      @HiveField(32) String? countryOfOrigin,
      @HiveField(33) String? metaTitle,
      @HiveField(34) String? metaDescription,
      @HiveField(35) String? slug});
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
    Object? isBackgroundWhite = null,
    Object? sku = freezed,
    Object? tags = freezed,
    Object? weight = freezed,
    Object? size = null,
    Object? flavor = null,
    Object? nutritionFacts = freezed,
    Object? dimensions = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? viewsCount = null,
    Object? ingredients = freezed,
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
      isBackgroundWhite: null == isBackgroundWhite
          ? _value.isBackgroundWhite
          : isBackgroundWhite // ignore: cast_nullable_to_non_nullable
              as bool,
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
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as List<String>,
      flavor: null == flavor
          ? _value.flavor
          : flavor // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFacts: freezed == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
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
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double price,
      @HiveField(3) double? discountPrice,
      @HiveField(4) List<String> imageUrls,
      @HiveField(5) String description,
      @HiveField(6) String categoryId,
      @HiveField(7) int stockQuantity,
      @HiveField(8) double averageRating,
      @HiveField(9) int reviewCount,
      @HiveField(10) String? brand,
      @HiveField(11) String? servingSize,
      @HiveField(12) int? servingsPerContainer,
      @HiveField(13) bool isActive,
      @HiveField(14) bool isBackgroundWhite,
      @HiveField(15) String? sku,
      @HiveField(16) List<String>? tags,
      @HiveField(17) double? weight,
      @HiveField(18) List<String> size,
      @HiveField(19) @JsonKey(name: 'flavors') List<String> flavor,
      @HiveField(20) Map<String, dynamic>? nutritionFacts,
      @HiveField(21) Map<String, dynamic>? dimensions,
      @HiveField(22) bool featured,
      @HiveField(23) bool newArrival,
      @HiveField(24) bool bestSeller,
      @HiveField(25) int totalSales,
      @HiveField(26) int viewsCount,
      @HiveField(27) String? ingredients,
      @HiveField(28) String? usageInstructions,
      @HiveField(29) String? warnings,
      @HiveField(30) DateTime? expiryDate,
      @HiveField(31) String? manufacturer,
      @HiveField(32) String? countryOfOrigin,
      @HiveField(33) String? metaTitle,
      @HiveField(34) String? metaDescription,
      @HiveField(35) String? slug});
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
    Object? isBackgroundWhite = null,
    Object? sku = freezed,
    Object? tags = freezed,
    Object? weight = freezed,
    Object? size = null,
    Object? flavor = null,
    Object? nutritionFacts = freezed,
    Object? dimensions = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? viewsCount = null,
    Object? ingredients = freezed,
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
      isBackgroundWhite: null == isBackgroundWhite
          ? _value.isBackgroundWhite
          : isBackgroundWhite // ignore: cast_nullable_to_non_nullable
              as bool,
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
      size: null == size
          ? _value._size
          : size // ignore: cast_nullable_to_non_nullable
              as List<String>,
      flavor: null == flavor
          ? _value._flavor
          : flavor // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionFacts: freezed == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      dimensions: freezed == dimensions
          ? _value._dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
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
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as String?,
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

class _$ProductModelImpl extends _ProductModel {
  const _$ProductModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) this.price = 0.0,
      @HiveField(3) this.discountPrice,
      @HiveField(4) final List<String> imageUrls = const [],
      @HiveField(5) this.description = '',
      @HiveField(6) required this.categoryId,
      @HiveField(7) this.stockQuantity = 0,
      @HiveField(8) this.averageRating = 0.0,
      @HiveField(9) this.reviewCount = 0,
      @HiveField(10) this.brand,
      @HiveField(11) this.servingSize,
      @HiveField(12) this.servingsPerContainer,
      @HiveField(13) this.isActive = true,
      @HiveField(14) this.isBackgroundWhite = false,
      @HiveField(15) this.sku,
      @HiveField(16) final List<String>? tags,
      @HiveField(17) this.weight,
      @HiveField(18) final List<String> size = const [],
      @HiveField(19)
      @JsonKey(name: 'flavors')
      final List<String> flavor = const [],
      @HiveField(20) final Map<String, dynamic>? nutritionFacts,
      @HiveField(21) final Map<String, dynamic>? dimensions,
      @HiveField(22) this.featured = false,
      @HiveField(23) this.newArrival = false,
      @HiveField(24) this.bestSeller = false,
      @HiveField(25) this.totalSales = 0,
      @HiveField(26) this.viewsCount = 0,
      @HiveField(27) this.ingredients,
      @HiveField(28) this.usageInstructions,
      @HiveField(29) this.warnings,
      @HiveField(30) this.expiryDate,
      @HiveField(31) this.manufacturer,
      @HiveField(32) this.countryOfOrigin,
      @HiveField(33) this.metaTitle,
      @HiveField(34) this.metaDescription,
      @HiveField(35) this.slug})
      : _imageUrls = imageUrls,
        _tags = tags,
        _size = size,
        _flavor = flavor,
        _nutritionFacts = nutritionFacts,
        _dimensions = dimensions,
        super._();

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @JsonKey()
  @HiveField(2)
  final double price;
  @override
  @HiveField(3)
  final double? discountPrice;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  @HiveField(4)
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  @HiveField(5)
  final String description;
  @override
  @HiveField(6)
  final String categoryId;
  @override
  @JsonKey()
  @HiveField(7)
  final int stockQuantity;
  @override
  @JsonKey()
  @HiveField(8)
  final double averageRating;
  @override
  @JsonKey()
  @HiveField(9)
  final int reviewCount;
  @override
  @HiveField(10)
  final String? brand;
  @override
  @HiveField(11)
  final String? servingSize;
  @override
  @HiveField(12)
  final int? servingsPerContainer;
  @override
  @JsonKey()
  @HiveField(13)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(14)
  final bool isBackgroundWhite;
// Basic Info
  @override
  @HiveField(15)
  final String? sku;
  final List<String>? _tags;
  @override
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
  final List<String> _size;
  @override
  @JsonKey()
  @HiveField(18)
  List<String> get size {
    if (_size is EqualUnmodifiableListView) return _size;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_size);
  }

  final List<String> _flavor;
  @override
  @HiveField(19)
  @JsonKey(name: 'flavors')
  List<String> get flavor {
    if (_flavor is EqualUnmodifiableListView) return _flavor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flavor);
  }

// Nutrition & Shipping (بشكل خرائط)
  final Map<String, dynamic>? _nutritionFacts;
// Nutrition & Shipping (بشكل خرائط)
  @override
  @HiveField(20)
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _dimensions;
  @override
  @HiveField(21)
  Map<String, dynamic>? get dimensions {
    final value = _dimensions;
    if (value == null) return null;
    if (_dimensions is EqualUnmodifiableMapView) return _dimensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Marketing
  @override
  @JsonKey()
  @HiveField(22)
  final bool featured;
  @override
  @JsonKey()
  @HiveField(23)
  final bool newArrival;
  @override
  @JsonKey()
  @HiveField(24)
  final bool bestSeller;
  @override
  @JsonKey()
  @HiveField(25)
  final int totalSales;
  @override
  @JsonKey()
  @HiveField(26)
  final int viewsCount;
// Additional
  @override
  @HiveField(27)
  final String? ingredients;
  @override
  @HiveField(28)
  final String? usageInstructions;
  @override
  @HiveField(29)
  final String? warnings;
  @override
  @HiveField(30)
  final DateTime? expiryDate;
  @override
  @HiveField(31)
  final String? manufacturer;
  @override
  @HiveField(32)
  final String? countryOfOrigin;
// SEO
  @override
  @HiveField(33)
  final String? metaTitle;
  @override
  @HiveField(34)
  final String? metaDescription;
  @override
  @HiveField(35)
  final String? slug;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, discountPrice: $discountPrice, imageUrls: $imageUrls, description: $description, categoryId: $categoryId, stockQuantity: $stockQuantity, averageRating: $averageRating, reviewCount: $reviewCount, brand: $brand, servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, isActive: $isActive, isBackgroundWhite: $isBackgroundWhite, sku: $sku, tags: $tags, weight: $weight, size: $size, flavor: $flavor, nutritionFacts: $nutritionFacts, dimensions: $dimensions, featured: $featured, newArrival: $newArrival, bestSeller: $bestSeller, totalSales: $totalSales, viewsCount: $viewsCount, ingredients: $ingredients, usageInstructions: $usageInstructions, warnings: $warnings, expiryDate: $expiryDate, manufacturer: $manufacturer, countryOfOrigin: $countryOfOrigin, metaTitle: $metaTitle, metaDescription: $metaDescription, slug: $slug)';
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
            const DeepCollectionEquality()
                .equals(other._dimensions, _dimensions) &&
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
            (identical(other.ingredients, ingredients) ||
                other.ingredients == ingredients) &&
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
        const DeepCollectionEquality().hash(_dimensions),
        featured,
        newArrival,
        bestSeller,
        totalSales,
        viewsCount,
        ingredients,
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
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) final double price,
      @HiveField(3) final double? discountPrice,
      @HiveField(4) final List<String> imageUrls,
      @HiveField(5) final String description,
      @HiveField(6) required final String categoryId,
      @HiveField(7) final int stockQuantity,
      @HiveField(8) final double averageRating,
      @HiveField(9) final int reviewCount,
      @HiveField(10) final String? brand,
      @HiveField(11) final String? servingSize,
      @HiveField(12) final int? servingsPerContainer,
      @HiveField(13) final bool isActive,
      @HiveField(14) final bool isBackgroundWhite,
      @HiveField(15) final String? sku,
      @HiveField(16) final List<String>? tags,
      @HiveField(17) final double? weight,
      @HiveField(18) final List<String> size,
      @HiveField(19) @JsonKey(name: 'flavors') final List<String> flavor,
      @HiveField(20) final Map<String, dynamic>? nutritionFacts,
      @HiveField(21) final Map<String, dynamic>? dimensions,
      @HiveField(22) final bool featured,
      @HiveField(23) final bool newArrival,
      @HiveField(24) final bool bestSeller,
      @HiveField(25) final int totalSales,
      @HiveField(26) final int viewsCount,
      @HiveField(27) final String? ingredients,
      @HiveField(28) final String? usageInstructions,
      @HiveField(29) final String? warnings,
      @HiveField(30) final DateTime? expiryDate,
      @HiveField(31) final String? manufacturer,
      @HiveField(32) final String? countryOfOrigin,
      @HiveField(33) final String? metaTitle,
      @HiveField(34) final String? metaDescription,
      @HiveField(35) final String? slug}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

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
  @HiveField(3)
  double? get discountPrice;
  @override
  @HiveField(4)
  List<String> get imageUrls;
  @override
  @HiveField(5)
  String get description;
  @override
  @HiveField(6)
  String get categoryId;
  @override
  @HiveField(7)
  int get stockQuantity;
  @override
  @HiveField(8)
  double get averageRating;
  @override
  @HiveField(9)
  int get reviewCount;
  @override
  @HiveField(10)
  String? get brand;
  @override
  @HiveField(11)
  String? get servingSize;
  @override
  @HiveField(12)
  int? get servingsPerContainer;
  @override
  @HiveField(13)
  bool get isActive;
  @override
  @HiveField(14)
  bool get isBackgroundWhite;
  @override // Basic Info
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
  List<String> get size;
  @override
  @HiveField(19)
  @JsonKey(name: 'flavors')
  List<String> get flavor;
  @override // Nutrition & Shipping (بشكل خرائط)
  @HiveField(20)
  Map<String, dynamic>? get nutritionFacts;
  @override
  @HiveField(21)
  Map<String, dynamic>? get dimensions;
  @override // Marketing
  @HiveField(22)
  bool get featured;
  @override
  @HiveField(23)
  bool get newArrival;
  @override
  @HiveField(24)
  bool get bestSeller;
  @override
  @HiveField(25)
  int get totalSales;
  @override
  @HiveField(26)
  int get viewsCount;
  @override // Additional
  @HiveField(27)
  String? get ingredients;
  @override
  @HiveField(28)
  String? get usageInstructions;
  @override
  @HiveField(29)
  String? get warnings;
  @override
  @HiveField(30)
  DateTime? get expiryDate;
  @override
  @HiveField(31)
  String? get manufacturer;
  @override
  @HiveField(32)
  String? get countryOfOrigin;
  @override // SEO
  @HiveField(33)
  String? get metaTitle;
  @override
  @HiveField(34)
  String? get metaDescription;
  @override
  @HiveField(35)
  String? get slug;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
