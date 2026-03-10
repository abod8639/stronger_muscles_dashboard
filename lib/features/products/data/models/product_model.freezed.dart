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

TranslatableString _$TranslatableStringFromJson(Map<String, dynamic> json) {
  return _TranslatableString.fromJson(json);
}

/// @nodoc
mixin _$TranslatableString {
  @HiveField(0)
  String get ar => throw _privateConstructorUsedError;
  @HiveField(1)
  String get en => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TranslatableStringCopyWith<TranslatableString> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslatableStringCopyWith<$Res> {
  factory $TranslatableStringCopyWith(
          TranslatableString value, $Res Function(TranslatableString) then) =
      _$TranslatableStringCopyWithImpl<$Res, TranslatableString>;
  @useResult
  $Res call({@HiveField(0) String ar, @HiveField(1) String en});
}

/// @nodoc
class _$TranslatableStringCopyWithImpl<$Res, $Val extends TranslatableString>
    implements $TranslatableStringCopyWith<$Res> {
  _$TranslatableStringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ar = null,
    Object? en = null,
  }) {
    return _then(_value.copyWith(
      ar: null == ar
          ? _value.ar
          : ar // ignore: cast_nullable_to_non_nullable
              as String,
      en: null == en
          ? _value.en
          : en // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslatableStringImplCopyWith<$Res>
    implements $TranslatableStringCopyWith<$Res> {
  factory _$$TranslatableStringImplCopyWith(_$TranslatableStringImpl value,
          $Res Function(_$TranslatableStringImpl) then) =
      __$$TranslatableStringImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String ar, @HiveField(1) String en});
}

/// @nodoc
class __$$TranslatableStringImplCopyWithImpl<$Res>
    extends _$TranslatableStringCopyWithImpl<$Res, _$TranslatableStringImpl>
    implements _$$TranslatableStringImplCopyWith<$Res> {
  __$$TranslatableStringImplCopyWithImpl(_$TranslatableStringImpl _value,
      $Res Function(_$TranslatableStringImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ar = null,
    Object? en = null,
  }) {
    return _then(_$TranslatableStringImpl(
      ar: null == ar
          ? _value.ar
          : ar // ignore: cast_nullable_to_non_nullable
              as String,
      en: null == en
          ? _value.en
          : en // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslatableStringImpl extends _TranslatableString
    with DiagnosticableTreeMixin {
  const _$TranslatableStringImpl(
      {@HiveField(0) this.ar = '', @HiveField(1) this.en = ''})
      : super._();

  factory _$TranslatableStringImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslatableStringImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final String ar;
  @override
  @JsonKey()
  @HiveField(1)
  final String en;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TranslatableString(ar: $ar, en: $en)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TranslatableString'))
      ..add(DiagnosticsProperty('ar', ar))
      ..add(DiagnosticsProperty('en', en));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslatableStringImpl &&
            (identical(other.ar, ar) || other.ar == ar) &&
            (identical(other.en, en) || other.en == en));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ar, en);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslatableStringImplCopyWith<_$TranslatableStringImpl> get copyWith =>
      __$$TranslatableStringImplCopyWithImpl<_$TranslatableStringImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslatableStringImplToJson(
      this,
    );
  }
}

abstract class _TranslatableString extends TranslatableString {
  const factory _TranslatableString(
      {@HiveField(0) final String ar,
      @HiveField(1) final String en}) = _$TranslatableStringImpl;
  const _TranslatableString._() : super._();

  factory _TranslatableString.fromJson(Map<String, dynamic> json) =
      _$TranslatableStringImpl.fromJson;

  @override
  @HiveField(0)
  String get ar;
  @override
  @HiveField(1)
  String get en;
  @override
  @JsonKey(ignore: true)
  _$$TranslatableStringImplCopyWith<_$TranslatableStringImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) {
  return _ProductImage.fromJson(json);
}

/// @nodoc
mixin _$ProductImage {
  @HiveField(0)
  String get thumbnail => throw _privateConstructorUsedError;
  @HiveField(1)
  String get medium => throw _privateConstructorUsedError;
  @HiveField(2)
  String get original => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductImageCopyWith<ProductImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductImageCopyWith<$Res> {
  factory $ProductImageCopyWith(
          ProductImage value, $Res Function(ProductImage) then) =
      _$ProductImageCopyWithImpl<$Res, ProductImage>;
  @useResult
  $Res call(
      {@HiveField(0) String thumbnail,
      @HiveField(1) String medium,
      @HiveField(2) String original});
}

/// @nodoc
class _$ProductImageCopyWithImpl<$Res, $Val extends ProductImage>
    implements $ProductImageCopyWith<$Res> {
  _$ProductImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? medium = null,
    Object? original = null,
  }) {
    return _then(_value.copyWith(
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      medium: null == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImageImplCopyWith<$Res>
    implements $ProductImageCopyWith<$Res> {
  factory _$$ProductImageImplCopyWith(
          _$ProductImageImpl value, $Res Function(_$ProductImageImpl) then) =
      __$$ProductImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String thumbnail,
      @HiveField(1) String medium,
      @HiveField(2) String original});
}

/// @nodoc
class __$$ProductImageImplCopyWithImpl<$Res>
    extends _$ProductImageCopyWithImpl<$Res, _$ProductImageImpl>
    implements _$$ProductImageImplCopyWith<$Res> {
  __$$ProductImageImplCopyWithImpl(
      _$ProductImageImpl _value, $Res Function(_$ProductImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = null,
    Object? medium = null,
    Object? original = null,
  }) {
    return _then(_$ProductImageImpl(
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      medium: null == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImageImpl with DiagnosticableTreeMixin implements _ProductImage {
  const _$ProductImageImpl(
      {@HiveField(0) required this.thumbnail,
      @HiveField(1) required this.medium,
      @HiveField(2) required this.original});

  factory _$ProductImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImageImplFromJson(json);

  @override
  @HiveField(0)
  final String thumbnail;
  @override
  @HiveField(1)
  final String medium;
  @override
  @HiveField(2)
  final String original;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductImage(thumbnail: $thumbnail, medium: $medium, original: $original)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductImage'))
      ..add(DiagnosticsProperty('thumbnail', thumbnail))
      ..add(DiagnosticsProperty('medium', medium))
      ..add(DiagnosticsProperty('original', original));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImageImpl &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            (identical(other.original, original) ||
                other.original == original));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, thumbnail, medium, original);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImageImplCopyWith<_$ProductImageImpl> get copyWith =>
      __$$ProductImageImplCopyWithImpl<_$ProductImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImageImplToJson(
      this,
    );
  }
}

abstract class _ProductImage implements ProductImage {
  const factory _ProductImage(
      {@HiveField(0) required final String thumbnail,
      @HiveField(1) required final String medium,
      @HiveField(2) required final String original}) = _$ProductImageImpl;

  factory _ProductImage.fromJson(Map<String, dynamic> json) =
      _$ProductImageImpl.fromJson;

  @override
  @HiveField(0)
  String get thumbnail;
  @override
  @HiveField(1)
  String get medium;
  @override
  @HiveField(2)
  String get original;
  @override
  @JsonKey(ignore: true)
  _$$ProductImageImplCopyWith<_$ProductImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return _ProductCategory.fromJson(json);
}

/// @nodoc
mixin _$ProductCategory {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  TranslatableString get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCategoryCopyWith<ProductCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCategoryCopyWith<$Res> {
  factory $ProductCategoryCopyWith(
          ProductCategory value, $Res Function(ProductCategory) then) =
      _$ProductCategoryCopyWithImpl<$Res, ProductCategory>;
  @useResult
  $Res call({@HiveField(0) String id, @HiveField(1) TranslatableString name});

  $TranslatableStringCopyWith<$Res> get name;
}

/// @nodoc
class _$ProductCategoryCopyWithImpl<$Res, $Val extends ProductCategory>
    implements $ProductCategoryCopyWith<$Res> {
  _$ProductCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as TranslatableString,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TranslatableStringCopyWith<$Res> get name {
    return $TranslatableStringCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductCategoryImplCopyWith<$Res>
    implements $ProductCategoryCopyWith<$Res> {
  factory _$$ProductCategoryImplCopyWith(_$ProductCategoryImpl value,
          $Res Function(_$ProductCategoryImpl) then) =
      __$$ProductCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String id, @HiveField(1) TranslatableString name});

  @override
  $TranslatableStringCopyWith<$Res> get name;
}

/// @nodoc
class __$$ProductCategoryImplCopyWithImpl<$Res>
    extends _$ProductCategoryCopyWithImpl<$Res, _$ProductCategoryImpl>
    implements _$$ProductCategoryImplCopyWith<$Res> {
  __$$ProductCategoryImplCopyWithImpl(
      _$ProductCategoryImpl _value, $Res Function(_$ProductCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$ProductCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as TranslatableString,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductCategoryImpl
    with DiagnosticableTreeMixin
    implements _ProductCategory {
  const _$ProductCategoryImpl(
      {@HiveField(0) required this.id, @HiveField(1) required this.name});

  factory _$ProductCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductCategoryImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final TranslatableString name;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductCategory(id: $id, name: $name)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductCategory'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      __$$ProductCategoryImplCopyWithImpl<_$ProductCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductCategoryImplToJson(
      this,
    );
  }
}

abstract class _ProductCategory implements ProductCategory {
  const factory _ProductCategory(
          {@HiveField(0) required final String id,
          @HiveField(1) required final TranslatableString name}) =
      _$ProductCategoryImpl;

  factory _ProductCategory.fromJson(Map<String, dynamic> json) =
      _$ProductCategoryImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  TranslatableString get name;
  @override
  @JsonKey(ignore: true)
  _$$ProductCategoryImplCopyWith<_$ProductCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) {
  return _ProductVariantModel.fromJson(json);
}

/// @nodoc
mixin _$ProductVariantModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get sku => throw _privateConstructorUsedError;
  @HiveField(2)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  double? get discountPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'effective_price')
  @HiveField(4)
  double get effectivePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  @HiveField(5)
  int get stockQuantity => throw _privateConstructorUsedError;
  @HiveField(6)
  Map<String, dynamic> get attributes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  @HiveField(7)
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_start_date')
  @HiveField(8)
  DateTime? get discountStartDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_end_date')
  @HiveField(9)
  DateTime? get discountEndDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductVariantModelCopyWith<ProductVariantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariantModelCopyWith<$Res> {
  factory $ProductVariantModelCopyWith(
          ProductVariantModel value, $Res Function(ProductVariantModel) then) =
      _$ProductVariantModelCopyWithImpl<$Res, ProductVariantModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String sku,
      @HiveField(2) double price,
      @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
      @JsonKey(name: 'effective_price') @HiveField(4) double effectivePrice,
      @JsonKey(name: 'stock_quantity') @HiveField(5) int stockQuantity,
      @HiveField(6) Map<String, dynamic> attributes,
      @JsonKey(name: 'is_active') @HiveField(7) bool isActive,
      @JsonKey(name: 'discount_start_date')
      @HiveField(8)
      DateTime? discountStartDate,
      @JsonKey(name: 'discount_end_date')
      @HiveField(9)
      DateTime? discountEndDate});
}

/// @nodoc
class _$ProductVariantModelCopyWithImpl<$Res, $Val extends ProductVariantModel>
    implements $ProductVariantModelCopyWith<$Res> {
  _$ProductVariantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? effectivePrice = null,
    Object? stockQuantity = null,
    Object? attributes = null,
    Object? isActive = null,
    Object? discountStartDate = freezed,
    Object? discountEndDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      effectivePrice: null == effectivePrice
          ? _value.effectivePrice
          : effectivePrice // ignore: cast_nullable_to_non_nullable
              as double,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      discountStartDate: freezed == discountStartDate
          ? _value.discountStartDate
          : discountStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEndDate: freezed == discountEndDate
          ? _value.discountEndDate
          : discountEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductVariantModelImplCopyWith<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  factory _$$ProductVariantModelImplCopyWith(_$ProductVariantModelImpl value,
          $Res Function(_$ProductVariantModelImpl) then) =
      __$$ProductVariantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String sku,
      @HiveField(2) double price,
      @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
      @JsonKey(name: 'effective_price') @HiveField(4) double effectivePrice,
      @JsonKey(name: 'stock_quantity') @HiveField(5) int stockQuantity,
      @HiveField(6) Map<String, dynamic> attributes,
      @JsonKey(name: 'is_active') @HiveField(7) bool isActive,
      @JsonKey(name: 'discount_start_date')
      @HiveField(8)
      DateTime? discountStartDate,
      @JsonKey(name: 'discount_end_date')
      @HiveField(9)
      DateTime? discountEndDate});
}

/// @nodoc
class __$$ProductVariantModelImplCopyWithImpl<$Res>
    extends _$ProductVariantModelCopyWithImpl<$Res, _$ProductVariantModelImpl>
    implements _$$ProductVariantModelImplCopyWith<$Res> {
  __$$ProductVariantModelImplCopyWithImpl(_$ProductVariantModelImpl _value,
      $Res Function(_$ProductVariantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? effectivePrice = null,
    Object? stockQuantity = null,
    Object? attributes = null,
    Object? isActive = null,
    Object? discountStartDate = freezed,
    Object? discountEndDate = freezed,
  }) {
    return _then(_$ProductVariantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      effectivePrice: null == effectivePrice
          ? _value.effectivePrice
          : effectivePrice // ignore: cast_nullable_to_non_nullable
              as double,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: null == attributes
          ? _value._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      discountStartDate: freezed == discountStartDate
          ? _value.discountStartDate
          : discountStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEndDate: freezed == discountEndDate
          ? _value.discountEndDate
          : discountEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductVariantModelImpl
    with DiagnosticableTreeMixin
    implements _ProductVariantModel {
  const _$ProductVariantModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.sku,
      @HiveField(2) required this.price,
      @JsonKey(name: 'discount_price') @HiveField(3) this.discountPrice,
      @JsonKey(name: 'effective_price')
      @HiveField(4)
      required this.effectivePrice,
      @JsonKey(name: 'stock_quantity')
      @HiveField(5)
      required this.stockQuantity,
      @HiveField(6) required final Map<String, dynamic> attributes,
      @JsonKey(name: 'is_active') @HiveField(7) this.isActive = true,
      @JsonKey(name: 'discount_start_date')
      @HiveField(8)
      this.discountStartDate,
      @JsonKey(name: 'discount_end_date') @HiveField(9) this.discountEndDate})
      : _attributes = attributes;

  factory _$ProductVariantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVariantModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String sku;
  @override
  @HiveField(2)
  final double price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  final double? discountPrice;
  @override
  @JsonKey(name: 'effective_price')
  @HiveField(4)
  final double effectivePrice;
  @override
  @JsonKey(name: 'stock_quantity')
  @HiveField(5)
  final int stockQuantity;
  final Map<String, dynamic> _attributes;
  @override
  @HiveField(6)
  Map<String, dynamic> get attributes {
    if (_attributes is EqualUnmodifiableMapView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_attributes);
  }

  @override
  @JsonKey(name: 'is_active')
  @HiveField(7)
  final bool isActive;
  @override
  @JsonKey(name: 'discount_start_date')
  @HiveField(8)
  final DateTime? discountStartDate;
  @override
  @JsonKey(name: 'discount_end_date')
  @HiveField(9)
  final DateTime? discountEndDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductVariantModel(id: $id, sku: $sku, price: $price, discountPrice: $discountPrice, effectivePrice: $effectivePrice, stockQuantity: $stockQuantity, attributes: $attributes, isActive: $isActive, discountStartDate: $discountStartDate, discountEndDate: $discountEndDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductVariantModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('sku', sku))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('discountPrice', discountPrice))
      ..add(DiagnosticsProperty('effectivePrice', effectivePrice))
      ..add(DiagnosticsProperty('stockQuantity', stockQuantity))
      ..add(DiagnosticsProperty('attributes', attributes))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('discountStartDate', discountStartDate))
      ..add(DiagnosticsProperty('discountEndDate', discountEndDate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice) &&
            (identical(other.effectivePrice, effectivePrice) ||
                other.effectivePrice == effectivePrice) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.discountStartDate, discountStartDate) ||
                other.discountStartDate == discountStartDate) &&
            (identical(other.discountEndDate, discountEndDate) ||
                other.discountEndDate == discountEndDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sku,
      price,
      discountPrice,
      effectivePrice,
      stockQuantity,
      const DeepCollectionEquality().hash(_attributes),
      isActive,
      discountStartDate,
      discountEndDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariantModelImplCopyWith<_$ProductVariantModelImpl> get copyWith =>
      __$$ProductVariantModelImplCopyWithImpl<_$ProductVariantModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVariantModelImplToJson(
      this,
    );
  }
}

