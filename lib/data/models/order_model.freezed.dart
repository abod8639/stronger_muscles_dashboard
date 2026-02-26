// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get orderDate => throw _privateConstructorUsedError;
  @HiveField(3)
  OrderStatus get status => throw _privateConstructorUsedError;
  @HiveField(4)
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  @HiveField(5)
  String get paymentMethod => throw _privateConstructorUsedError;
  @HiveField(6)
  String get addressId => throw _privateConstructorUsedError;
  @HiveField(7)
  double get subtotal => throw _privateConstructorUsedError;
  @HiveField(8)
  double get shippingCost => throw _privateConstructorUsedError;
  @HiveField(9)
  double get discount => throw _privateConstructorUsedError;
  @HiveField(10)
  double get totalAmount => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get trackingNumber => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get phoneNumber => throw _privateConstructorUsedError;
  @HiveField(14)
  AddressModel? get shippingAddress => throw _privateConstructorUsedError;
  @HiveField(15)
  List<OrderItemModel>? get items => throw _privateConstructorUsedError;
  @HiveField(16)
  UserModel? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) DateTime orderDate,
      @HiveField(3) OrderStatus status,
      @HiveField(4) PaymentStatus paymentStatus,
      @HiveField(5) String paymentMethod,
      @HiveField(6) String addressId,
      @HiveField(7) double subtotal,
      @HiveField(8) double shippingCost,
      @HiveField(9) double discount,
      @HiveField(10) double totalAmount,
      @HiveField(11) String? trackingNumber,
      @HiveField(12) String? notes,
      @HiveField(13) String? phoneNumber,
      @HiveField(14) AddressModel? shippingAddress,
      @HiveField(15) List<OrderItemModel>? items,
      @HiveField(16) UserModel? user});

  $AddressModelCopyWith<$Res>? get shippingAddress;
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orderDate = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? addressId = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? trackingNumber = freezed,
    Object? notes = freezed,
    Object? phoneNumber = freezed,
    Object? shippingAddress = freezed,
    Object? items = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: null == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      addressId: null == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.shippingAddress!, (value) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String userId,
      @HiveField(2) DateTime orderDate,
      @HiveField(3) OrderStatus status,
      @HiveField(4) PaymentStatus paymentStatus,
      @HiveField(5) String paymentMethod,
      @HiveField(6) String addressId,
      @HiveField(7) double subtotal,
      @HiveField(8) double shippingCost,
      @HiveField(9) double discount,
      @HiveField(10) double totalAmount,
      @HiveField(11) String? trackingNumber,
      @HiveField(12) String? notes,
      @HiveField(13) String? phoneNumber,
      @HiveField(14) AddressModel? shippingAddress,
      @HiveField(15) List<OrderItemModel>? items,
      @HiveField(16) UserModel? user});

  @override
  $AddressModelCopyWith<$Res>? get shippingAddress;
  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? orderDate = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? paymentMethod = null,
    Object? addressId = null,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? trackingNumber = freezed,
    Object? notes = freezed,
    Object? phoneNumber = freezed,
    Object? shippingAddress = freezed,
    Object? items = freezed,
    Object? user = freezed,
  }) {
    return _then(_$OrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      orderDate: null == orderDate
          ? _value.orderDate
          : orderDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      addressId: null == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl extends _OrderModel {
  const _$OrderModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.userId,
      @HiveField(2) required this.orderDate,
      @HiveField(3) this.status = OrderStatus.pending,
      @HiveField(4) this.paymentStatus = PaymentStatus.pending,
      @HiveField(5) this.paymentMethod = 'card',
      @HiveField(6) required this.addressId,
      @HiveField(7) required this.subtotal,
      @HiveField(8) this.shippingCost = 0.0,
      @HiveField(9) this.discount = 0.0,
      @HiveField(10) required this.totalAmount,
      @HiveField(11) this.trackingNumber,
      @HiveField(12) this.notes,
      @HiveField(13) this.phoneNumber,
      @HiveField(14) this.shippingAddress,
      @HiveField(15) final List<OrderItemModel>? items,
      @HiveField(16) this.user})
      : _items = items,
        super._();

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String userId;
  @override
  @HiveField(2)
  final DateTime orderDate;
  @override
  @JsonKey()
  @HiveField(3)
  final OrderStatus status;
  @override
  @JsonKey()
  @HiveField(4)
  final PaymentStatus paymentStatus;
  @override
  @JsonKey()
  @HiveField(5)
  final String paymentMethod;
  @override
  @HiveField(6)
  final String addressId;
  @override
  @HiveField(7)
  final double subtotal;
  @override
  @JsonKey()
  @HiveField(8)
  final double shippingCost;
  @override
  @JsonKey()
  @HiveField(9)
  final double discount;
  @override
  @HiveField(10)
  final double totalAmount;
  @override
  @HiveField(11)
  final String? trackingNumber;
  @override
  @HiveField(12)
  final String? notes;
  @override
  @HiveField(13)
  final String? phoneNumber;
  @override
  @HiveField(14)
  final AddressModel? shippingAddress;
  final List<OrderItemModel>? _items;
  @override
  @HiveField(15)
  List<OrderItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(16)
  final UserModel? user;

  @override
  String toString() {
    return 'OrderModel(id: $id, userId: $userId, orderDate: $orderDate, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, addressId: $addressId, subtotal: $subtotal, shippingCost: $shippingCost, discount: $discount, totalAmount: $totalAmount, trackingNumber: $trackingNumber, notes: $notes, phoneNumber: $phoneNumber, shippingAddress: $shippingAddress, items: $items, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      orderDate,
      status,
      paymentStatus,
      paymentMethod,
      addressId,
      subtotal,
      shippingCost,
      discount,
      totalAmount,
      trackingNumber,
      notes,
      phoneNumber,
      shippingAddress,
      const DeepCollectionEquality().hash(_items),
      user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel extends OrderModel {
  const factory _OrderModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String userId,
      @HiveField(2) required final DateTime orderDate,
      @HiveField(3) final OrderStatus status,
      @HiveField(4) final PaymentStatus paymentStatus,
      @HiveField(5) final String paymentMethod,
      @HiveField(6) required final String addressId,
      @HiveField(7) required final double subtotal,
      @HiveField(8) final double shippingCost,
      @HiveField(9) final double discount,
      @HiveField(10) required final double totalAmount,
      @HiveField(11) final String? trackingNumber,
      @HiveField(12) final String? notes,
      @HiveField(13) final String? phoneNumber,
      @HiveField(14) final AddressModel? shippingAddress,
      @HiveField(15) final List<OrderItemModel>? items,
      @HiveField(16) final UserModel? user}) = _$OrderModelImpl;
  const _OrderModel._() : super._();

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get userId;
  @override
  @HiveField(2)
  DateTime get orderDate;
  @override
  @HiveField(3)
  OrderStatus get status;
  @override
  @HiveField(4)
  PaymentStatus get paymentStatus;
  @override
  @HiveField(5)
  String get paymentMethod;
  @override
  @HiveField(6)
  String get addressId;
  @override
  @HiveField(7)
  double get subtotal;
  @override
  @HiveField(8)
  double get shippingCost;
  @override
  @HiveField(9)
  double get discount;
  @override
  @HiveField(10)
  double get totalAmount;
  @override
  @HiveField(11)
  String? get trackingNumber;
  @override
  @HiveField(12)
  String? get notes;
  @override
  @HiveField(13)
  String? get phoneNumber;
  @override
  @HiveField(14)
  AddressModel? get shippingAddress;
  @override
  @HiveField(15)
  List<OrderItemModel>? get items;
  @override
  @HiveField(16)
  UserModel? get user;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get orderId => throw _privateConstructorUsedError;
  @HiveField(2)
  String get productId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get productName => throw _privateConstructorUsedError;
  @HiveField(4)
  double get unitPrice => throw _privateConstructorUsedError;
  @HiveField(5)
  int get quantity => throw _privateConstructorUsedError;
  @HiveField(6)
  double get subtotal => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get selectedFlavor => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get selectedSize => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get fullName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) then) =
      _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String orderId,
      @HiveField(2) String productId,
      @HiveField(3) String productName,
      @HiveField(4) double unitPrice,
      @HiveField(5) int quantity,
      @HiveField(6) double subtotal,
      @HiveField(7) String? imageUrl,
      @HiveField(8) String? selectedFlavor,
      @HiveField(9) String? selectedSize,
      @HiveField(10) String? fullName});
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? productName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? subtotal = null,
    Object? imageUrl = freezed,
    Object? selectedFlavor = freezed,
    Object? selectedSize = freezed,
    Object? fullName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFlavor: freezed == selectedFlavor
          ? _value.selectedFlavor
          : selectedFlavor // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSize: freezed == selectedSize
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(_$OrderItemModelImpl value,
          $Res Function(_$OrderItemModelImpl) then) =
      __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String orderId,
      @HiveField(2) String productId,
      @HiveField(3) String productName,
      @HiveField(4) double unitPrice,
      @HiveField(5) int quantity,
      @HiveField(6) double subtotal,
      @HiveField(7) String? imageUrl,
      @HiveField(8) String? selectedFlavor,
      @HiveField(9) String? selectedSize,
      @HiveField(10) String? fullName});
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
      _$OrderItemModelImpl _value, $Res Function(_$OrderItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = null,
    Object? productName = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? subtotal = null,
    Object? imageUrl = freezed,
    Object? selectedFlavor = freezed,
    Object? selectedSize = freezed,
    Object? fullName = freezed,
  }) {
    return _then(_$OrderItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFlavor: freezed == selectedFlavor
          ? _value.selectedFlavor
          : selectedFlavor // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSize: freezed == selectedSize
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl extends _OrderItemModel {
  const _$OrderItemModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.orderId,
      @HiveField(2) required this.productId,
      @HiveField(3) required this.productName,
      @HiveField(4) required this.unitPrice,
      @HiveField(5) required this.quantity,
      @HiveField(6) required this.subtotal,
      @HiveField(7) this.imageUrl,
      @HiveField(8) this.selectedFlavor,
      @HiveField(9) this.selectedSize,
      @HiveField(10) this.fullName})
      : super._();

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String orderId;
  @override
  @HiveField(2)
  final String productId;
  @override
  @HiveField(3)
  final String productName;
  @override
  @HiveField(4)
  final double unitPrice;
  @override
  @HiveField(5)
  final int quantity;
  @override
  @HiveField(6)
  final double subtotal;
  @override
  @HiveField(7)
  final String? imageUrl;
  @override
  @HiveField(8)
  final String? selectedFlavor;
  @override
  @HiveField(9)
  final String? selectedSize;
  @override
  @HiveField(10)
  final String? fullName;

  @override
  String toString() {
    return 'OrderItemModel(id: $id, orderId: $orderId, productId: $productId, productName: $productName, unitPrice: $unitPrice, quantity: $quantity, subtotal: $subtotal, imageUrl: $imageUrl, selectedFlavor: $selectedFlavor, selectedSize: $selectedSize, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                other.selectedFlavor == selectedFlavor) &&
            (identical(other.selectedSize, selectedSize) ||
                other.selectedSize == selectedSize) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderId,
      productId,
      productName,
      unitPrice,
      quantity,
      subtotal,
      imageUrl,
      selectedFlavor,
      selectedSize,
      fullName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(
      this,
    );
  }
}

abstract class _OrderItemModel extends OrderItemModel {
  const factory _OrderItemModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String orderId,
      @HiveField(2) required final String productId,
      @HiveField(3) required final String productName,
      @HiveField(4) required final double unitPrice,
      @HiveField(5) required final int quantity,
      @HiveField(6) required final double subtotal,
      @HiveField(7) final String? imageUrl,
      @HiveField(8) final String? selectedFlavor,
      @HiveField(9) final String? selectedSize,
      @HiveField(10) final String? fullName}) = _$OrderItemModelImpl;
  const _OrderItemModel._() : super._();

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get orderId;
  @override
  @HiveField(2)
  String get productId;
  @override
  @HiveField(3)
  String get productName;
  @override
  @HiveField(4)
  double get unitPrice;
  @override
  @HiveField(5)
  int get quantity;
  @override
  @HiveField(6)
  double get subtotal;
  @override
  @HiveField(7)
  String? get imageUrl;
  @override
  @HiveField(8)
  String? get selectedFlavor;
  @override
  @HiveField(9)
  String? get selectedSize;
  @override
  @HiveField(10)
  String? get fullName;
  @override
  @JsonKey(ignore: true)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