abstract class _ProductVariantModel implements ProductVariantModel {
  const factory _ProductVariantModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String sku,
      @HiveField(2) required final double price,
      @JsonKey(name: 'discount_price')
      @HiveField(3)
      final double? discountPrice,
      @JsonKey(name: 'effective_price')
      @HiveField(4)
      required final double effectivePrice,
      @JsonKey(name: 'stock_quantity')
      @HiveField(5)
      required final int stockQuantity,
      @HiveField(6) required final Map<String, dynamic> attributes,
      @JsonKey(name: 'is_active') @HiveField(7) final bool isActive,
      @JsonKey(name: 'discount_start_date')
      @HiveField(8)
      final DateTime? discountStartDate,
      @JsonKey(name: 'discount_end_date')
      @HiveField(9)
      final DateTime? discountEndDate}) = _$ProductVariantModelImpl;

  factory _ProductVariantModel.fromJson(Map<String, dynamic> json) =
      _$ProductVariantModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get sku;
  @override
  @HiveField(2)
  double get price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  double? get discountPrice;
  @override
  @JsonKey(name: 'effective_price')
  @HiveField(4)
  double get effectivePrice;
  @override
  @JsonKey(name: 'stock_quantity')
  @HiveField(5)
  int get stockQuantity;
  @override
  @HiveField(6)
  Map<String, dynamic> get attributes;
  @override
  @JsonKey(name: 'is_active')
  @HiveField(7)
  bool get isActive;
  @override
  @JsonKey(name: 'discount_start_date')
  @HiveField(8)
  DateTime? get discountStartDate;
  @override
  @JsonKey(name: 'discount_end_date')
  @HiveField(9)
  DateTime? get discountEndDate;
  @override
  @JsonKey(ignore: true)
  _$$ProductVariantModelImplCopyWith<_$ProductVariantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) {
  return _ProductSize.fromJson(json);
}

/// @nodoc
mixin _$ProductSize {
  @HiveField(0)
  String get size => throw _privateConstructorUsedError;
  @HiveField(1)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_price')
  @HiveField(2)
  double? get discountPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductSizeCopyWith<ProductSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSizeCopyWith<$Res> {
  factory $ProductSizeCopyWith(
          ProductSize value, $Res Function(ProductSize) then) =
      _$ProductSizeCopyWithImpl<$Res, ProductSize>;
  @useResult
  $Res call(
      {@HiveField(0) String size,
      @HiveField(1) double price,
      @JsonKey(name: 'discount_price') @HiveField(2) double? discountPrice});
}

/// @nodoc
class _$ProductSizeCopyWithImpl<$Res, $Val extends ProductSize>
    implements $ProductSizeCopyWith<$Res> {
  _$ProductSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = null,
    Object? price = null,
    Object? discountPrice = freezed,
  }) {
    return _then(_value.copyWith(
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductSizeImplCopyWith<$Res>
    implements $ProductSizeCopyWith<$Res> {
  factory _$$ProductSizeImplCopyWith(
          _$ProductSizeImpl value, $Res Function(_$ProductSizeImpl) then) =
      __$$ProductSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String size,
      @HiveField(1) double price,
      @JsonKey(name: 'discount_price') @HiveField(2) double? discountPrice});
}

/// @nodoc
class __$$ProductSizeImplCopyWithImpl<$Res>
    extends _$ProductSizeCopyWithImpl<$Res, _$ProductSizeImpl>
    implements _$$ProductSizeImplCopyWith<$Res> {
  __$$ProductSizeImplCopyWithImpl(
      _$ProductSizeImpl _value, $Res Function(_$ProductSizeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = null,
    Object? price = null,
    Object? discountPrice = freezed,
  }) {
    return _then(_$ProductSizeImpl(
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSizeImpl with DiagnosticableTreeMixin implements _ProductSize {
  const _$ProductSizeImpl(
      {@HiveField(0) required this.size,
      @HiveField(1) required this.price,
      @JsonKey(name: 'discount_price') @HiveField(2) this.discountPrice});

  factory _$ProductSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSizeImplFromJson(json);

  @override
  @HiveField(0)
  final String size;
  @override
  @HiveField(1)
  final double price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(2)
  final double? discountPrice;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductSize(size: $size, price: $price, discountPrice: $discountPrice)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductSize'))
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('discountPrice', discountPrice));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSizeImpl &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, size, price, discountPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSizeImplCopyWith<_$ProductSizeImpl> get copyWith =>
      __$$ProductSizeImplCopyWithImpl<_$ProductSizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSizeImplToJson(
      this,
    );
  }
}

abstract class _ProductSize implements ProductSize {
  const factory _ProductSize(
      {@HiveField(0) required final String size,
      @HiveField(1) required final double price,
      @JsonKey(name: 'discount_price')
      @HiveField(2)
      final double? discountPrice}) = _$ProductSizeImpl;

  factory _ProductSize.fromJson(Map<String, dynamic> json) =
      _$ProductSizeImpl.fromJson;

  @override
  @HiveField(0)
  String get size;
  @override
  @HiveField(1)
  double get price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(2)
  double? get discountPrice;
  @override
  @JsonKey(ignore: true)
  _$$ProductSizeImplCopyWith<_$ProductSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  TranslatableString get name => throw _privateConstructorUsedError;
  @HiveField(2)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  double? get discountPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrls')
  @HiveField(4)
  List<ProductImage> get imageUrls => throw _privateConstructorUsedError;
  @HiveField(5)
  TranslatableString get description =>
      throw _privateConstructorUsedError; // Category: new API returns object, legacy returns category_id string
  @HiveField(6)
  String get categoryId => throw _privateConstructorUsedError;
  @HiveField(27)
  ProductCategory? get category => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'product_sizes')
  @HiveField(19)
  List<ProductSize>? get productSizes => throw _privateConstructorUsedError;
  @JsonKey(name: 'flavors')
  @HiveField(20)
  List<String>? get flavor => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutrition_facts')
  @HiveField(21)
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError;
  @HiveField(22)
  bool get featured => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_arrival')
  @HiveField(23)
  bool get newArrival => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_seller')
  @HiveField(24)
  bool get bestSeller => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sales')
  @HiveField(25)
  int get totalSales =>
      throw _privateConstructorUsedError; // Variants: new API uses 'product_variants', legacy uses 'variants'
  @JsonKey(name: 'product_variants')
  @HiveField(26)
  List<ProductVariantModel> get variants =>
      throw _privateConstructorUsedError; // has_variants flag from API
  @JsonKey(name: 'has_variants')
  @HiveField(28)
  bool get hasVariants => throw _privateConstructorUsedError;

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
      {@HiveField(0) String id,
      @HiveField(1) TranslatableString name,
      @HiveField(2) double price,
      @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
      @JsonKey(name: 'imageUrls') @HiveField(4) List<ProductImage> imageUrls,
      @HiveField(5) TranslatableString description,
      @HiveField(6) String categoryId,
      @HiveField(27) ProductCategory? category,
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
      @JsonKey(name: 'product_sizes')
      @HiveField(19)
      List<ProductSize>? productSizes,
      @JsonKey(name: 'flavors') @HiveField(20) List<String>? flavor,
      @JsonKey(name: 'nutrition_facts')
      @HiveField(21)
      Map<String, dynamic>? nutritionFacts,
      @HiveField(22) bool featured,
      @JsonKey(name: 'new_arrival') @HiveField(23) bool newArrival,
      @JsonKey(name: 'best_seller') @HiveField(24) bool bestSeller,
      @JsonKey(name: 'total_sales') @HiveField(25) int totalSales,
      @JsonKey(name: 'product_variants')
      @HiveField(26)
      List<ProductVariantModel> variants,
      @JsonKey(name: 'has_variants') @HiveField(28) bool hasVariants});

  $TranslatableStringCopyWith<$Res> get name;
  $TranslatableStringCopyWith<$Res> get description;
  $ProductCategoryCopyWith<$Res>? get category;
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
    Object? category = freezed,
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
    Object? productSizes = freezed,
    Object? flavor = freezed,
    Object? nutritionFacts = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? variants = null,
    Object? hasVariants = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as TranslatableString,
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
              as List<ProductImage>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as TranslatableString,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory?,
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
      productSizes: freezed == productSizes
          ? _value.productSizes
          : productSizes // ignore: cast_nullable_to_non_nullable
              as List<ProductSize>?,
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
      variants: null == variants
          ? _value.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TranslatableStringCopyWith<$Res> get name {
    return $TranslatableStringCopyWith<$Res>(_value.name, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TranslatableStringCopyWith<$Res> get description {
    return $TranslatableStringCopyWith<$Res>(_value.description, (value) {
      return _then(_value.copyWith(description: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductCategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $ProductCategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
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
      @HiveField(1) TranslatableString name,
      @HiveField(2) double price,
      @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
      @JsonKey(name: 'imageUrls') @HiveField(4) List<ProductImage> imageUrls,
      @HiveField(5) TranslatableString description,
      @HiveField(6) String categoryId,
      @HiveField(27) ProductCategory? category,
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
      @JsonKey(name: 'product_sizes')
      @HiveField(19)
      List<ProductSize>? productSizes,
      @JsonKey(name: 'flavors') @HiveField(20) List<String>? flavor,
      @JsonKey(name: 'nutrition_facts')
      @HiveField(21)
      Map<String, dynamic>? nutritionFacts,
      @HiveField(22) bool featured,
      @JsonKey(name: 'new_arrival') @HiveField(23) bool newArrival,
      @JsonKey(name: 'best_seller') @HiveField(24) bool bestSeller,
      @JsonKey(name: 'total_sales') @HiveField(25) int totalSales,
      @JsonKey(name: 'product_variants')
      @HiveField(26)
      List<ProductVariantModel> variants,
      @JsonKey(name: 'has_variants') @HiveField(28) bool hasVariants});

  @override
  $TranslatableStringCopyWith<$Res> get name;
  @override
  $TranslatableStringCopyWith<$Res> get description;
  @override
  $ProductCategoryCopyWith<$Res>? get category;
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
    Object? category = freezed,
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
    Object? productSizes = freezed,
    Object? flavor = freezed,
    Object? nutritionFacts = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? variants = null,
    Object? hasVariants = null,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as TranslatableString,
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
              as List<ProductImage>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as TranslatableString,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory?,
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
      productSizes: freezed == productSizes
          ? _value._productSizes
          : productSizes // ignore: cast_nullable_to_non_nullable
              as List<ProductSize>?,
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
      variants: null == variants
          ? _value._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl extends _ProductModel with DiagnosticableTreeMixin {
  const _$ProductModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.price,
      @JsonKey(name: 'discount_price') @HiveField(3) this.discountPrice,
      @JsonKey(name: 'imageUrls')
      @HiveField(4)
      final List<ProductImage> imageUrls = const [],
      @HiveField(5) required this.description,
      @HiveField(6) this.categoryId = '',
      @HiveField(27) this.category,
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
      @JsonKey(name: 'product_sizes')
      @HiveField(19)
      final List<ProductSize>? productSizes = const [],
      @JsonKey(name: 'flavors')
      @HiveField(20)
      final List<String>? flavor = const [],
      @JsonKey(name: 'nutrition_facts')
      @HiveField(21)
      final Map<String, dynamic>? nutritionFacts,
      @HiveField(22) this.featured = false,
      @JsonKey(name: 'new_arrival') @HiveField(23) this.newArrival = false,
      @JsonKey(name: 'best_seller') @HiveField(24) this.bestSeller = false,
      @JsonKey(name: 'total_sales') @HiveField(25) this.totalSales = 0,
      @JsonKey(name: 'product_variants')
      @HiveField(26)
      final List<ProductVariantModel> variants = const [],
      @JsonKey(name: 'has_variants') @HiveField(28) this.hasVariants = false})
      : _imageUrls = imageUrls,
        _tags = tags,
        _size = size,
        _productSizes = productSizes,
        _flavor = flavor,
        _nutritionFacts = nutritionFacts,
        _variants = variants,
        super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final TranslatableString name;
  @override
  @HiveField(2)
  final double price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  final double? discountPrice;
  final List<ProductImage> _imageUrls;
  @override
  @JsonKey(name: 'imageUrls')
  @HiveField(4)
  List<ProductImage> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @HiveField(5)
  final TranslatableString description;
// Category: new API returns object, legacy returns category_id string
  @override
  @JsonKey()
  @HiveField(6)
  final String categoryId;
  @override
  @HiveField(27)
  final ProductCategory? category;
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

  final List<ProductSize>? _productSizes;
  @override
  @JsonKey(name: 'product_sizes')
  @HiveField(19)
  List<ProductSize>? get productSizes {
    final value = _productSizes;
    if (value == null) return null;
    if (_productSizes is EqualUnmodifiableListView) return _productSizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _flavor;
  @override
  @JsonKey(name: 'flavors')
  @HiveField(20)
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
  @HiveField(21)
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  @HiveField(22)
  final bool featured;
  @override
  @JsonKey(name: 'new_arrival')
  @HiveField(23)
  final bool newArrival;
  @override
  @JsonKey(name: 'best_seller')
  @HiveField(24)
  final bool bestSeller;
  @override
  @JsonKey(name: 'total_sales')
  @HiveField(25)
  final int totalSales;
// Variants: new API uses 'product_variants', legacy uses 'variants'
  final List<ProductVariantModel> _variants;
// Variants: new API uses 'product_variants', legacy uses 'variants'
  @override
  @JsonKey(name: 'product_variants')
  @HiveField(26)
  List<ProductVariantModel> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

// has_variants flag from API
  @override
  @JsonKey(name: 'has_variants')
  @HiveField(28)
  final bool hasVariants;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductModel(id: $id, name: $name, price: $price, discountPrice: $discountPrice, imageUrls: $imageUrls, description: $description, categoryId: $categoryId, category: $category, stockQuantity: $stockQuantity, averageRating: $averageRating, reviewCount: $reviewCount, brand: $brand, servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, isActive: $isActive, isBackgroundWhite: $isBackgroundWhite, sku: $sku, tags: $tags, weight: $weight, size: $size, productSizes: $productSizes, flavor: $flavor, nutritionFacts: $nutritionFacts, featured: $featured, newArrival: $newArrival, bestSeller: $bestSeller, totalSales: $totalSales, variants: $variants, hasVariants: $hasVariants)';
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
      ..add(DiagnosticsProperty('category', category))
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
      ..add(DiagnosticsProperty('productSizes', productSizes))
      ..add(DiagnosticsProperty('flavor', flavor))
      ..add(DiagnosticsProperty('nutritionFacts', nutritionFacts))
      ..add(DiagnosticsProperty('featured', featured))
      ..add(DiagnosticsProperty('newArrival', newArrival))
      ..add(DiagnosticsProperty('bestSeller', bestSeller))
      ..add(DiagnosticsProperty('totalSales', totalSales))
      ..add(DiagnosticsProperty('variants', variants))
      ..add(DiagnosticsProperty('hasVariants', hasVariants));
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
            (identical(other.category, category) ||
                other.category == category) &&
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
            const DeepCollectionEquality()
                .equals(other._productSizes, _productSizes) &&
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
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants));
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
        category,
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
        const DeepCollectionEquality().hash(_productSizes),
        const DeepCollectionEquality().hash(_flavor),
        const DeepCollectionEquality().hash(_nutritionFacts),
        featured,
        newArrival,
        bestSeller,
        totalSales,
        const DeepCollectionEquality().hash(_variants),
        hasVariants
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
      {@HiveField(0) required final String id,
      @HiveField(1) required final TranslatableString name,
      @HiveField(2) required final double price,
      @JsonKey(name: 'discount_price')
      @HiveField(3)
      final double? discountPrice,
      @JsonKey(name: 'imageUrls')
      @HiveField(4)
      final List<ProductImage> imageUrls,
      @HiveField(5) required final TranslatableString description,
      @HiveField(6) final String categoryId,
      @HiveField(27) final ProductCategory? category,
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
      @JsonKey(name: 'product_sizes')
      @HiveField(19)
      final List<ProductSize>? productSizes,
      @JsonKey(name: 'flavors') @HiveField(20) final List<String>? flavor,
      @JsonKey(name: 'nutrition_facts')
      @HiveField(21)
      final Map<String, dynamic>? nutritionFacts,
      @HiveField(22) final bool featured,
      @JsonKey(name: 'new_arrival') @HiveField(23) final bool newArrival,
      @JsonKey(name: 'best_seller') @HiveField(24) final bool bestSeller,
      @JsonKey(name: 'total_sales') @HiveField(25) final int totalSales,
      @JsonKey(name: 'product_variants')
      @HiveField(26)
      final List<ProductVariantModel> variants,
      @JsonKey(name: 'has_variants')
      @HiveField(28)
      final bool hasVariants}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  TranslatableString get name;
  @override
  @HiveField(2)
  double get price;
  @override
  @JsonKey(name: 'discount_price')
  @HiveField(3)
  double? get discountPrice;
  @override
  @JsonKey(name: 'imageUrls')
  @HiveField(4)
  List<ProductImage> get imageUrls;
  @override
  @HiveField(5)
  TranslatableString get description;
  @override // Category: new API returns object, legacy returns category_id string
  @HiveField(6)
  String get categoryId;
  @override
  @HiveField(27)
  ProductCategory? get category;
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
  @JsonKey(name: 'product_sizes')
  @HiveField(19)
  List<ProductSize>? get productSizes;
  @override
  @JsonKey(name: 'flavors')
  @HiveField(20)
  List<String>? get flavor;
  @override
  @JsonKey(name: 'nutrition_facts')
  @HiveField(21)
  Map<String, dynamic>? get nutritionFacts;
  @override
  @HiveField(22)
  bool get featured;
  @override
  @JsonKey(name: 'new_arrival')
  @HiveField(23)
  bool get newArrival;
  @override
  @JsonKey(name: 'best_seller')
  @HiveField(24)
  bool get bestSeller;
  @override
  @JsonKey(name: 'total_sales')
  @HiveField(25)
  int get totalSales;
  @override // Variants: new API uses 'product_variants', legacy uses 'variants'
  @JsonKey(name: 'product_variants')
  @HiveField(26)
  List<ProductVariantModel> get variants;
  @override // has_variants flag from API
  @JsonKey(name: 'has_variants')
  @HiveField(28)
  bool get hasVariants;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
