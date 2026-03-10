// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressResource _$AddressResourceFromJson(Map<String, dynamic> json) =>
    AddressResource(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      label: json['label'] as String?,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      isDefault: json['is_default'] as bool,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$AddressResourceToJson(AddressResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'label': instance.label,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'is_default': instance.isDefault,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      price: json['price'] as String,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      quantity: (json['quantity'] as num).toInt(),
      addedAt: DateTime.parse(json['added_at'] as String),
      flavors: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      size:
          (json['size'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
              [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'price': instance.price,
      'image_urls': instance.imageUrls,
      'quantity': instance.quantity,
      'added_at': instance.addedAt.toIso8601String(),
      'flavors': instance.flavors,
      'size': instance.size,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CategoryResource _$CategoryResourceFromJson(Map<String, dynamic> json) =>
    CategoryResource(
      id: json['id'] as String,
      name:
          (json['name'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
              [],
      description: (json['description'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
      icon: json['icon'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
      productsCount: (json['productsCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$CategoryResourceToJson(CategoryResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'icon': instance.icon,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'productsCount': instance.productsCount,
      'createdAt': instance.createdAt,
    };

OrderItemResource _$OrderItemResourceFromJson(Map<String, dynamic> json) =>
    OrderItemResource(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      selectedFlavor: json['selected_flavor'] as String?,
      selectedSize: json['selected_size'] as String?,
      $selectedFlavor: json['selectedFlavor'] as String?,
      $selectedSize: json['selectedSize'] as String?,
    );

Map<String, dynamic> _$OrderItemResourceToJson(OrderItemResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      'image_url': instance.imageUrl,
      'selected_flavor': instance.selectedFlavor,
      'selected_size': instance.selectedSize,
      'selectedFlavor': instance.$selectedFlavor,
      'selectedSize': instance.$selectedSize,
    };

OrderResource _$OrderResourceFromJson(Map<String, dynamic> json) =>
    OrderResource(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderDate: json['order_date'],
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String,
      addressId: json['address_id'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      trackingNumber: json['tracking_number'] as String?,
      phoneNumber: json['phone_number'] as String,
      notes: json['notes'] as String?,
      shippingAddress: (json['shipping_address'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      orderItems: (json['order_items'] as List<dynamic>?)
              ?.map(
                  (e) => OrderItemResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$OrderResourceToJson(OrderResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'order_date': instance.orderDate,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'address_id': instance.addressId,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'discount': instance.discount,
      'total_amount': instance.totalAmount,
      'tracking_number': instance.trackingNumber,
      'phone_number': instance.phoneNumber,
      'notes': instance.notes,
      'shipping_address': instance.shippingAddress,
      'order_items': instance.orderItems?.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

ProductResource _$ProductResourceFromJson(Map<String, dynamic> json) =>
    ProductResource(
      id: json['id'] as String,
      name:
          (json['name'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
              [],
      description: (json['description'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      brand: json['brand'] as String,
      category: json['category'] == null
          ? null
          : ProductResource$Category.fromJson(
              json['category'] as Map<String, dynamic>),
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => ProductResource$ImageUrls$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      hasVariants: json['has_variants'] as bool,
      productVariants: (json['product_variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      averageRating: (json['average_rating'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      servingSize: json['serving_size'] as String?,
      servingsPerContainer: (json['servings_per_container'] as num).toInt(),
      nutritionFacts: (json['nutrition_facts'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      flavors: json['flavors'],
      productSizes: json['product_sizes'],
      size: json['size'],
      tags: json['tags'],
      weight: (json['weight'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool,
      isBackgroundWhite: json['is_background_white'] as bool,
      featured: json['featured'] as bool,
      newArrival: json['new_arrival'] as bool,
      bestSeller: json['best_seller'] as bool,
      sku: json['sku'] as String?,
      totalSales: (json['total_sales'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ProductResourceToJson(ProductResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'brand': instance.brand,
      'category': instance.category?.toJson(),
      'imageUrls': instance.imageUrls.map((e) => e.toJson()).toList(),
      'has_variants': instance.hasVariants,
      'product_variants':
          instance.productVariants?.map((e) => e.toJson()).toList(),
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'stock_quantity': instance.stockQuantity,
      'average_rating': instance.averageRating,
      'review_count': instance.reviewCount,
      'serving_size': instance.servingSize,
      'servings_per_container': instance.servingsPerContainer,
      'nutrition_facts': instance.nutritionFacts,
      'flavors': instance.flavors,
      'product_sizes': instance.productSizes,
      'size': instance.size,
      'tags': instance.tags,
      'weight': instance.weight,
      'is_active': instance.isActive,
      'is_background_white': instance.isBackgroundWhite,
      'featured': instance.featured,
      'new_arrival': instance.newArrival,
      'best_seller': instance.bestSeller,
      'sku': instance.sku,
      'total_sales': instance.totalSales,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ProductVariantResource _$ProductVariantResourceFromJson(
        Map<String, dynamic> json) =>
    ProductVariantResource(
      id: json['id'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      effectivePrice: (json['effective_price'] as num).toDouble(),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      isActive: json['is_active'] as bool,
      discountStartDate: json['discount_start_date'] as String,
      discountEndDate: json['discount_end_date'] as String,
    );

Map<String, dynamic> _$ProductVariantResourceToJson(
        ProductVariantResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'effective_price': instance.effectivePrice,
      'stock_quantity': instance.stockQuantity,
      'attributes': instance.attributes,
      'is_active': instance.isActive,
      'discount_start_date': instance.discountStartDate,
      'discount_end_date': instance.discountEndDate,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      photoUrl: json['photo_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      defaultAddressId: json['default_address_id'] as String?,
      preferredLanguage: json['preferred_language'] as String,
      notificationsEnabled: (json['notifications_enabled'] as num).toInt(),
      isActive: (json['is_active'] as num).toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      role: json['role'] as String,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'photo_url': instance.photoUrl,
      'phone_number': instance.phoneNumber,
      'default_address_id': instance.defaultAddressId,
      'preferred_language': instance.preferredLanguage,
      'notifications_enabled': instance.notificationsEnabled,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'role': instance.role,
      'last_login': instance.lastLogin?.toIso8601String(),
    };

UserResource _$UserResourceFromJson(Map<String, dynamic> json) => UserResource(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      defaultAddressId: json['default_address_id'] as String?,
      preferredLanguage: json['preferred_language'],
      notificationsEnabled: json['notifications_enabled'] as bool,
      isActive: json['is_active'] as bool,
      role: json['role'],
      totalSpent: (json['total_spent'] as num).toDouble(),
      ordersCount: (json['orders_count'] as num).toInt(),
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => AddressResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] as String,
      lastLogin: json['last_login'] as String,
    );

Map<String, dynamic> _$UserResourceToJson(UserResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'photo_url': instance.photoUrl,
      'default_address_id': instance.defaultAddressId,
      'preferred_language': instance.preferredLanguage,
      'notifications_enabled': instance.notificationsEnabled,
      'is_active': instance.isActive,
      'role': instance.role,
      'total_spent': instance.totalSpent,
      'orders_count': instance.ordersCount,
      'addresses': instance.addresses?.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt,
      'last_login': instance.lastLogin,
    };

AuthenticationException$Response _$AuthenticationException$ResponseFromJson(
        Map<String, dynamic> json) =>
    AuthenticationException$Response(
      message: json['message'] as String,
    );

Map<String, dynamic> _$AuthenticationException$ResponseToJson(
        AuthenticationException$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ValidationException$Response _$ValidationException$ResponseFromJson(
        Map<String, dynamic> json) =>
    ValidationException$Response(
      message: json['message'] as String,
      errors: json['errors'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ValidationException$ResponseToJson(
        ValidationException$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errors': instance.errors,
    };

ModelNotFoundException$Response _$ModelNotFoundException$ResponseFromJson(
        Map<String, dynamic> json) =>
    ModelNotFoundException$Response(
      message: json['message'] as String,
    );

Map<String, dynamic> _$ModelNotFoundException$ResponseToJson(
        ModelNotFoundException$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

V1CustomerAddressesPost$RequestBody
    _$V1CustomerAddressesPost$RequestBodyFromJson(Map<String, dynamic> json) =>
        V1CustomerAddressesPost$RequestBody(
          label: json['label'] as String?,
          fullName: json['full_name'] as String?,
          phone: json['phone'] as String?,
          street: json['street'] as String,
          city: json['city'] as String,
          state: json['state'] as String?,
          postalCode: json['postal_code'] as String?,
          country: json['country'] as String?,
          isDefault: json['is_default'] as bool?,
          latitude: (json['latitude'] as num?)?.toDouble(),
          longitude: (json['longitude'] as num?)?.toDouble(),
        );

Map<String, dynamic> _$V1CustomerAddressesPost$RequestBodyToJson(
        V1CustomerAddressesPost$RequestBody instance) =>
    <String, dynamic>{
      'label': instance.label,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'is_default': instance.isDefault,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

V1CustomerAddressesIdPut$RequestBody
    _$V1CustomerAddressesIdPut$RequestBodyFromJson(Map<String, dynamic> json) =>
        V1CustomerAddressesIdPut$RequestBody(
          label: json['label'] as String?,
          fullName: json['full_name'] as String?,
          phone: json['phone'] as String?,
          street: json['street'] as String?,
          city: json['city'] as String?,
          state: json['state'] as String?,
          postalCode: json['postal_code'] as String?,
          country: json['country'] as String?,
          isDefault: json['is_default'] as bool?,
          latitude: (json['latitude'] as num?)?.toDouble(),
          longitude: (json['longitude'] as num?)?.toDouble(),
        );

Map<String, dynamic> _$V1CustomerAddressesIdPut$RequestBodyToJson(
        V1CustomerAddressesIdPut$RequestBody instance) =>
    <String, dynamic>{
      'label': instance.label,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'is_default': instance.isDefault,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

V1AdminLoginPost$RequestBody _$V1AdminLoginPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AdminLoginPost$RequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$V1AdminLoginPost$RequestBodyToJson(
        V1AdminLoginPost$RequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

V1AuthGoogleSigninPost$RequestBody _$V1AuthGoogleSigninPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AuthGoogleSigninPost$RequestBody(
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      googleId: json['google_id'] as String?,
    );

Map<String, dynamic> _$V1AuthGoogleSigninPost$RequestBodyToJson(
        V1AuthGoogleSigninPost$RequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'photo_url': instance.photoUrl,
      'google_id': instance.googleId,
    };

V1AuthLoginPost$RequestBody _$V1AuthLoginPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AuthLoginPost$RequestBody(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$V1AuthLoginPost$RequestBodyToJson(
        V1AuthLoginPost$RequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

V1AuthRegisterPost$RequestBody _$V1AuthRegisterPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AuthRegisterPost$RequestBody(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$V1AuthRegisterPost$RequestBodyToJson(
        V1AuthRegisterPost$RequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };

V1AuthUpdateProfilePost$RequestBody
    _$V1AuthUpdateProfilePost$RequestBodyFromJson(Map<String, dynamic> json) =>
        V1AuthUpdateProfilePost$RequestBody(
          name: json['name'] as String?,
          email: json['email'] as String?,
          phone: json['phone'] as String?,
          photoUrl: json['photo_url'] as String?,
          preferredLanguage:
              v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableFromJson(
                  json['preferred_language']),
          notificationsEnabled: json['notifications_enabled'] as bool?,
        );

Map<String, dynamic> _$V1AuthUpdateProfilePost$RequestBodyToJson(
        V1AuthUpdateProfilePost$RequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'photo_url': instance.photoUrl,
      'preferred_language':
          v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableToJson(
              instance.preferredLanguage),
      'notifications_enabled': instance.notificationsEnabled,
    };

V1CustomerCartPost$RequestBody _$V1CustomerCartPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1CustomerCartPost$RequestBody(
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      flavors: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      size:
          (json['size'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );

Map<String, dynamic> _$V1CustomerCartPost$RequestBodyToJson(
        V1CustomerCartPost$RequestBody instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'flavors': instance.flavors,
      'size': instance.size,
    };

V1CustomerCartIdPut$RequestBody _$V1CustomerCartIdPut$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1CustomerCartIdPut$RequestBody(
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$V1CustomerCartIdPut$RequestBodyToJson(
        V1CustomerCartIdPut$RequestBody instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
    };

V1AdminCategoriesPost$RequestBody _$V1AdminCategoriesPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AdminCategoriesPost$RequestBody(
      name: json['name'] == null
          ? null
          : V1AdminCategoriesPost$RequestBody$Name.fromJson(
              json['name'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminCategoriesPost$RequestBodyToJson(
        V1AdminCategoriesPost$RequestBody instance) =>
    <String, dynamic>{
      'name': instance.name?.toJson(),
    };

V1AdminCategoriesIdPut$RequestBody _$V1AdminCategoriesIdPut$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AdminCategoriesIdPut$RequestBody(
      description: (json['description'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      imageUrl: json['image_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      icon: json['icon'] as String?,
      parentId: json['parent_id'] as String?,
      name: json['name'] == null
          ? null
          : V1AdminCategoriesIdPut$RequestBody$Name.fromJson(
              json['name'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminCategoriesIdPut$RequestBodyToJson(
        V1AdminCategoriesIdPut$RequestBody instance) =>
    <String, dynamic>{
      'description': instance.description,
      'image_url': instance.imageUrl,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'icon': instance.icon,
      'parent_id': instance.parentId,
      'name': instance.name?.toJson(),
    };

V1AdminUploadDeletePost$RequestBody
    _$V1AdminUploadDeletePost$RequestBodyFromJson(Map<String, dynamic> json) =>
        V1AdminUploadDeletePost$RequestBody(
          path: json['path'] as String,
        );

Map<String, dynamic> _$V1AdminUploadDeletePost$RequestBodyToJson(
        V1AdminUploadDeletePost$RequestBody instance) =>
    <String, dynamic>{
      'path': instance.path,
    };

V1AdminOrdersIdPatch$RequestBody _$V1AdminOrdersIdPatch$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AdminOrdersIdPatch$RequestBody(
      status: v1AdminOrdersIdPatch$RequestBodyStatusFromJson(json['status']),
      paymentStatus: json['payment_status'] as String?,
      trackingNumber: json['tracking_number'] as String?,
    );

Map<String, dynamic> _$V1AdminOrdersIdPatch$RequestBodyToJson(
        V1AdminOrdersIdPatch$RequestBody instance) =>
    <String, dynamic>{
      'status': v1AdminOrdersIdPatch$RequestBodyStatusToJson(instance.status),
      'payment_status': instance.paymentStatus,
      'tracking_number': instance.trackingNumber,
    };

V1CustomerOrdersPost$RequestBody _$V1CustomerOrdersPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1CustomerOrdersPost$RequestBody(
      paymentMethod:
          v1CustomerOrdersPost$RequestBodyPaymentMethodNullableFromJson(
              json['payment_method']),
      addressId: (json['address_id'] as num).toInt(),
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => V1CustomerOrdersPost$RequestBody$Items$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V1CustomerOrdersPost$RequestBodyToJson(
        V1CustomerOrdersPost$RequestBody instance) =>
    <String, dynamic>{
      'payment_method':
          v1CustomerOrdersPost$RequestBodyPaymentMethodNullableToJson(
              instance.paymentMethod),
      'address_id': instance.addressId,
      'notes': instance.notes,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

V1AdminProductsPost$RequestBody _$V1AdminProductsPost$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsPost$RequestBody(
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categoryId: json['category_id'] as String,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
      brand: json['brand'] as String?,
      isActive: json['is_active'] as bool?,
      isBackgroundWhite: json['is_background_white'] as bool?,
      servingSize: json['serving_size'] as String?,
      servingsPerContainer: (json['servings_per_container'] as num?)?.toInt(),
      flavors: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      size:
          (json['size'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      name: V1AdminProductsPost$RequestBody$Name.fromJson(
          json['name'] as Map<String, dynamic>),
      description: V1AdminProductsPost$RequestBody$Description.fromJson(
          json['description'] as Map<String, dynamic>),
      productSizes: (json['product_sizes'] as List<dynamic>?)
          ?.map((e) =>
              V1AdminProductsPost$RequestBody$ProductSizes$Item.fromJson(
                  e as Map<String, dynamic>))
          .toList(),
      productVariants: (json['product_variants'] as List<dynamic>?)
          ?.map((e) =>
              V1AdminProductsPost$RequestBody$ProductVariants$Item.fromJson(
                  e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => V1AdminProductsPost$RequestBody$Variants$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V1AdminProductsPost$RequestBodyToJson(
        V1AdminProductsPost$RequestBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'image_urls': instance.imageUrls,
      'category_id': instance.categoryId,
      'stock_quantity': instance.stockQuantity,
      'brand': instance.brand,
      'is_active': instance.isActive,
      'is_background_white': instance.isBackgroundWhite,
      'serving_size': instance.servingSize,
      'servings_per_container': instance.servingsPerContainer,
      'flavors': instance.flavors,
      'size': instance.size,
      'name': instance.name.toJson(),
      'description': instance.description.toJson(),
      'product_sizes': instance.productSizes?.map((e) => e.toJson()).toList(),
      'product_variants':
          instance.productVariants?.map((e) => e.toJson()).toList(),
      'variants': instance.variants?.map((e) => e.toJson()).toList(),
    };

V1AdminProductsIdPut$RequestBody _$V1AdminProductsIdPut$RequestBodyFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsIdPut$RequestBody(
      name:
          (json['name'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      description: (json['description'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      price: (json['price'] as num?)?.toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categoryId: json['category_id'] as String?,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
      brand: json['brand'] as String?,
      isActive: json['is_active'] as bool?,
      isBackgroundWhite: json['is_background_white'] as bool?,
      servingSize: json['serving_size'] as String?,
      servingsPerContainer: (json['servings_per_container'] as num?)?.toInt(),
      flavors: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      productSizes: (json['product_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      size:
          (json['size'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      productVariants: (json['product_variants'] as List<dynamic>?)
          ?.map((e) =>
              V1AdminProductsIdPut$RequestBody$ProductVariants$Item.fromJson(
                  e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => V1AdminProductsIdPut$RequestBody$Variants$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V1AdminProductsIdPut$RequestBodyToJson(
        V1AdminProductsIdPut$RequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'image_urls': instance.imageUrls,
      'category_id': instance.categoryId,
      'stock_quantity': instance.stockQuantity,
      'brand': instance.brand,
      'is_active': instance.isActive,
      'is_background_white': instance.isBackgroundWhite,
      'serving_size': instance.servingSize,
      'servings_per_container': instance.servingsPerContainer,
      'flavors': instance.flavors,
      'product_sizes': instance.productSizes,
      'size': instance.size,
      'product_variants':
          instance.productVariants?.map((e) => e.toJson()).toList(),
      'variants': instance.variants?.map((e) => e.toJson()).toList(),
    };

V1CustomerAddressesGet$Response _$V1CustomerAddressesGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerAddressesGet$Response(
      status: json['status'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => AddressResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CustomerAddressesGet$ResponseToJson(
        V1CustomerAddressesGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
    };

V1CustomerAddressesIdGet$Response _$V1CustomerAddressesIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerAddressesIdGet$Response(
      status: json['status'] as String,
      address:
          AddressResource.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CustomerAddressesIdGet$ResponseToJson(
        V1CustomerAddressesIdGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'address': instance.address.toJson(),
    };

V1AdminProfileGet$Response _$V1AdminProfileGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminProfileGet$Response(
      status: json['status'] as String,
      user: V1AdminProfileGet$Response$User.fromJson(
          json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminProfileGet$ResponseToJson(
        V1AdminProfileGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user': instance.user.toJson(),
    };

V1AdminLogoutPost$Response _$V1AdminLogoutPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminLogoutPost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$V1AdminLogoutPost$ResponseToJson(
        V1AdminLogoutPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

V1AdminLoginPost$Response _$V1AdminLoginPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminLoginPost$Response(
      status: json['status'] as String,
      token: json['token'] as String,
      user: V1AdminLoginPost$Response$User.fromJson(
          json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminLoginPost$ResponseToJson(
        V1AdminLoginPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'token': instance.token,
      'user': instance.user.toJson(),
    };

V1CustomerProfileGet$Response _$V1CustomerProfileGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerProfileGet$Response(
      status: json['status'] as String,
      user: UserResource.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CustomerProfileGet$ResponseToJson(
        V1CustomerProfileGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user': instance.user.toJson(),
    };

V1AuthGoogleSigninPost$Response _$V1AuthGoogleSigninPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthGoogleSigninPost$Response(
      status: json['status'] as String,
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: UserResource.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthGoogleSigninPost$ResponseToJson(
        V1AuthGoogleSigninPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user': instance.user.toJson(),
    };

V1AuthLoginPost$Response _$V1AuthLoginPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthLoginPost$Response(
      status: json['status'] as String,
      token: json['token'] as String,
      user: UserResource.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthLoginPost$ResponseToJson(
        V1AuthLoginPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'token': instance.token,
      'user': instance.user.toJson(),
    };

V1AuthRegisterPost$Response _$V1AuthRegisterPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthRegisterPost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
      token: json['token'] as String,
      user: UserResource.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthRegisterPost$ResponseToJson(
        V1AuthRegisterPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'token': instance.token,
      'user': instance.user.toJson(),
    };

V1AuthTestLoginGet$Response _$V1AuthTestLoginGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthTestLoginGet$Response(
      status: json['status'] as String,
      token: json['token'] as String,
      user: UserResource.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthTestLoginGet$ResponseToJson(
        V1AuthTestLoginGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'token': instance.token,
      'user': instance.user.toJson(),
    };

V1AuthUpdateProfilePost$Response _$V1AuthUpdateProfilePost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthUpdateProfilePost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
      user: UserResource.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthUpdateProfilePost$ResponseToJson(
        V1AuthUpdateProfilePost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'user': instance.user.toJson(),
    };

V1AuthLogoutPost$Response _$V1AuthLogoutPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthLogoutPost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$V1AuthLogoutPost$ResponseToJson(
        V1AuthLogoutPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

V1CustomerCartGet$Response _$V1CustomerCartGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerCartGet$Response(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => V1CustomerCartGet$Response$Data$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      grandTotal: json['grand_total'] as String,
    );

Map<String, dynamic> _$V1CustomerCartGet$ResponseToJson(
        V1CustomerCartGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'grand_total': instance.grandTotal,
    };

V1CustomerCartPost$Response _$V1CustomerCartPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerCartPost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$V1CustomerCartPost$ResponseToJson(
        V1CustomerCartPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

V1CustomerCartIdPut$Response _$V1CustomerCartIdPut$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerCartIdPut$Response(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$V1CustomerCartIdPut$ResponseToJson(
        V1CustomerCartIdPut$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

V1AdminCategoriesGet$Response _$V1AdminCategoriesGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminCategoriesGet$Response(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => V1AdminCategoriesGet$Response$Data$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V1AdminCategoriesGet$ResponseToJson(
        V1AdminCategoriesGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

V1AdminCategoriesPost$Response _$V1AdminCategoriesPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminCategoriesPost$Response(
      status: json['status'] as String,
      data: V1AdminCategoriesPost$Response$Data.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminCategoriesPost$ResponseToJson(
        V1AdminCategoriesPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminCategoriesIdGet$Response _$V1AdminCategoriesIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminCategoriesIdGet$Response(
      status: json['status'] as String,
      data: V1AdminCategoriesIdGet$Response$Data.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminCategoriesIdGet$ResponseToJson(
        V1AdminCategoriesIdGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminCategoriesIdPut$Response _$V1AdminCategoriesIdPut$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminCategoriesIdPut$Response(
      status: json['status'] as String,
      data: V1AdminCategoriesIdPut$Response$Data.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminCategoriesIdPut$ResponseToJson(
        V1AdminCategoriesIdPut$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1ShopCategoriesGet$Response _$V1ShopCategoriesGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1ShopCategoriesGet$Response(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ShopCategoriesGet$ResponseToJson(
        V1ShopCategoriesGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

V1ShopCategoriesIdGet$Response _$V1ShopCategoriesIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1ShopCategoriesIdGet$Response(
      status: json['status'] as String,
      data: CategoryResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ShopCategoriesIdGet$ResponseToJson(
        V1ShopCategoriesIdGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminUploadProductImagePost$Response
    _$V1AdminUploadProductImagePost$ResponseFromJson(
            Map<String, dynamic> json) =>
        V1AdminUploadProductImagePost$Response(
          status: json['status'] as String,
          data: V1AdminUploadProductImagePost$Response$Data.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$V1AdminUploadProductImagePost$ResponseToJson(
        V1AdminUploadProductImagePost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminUploadCategoryImagePost$Response
    _$V1AdminUploadCategoryImagePost$ResponseFromJson(
            Map<String, dynamic> json) =>
        V1AdminUploadCategoryImagePost$Response(
          status: json['status'] as String,
          data: V1AdminUploadCategoryImagePost$Response$Data.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$V1AdminUploadCategoryImagePost$ResponseToJson(
        V1AdminUploadCategoryImagePost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminUploadImagePost$Response _$V1AdminUploadImagePost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminUploadImagePost$Response(
      status: json['status'] as String,
      data: V1AdminUploadImagePost$Response$Data.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminUploadImagePost$ResponseToJson(
        V1AdminUploadImagePost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminUploadDeletePost$Response _$V1AdminUploadDeletePost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminUploadDeletePost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$V1AdminUploadDeletePost$ResponseToJson(
        V1AdminUploadDeletePost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

V1AdminOrdersGet$Response _$V1AdminOrdersGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminOrdersGet$Response(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>).map((e) => e as Object).toList(),
    );

Map<String, dynamic> _$V1AdminOrdersGet$ResponseToJson(
        V1AdminOrdersGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

V1AdminOrdersIdGet$Response _$V1AdminOrdersIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminOrdersIdGet$Response(
      status: json['status'] as String,
      data: V1AdminOrdersIdGet$Response$Data.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminOrdersIdGet$ResponseToJson(
        V1AdminOrdersIdGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminOrdersIdPatch$Response _$V1AdminOrdersIdPatch$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminOrdersIdPatch$Response(
      status: json['status'] as String,
      data: V1AdminOrdersIdPatch$Response$Data.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminOrdersIdPatch$ResponseToJson(
        V1AdminOrdersIdPatch$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1CustomerOrdersGet$Response _$V1CustomerOrdersGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerOrdersGet$Response(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => OrderResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String,
    );

Map<String, dynamic> _$V1CustomerOrdersGet$ResponseToJson(
        V1CustomerOrdersGet$Response instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'status': instance.status,
    };

V1CustomerOrdersPost$Response _$V1CustomerOrdersPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerOrdersPost$Response(
      status: json['status'] as String,
      message: json['message'] as String,
      data: OrderResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CustomerOrdersPost$ResponseToJson(
        V1CustomerOrdersPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data.toJson(),
    };

V1CustomerOrdersIdGet$Response _$V1CustomerOrdersIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1CustomerOrdersIdGet$Response(
      data: OrderResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CustomerOrdersIdGet$ResponseToJson(
        V1CustomerOrdersIdGet$Response instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

V1AdminProductsGet$Response _$V1AdminProductsGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsGet$Response(
      status: json['status'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$V1AdminProductsGet$ResponseToJson(
        V1AdminProductsGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

V1AdminProductsPost$Response _$V1AdminProductsPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsPost$Response(
      status: json['status'] as String,
      data: ProductResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminProductsPost$ResponseToJson(
        V1AdminProductsPost$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminProductsIdGet$Response _$V1AdminProductsIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsIdGet$Response(
      status: json['status'] as String,
      data: ProductResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminProductsIdGet$ResponseToJson(
        V1AdminProductsIdGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminProductsIdPut$Response _$V1AdminProductsIdPut$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsIdPut$Response(
      status: json['status'] as String,
      data: ProductResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AdminProductsIdPut$ResponseToJson(
        V1AdminProductsIdPut$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminProductsIdDelete$Response _$V1AdminProductsIdDelete$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminProductsIdDelete$Response(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$V1AdminProductsIdDelete$ResponseToJson(
        V1AdminProductsIdDelete$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

V1ShopProductsGet$Response _$V1ShopProductsGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1ShopProductsGet$Response(
      status: json['status'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$V1ShopProductsGet$ResponseToJson(
        V1ShopProductsGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

V1ShopProductsIdGet$Response _$V1ShopProductsIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1ShopProductsIdGet$Response(
      status: json['status'] as String,
      data: ProductResource.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ShopProductsIdGet$ResponseToJson(
        V1ShopProductsIdGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

V1AdminUsersGet$Response _$V1AdminUsersGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    V1AdminUsersGet$Response(
      status: json['status'] as String,
      totalUsers: (json['total_users'] as num).toInt(),
      users: (json['users'] as List<dynamic>)
          .map((e) => V1AdminUsersGet$Response$Users$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V1AdminUsersGet$ResponseToJson(
        V1AdminUsersGet$Response instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total_users': instance.totalUsers,
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

ProductResource$Category _$ProductResource$CategoryFromJson(
        Map<String, dynamic> json) =>
    ProductResource$Category(
      id: json['id'] as String,
      name:
          (json['name'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
              [],
    );

Map<String, dynamic> _$ProductResource$CategoryToJson(
        ProductResource$Category instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProductResource$ImageUrls$Item _$ProductResource$ImageUrls$ItemFromJson(
        Map<String, dynamic> json) =>
    ProductResource$ImageUrls$Item(
      thumbnail: json['thumbnail'],
      medium: json['medium'],
      original: json['original'],
    );

Map<String, dynamic> _$ProductResource$ImageUrls$ItemToJson(
        ProductResource$ImageUrls$Item instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'original': instance.original,
    };

V1AdminCategoriesPost$RequestBody$Name
    _$V1AdminCategoriesPost$RequestBody$NameFromJson(
            Map<String, dynamic> json) =>
        V1AdminCategoriesPost$RequestBody$Name(
          en: json['en'] as String?,
          ar: json['ar'] as String?,
        );

Map<String, dynamic> _$V1AdminCategoriesPost$RequestBody$NameToJson(
        V1AdminCategoriesPost$RequestBody$Name instance) =>
    <String, dynamic>{
      'en': instance.en,
      'ar': instance.ar,
    };

V1AdminCategoriesIdPut$RequestBody$Name
    _$V1AdminCategoriesIdPut$RequestBody$NameFromJson(
            Map<String, dynamic> json) =>
        V1AdminCategoriesIdPut$RequestBody$Name(
          ar: json['ar'] as String?,
          en: json['en'] as String?,
        );

Map<String, dynamic> _$V1AdminCategoriesIdPut$RequestBody$NameToJson(
        V1AdminCategoriesIdPut$RequestBody$Name instance) =>
    <String, dynamic>{
      'ar': instance.ar,
      'en': instance.en,
    };

V1CustomerOrdersPost$RequestBody$Items$Item
    _$V1CustomerOrdersPost$RequestBody$Items$ItemFromJson(
            Map<String, dynamic> json) =>
        V1CustomerOrdersPost$RequestBody$Items$Item(
          productId: json['product_id'] as String,
          quantity: (json['quantity'] as num).toInt(),
          selectedFlavor: json['selected_flavor'] as String?,
          selectedSize: json['selected_size'] as String?,
          $selectedFlavor: json['selectedFlavor'] as String?,
          $selectedSize: json['selectedSize'] as String?,
        );

Map<String, dynamic> _$V1CustomerOrdersPost$RequestBody$Items$ItemToJson(
        V1CustomerOrdersPost$RequestBody$Items$Item instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'selected_flavor': instance.selectedFlavor,
      'selected_size': instance.selectedSize,
      'selectedFlavor': instance.$selectedFlavor,
      'selectedSize': instance.$selectedSize,
    };

V1AdminProductsPost$RequestBody$Name
    _$V1AdminProductsPost$RequestBody$NameFromJson(Map<String, dynamic> json) =>
        V1AdminProductsPost$RequestBody$Name(
          ar: json['ar'] as String,
          en: json['en'] as String?,
        );

Map<String, dynamic> _$V1AdminProductsPost$RequestBody$NameToJson(
        V1AdminProductsPost$RequestBody$Name instance) =>
    <String, dynamic>{
      'ar': instance.ar,
      'en': instance.en,
    };

V1AdminProductsPost$RequestBody$Description
    _$V1AdminProductsPost$RequestBody$DescriptionFromJson(
            Map<String, dynamic> json) =>
        V1AdminProductsPost$RequestBody$Description(
          ar: json['ar'] as String?,
          en: json['en'] as String?,
        );

Map<String, dynamic> _$V1AdminProductsPost$RequestBody$DescriptionToJson(
        V1AdminProductsPost$RequestBody$Description instance) =>
    <String, dynamic>{
      'ar': instance.ar,
      'en': instance.en,
    };

V1AdminProductsPost$RequestBody$ProductSizes$Item
    _$V1AdminProductsPost$RequestBody$ProductSizes$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminProductsPost$RequestBody$ProductSizes$Item(
          size: json['size'] as String,
          price: (json['price'] as num).toDouble(),
          discountPrice: (json['discount_price'] as num?)?.toDouble(),
        );

Map<String, dynamic> _$V1AdminProductsPost$RequestBody$ProductSizes$ItemToJson(
        V1AdminProductsPost$RequestBody$ProductSizes$Item instance) =>
    <String, dynamic>{
      'size': instance.size,
      'price': instance.price,
      'discount_price': instance.discountPrice,
    };

V1AdminProductsPost$RequestBody$ProductVariants$Item
    _$V1AdminProductsPost$RequestBody$ProductVariants$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminProductsPost$RequestBody$ProductVariants$Item(
          sku: json['sku'] as String,
          price: (json['price'] as num).toDouble(),
          discountPrice: (json['discount_price'] as num?)?.toDouble(),
          stockQuantity: (json['stock_quantity'] as num).toInt(),
          attributes: (json['attributes'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          isActive: json['is_active'] as bool?,
        );

Map<String, dynamic>
    _$V1AdminProductsPost$RequestBody$ProductVariants$ItemToJson(
            V1AdminProductsPost$RequestBody$ProductVariants$Item instance) =>
        <String, dynamic>{
          'sku': instance.sku,
          'price': instance.price,
          'discount_price': instance.discountPrice,
          'stock_quantity': instance.stockQuantity,
          'attributes': instance.attributes,
          'is_active': instance.isActive,
        };

V1AdminProductsPost$RequestBody$Variants$Item
    _$V1AdminProductsPost$RequestBody$Variants$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminProductsPost$RequestBody$Variants$Item(
          sku: json['sku'] as String?,
          price: (json['price'] as num?)?.toDouble(),
          discountPrice: (json['discount_price'] as num?)?.toDouble(),
          stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
          attributes: (json['attributes'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$V1AdminProductsPost$RequestBody$Variants$ItemToJson(
        V1AdminProductsPost$RequestBody$Variants$Item instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'stock_quantity': instance.stockQuantity,
      'attributes': instance.attributes,
    };

V1AdminProductsIdPut$RequestBody$ProductVariants$Item
    _$V1AdminProductsIdPut$RequestBody$ProductVariants$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminProductsIdPut$RequestBody$ProductVariants$Item(
          id: json['id'] as String?,
          sku: json['sku'] as String?,
          price: (json['price'] as num?)?.toDouble(),
          discountPrice: (json['discount_price'] as num?)?.toDouble(),
          stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
          attributes: (json['attributes'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          isActive: json['is_active'] as bool?,
        );

Map<String, dynamic>
    _$V1AdminProductsIdPut$RequestBody$ProductVariants$ItemToJson(
            V1AdminProductsIdPut$RequestBody$ProductVariants$Item instance) =>
        <String, dynamic>{
          'id': instance.id,
          'sku': instance.sku,
          'price': instance.price,
          'discount_price': instance.discountPrice,
          'stock_quantity': instance.stockQuantity,
          'attributes': instance.attributes,
          'is_active': instance.isActive,
        };

V1AdminProductsIdPut$RequestBody$Variants$Item
    _$V1AdminProductsIdPut$RequestBody$Variants$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminProductsIdPut$RequestBody$Variants$Item(
          id: json['id'] as String?,
          sku: json['sku'] as String?,
          price: (json['price'] as num?)?.toDouble(),
          discountPrice: (json['discount_price'] as num?)?.toDouble(),
          stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
          attributes: (json['attributes'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$V1AdminProductsIdPut$RequestBody$Variants$ItemToJson(
        V1AdminProductsIdPut$RequestBody$Variants$Item instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'stock_quantity': instance.stockQuantity,
      'attributes': instance.attributes,
    };

V1AdminProfileGet$Response$User _$V1AdminProfileGet$Response$UserFromJson(
        Map<String, dynamic> json) =>
    V1AdminProfileGet$Response$User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$V1AdminProfileGet$Response$UserToJson(
        V1AdminProfileGet$Response$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };

V1AdminLoginPost$Response$User _$V1AdminLoginPost$Response$UserFromJson(
        Map<String, dynamic> json) =>
    V1AdminLoginPost$Response$User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$V1AdminLoginPost$Response$UserToJson(
        V1AdminLoginPost$Response$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };

V1CustomerCartGet$Response$Data$Item
    _$V1CustomerCartGet$Response$Data$ItemFromJson(Map<String, dynamic> json) =>
        V1CustomerCartGet$Response$Data$Item(
          id: json['id'] as String,
          productId: json['product_id'] as String,
          productName: json['product_name'] as String,
          price: json['price'] as String,
          imageUrls: json['image_urls'] as String,
          quantity: json['quantity'] as String,
          flavors: json['flavors'] as String,
          size: json['size'] as String,
          addedAt: json['added_at'] as String,
          totalPrice: json['total_price'] as String,
          product: json['product'] as String,
        );

Map<String, dynamic> _$V1CustomerCartGet$Response$Data$ItemToJson(
        V1CustomerCartGet$Response$Data$Item instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'price': instance.price,
      'image_urls': instance.imageUrls,
      'quantity': instance.quantity,
      'flavors': instance.flavors,
      'size': instance.size,
      'added_at': instance.addedAt,
      'total_price': instance.totalPrice,
      'product': instance.product,
    };

V1AdminCategoriesGet$Response$Data$Item
    _$V1AdminCategoriesGet$Response$Data$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminCategoriesGet$Response$Data$Item(
          id: json['id'] as String,
          name: (json['name'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          description: (json['description'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          imageUrl: json['imageUrl'] as String?,
          sortOrder: (json['sortOrder'] as num).toInt(),
          isActive: json['isActive'] as bool,
          createdAt: json['createdAt'] as String?,
          icon: json['icon'] as String,
          parentId: json['parentId'] as String?,
          children: (json['children'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$V1AdminCategoriesGet$Response$Data$ItemToJson(
        V1AdminCategoriesGet$Response$Data$Item instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'icon': instance.icon,
      'parentId': instance.parentId,
      'children': instance.children,
    };

V1AdminCategoriesPost$Response$Data
    _$V1AdminCategoriesPost$Response$DataFromJson(Map<String, dynamic> json) =>
        V1AdminCategoriesPost$Response$Data(
          id: json['id'] as String,
          name: (json['name'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          description: (json['description'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          imageUrl: json['imageUrl'] as String?,
          sortOrder: (json['sortOrder'] as num).toInt(),
          isActive: json['isActive'] as bool,
          createdAt: json['createdAt'] as String?,
          icon: json['icon'] as String,
          parentId: json['parentId'] as String?,
          children: (json['children'] as List<dynamic>?)
                  ?.map((e) => e as List<dynamic>)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$V1AdminCategoriesPost$Response$DataToJson(
        V1AdminCategoriesPost$Response$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'icon': instance.icon,
      'parentId': instance.parentId,
      'children': instance.children,
    };

V1AdminCategoriesIdGet$Response$Data
    _$V1AdminCategoriesIdGet$Response$DataFromJson(Map<String, dynamic> json) =>
        V1AdminCategoriesIdGet$Response$Data(
          id: json['id'] as String,
          name: (json['name'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          description: (json['description'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          imageUrl: json['imageUrl'] as String?,
          sortOrder: (json['sortOrder'] as num).toInt(),
          isActive: json['isActive'] as bool,
          createdAt: json['createdAt'] as String?,
          icon: json['icon'] as String,
          parentId: json['parentId'] as String?,
          children: (json['children'] as List<dynamic>?)
                  ?.map((e) => e as List<dynamic>)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$V1AdminCategoriesIdGet$Response$DataToJson(
        V1AdminCategoriesIdGet$Response$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'icon': instance.icon,
      'parentId': instance.parentId,
      'children': instance.children,
    };

V1AdminCategoriesIdPut$Response$Data
    _$V1AdminCategoriesIdPut$Response$DataFromJson(Map<String, dynamic> json) =>
        V1AdminCategoriesIdPut$Response$Data(
          id: json['id'] as String,
          name: (json['name'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          description: (json['description'] as List<dynamic>?)
                  ?.map((e) => e as Object)
                  .toList() ??
              [],
          imageUrl: json['imageUrl'] as String?,
          sortOrder: (json['sortOrder'] as num).toInt(),
          isActive: json['isActive'] as bool,
          createdAt: json['createdAt'] as String?,
          icon: json['icon'] as String,
          parentId: json['parentId'] as String?,
          children: (json['children'] as List<dynamic>?)
                  ?.map((e) => e as List<dynamic>)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$V1AdminCategoriesIdPut$Response$DataToJson(
        V1AdminCategoriesIdPut$Response$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'icon': instance.icon,
      'parentId': instance.parentId,
      'children': instance.children,
    };

V1AdminUploadProductImagePost$Response$Data
    _$V1AdminUploadProductImagePost$Response$DataFromJson(
            Map<String, dynamic> json) =>
        V1AdminUploadProductImagePost$Response$Data(
          url: json['url'] as String,
          path: json['path'] as String,
          name: json['name'] as String,
          size: json['size'] as String,
        );

Map<String, dynamic> _$V1AdminUploadProductImagePost$Response$DataToJson(
        V1AdminUploadProductImagePost$Response$Data instance) =>
    <String, dynamic>{
      'url': instance.url,
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
    };

V1AdminUploadCategoryImagePost$Response$Data
    _$V1AdminUploadCategoryImagePost$Response$DataFromJson(
            Map<String, dynamic> json) =>
        V1AdminUploadCategoryImagePost$Response$Data(
          url: json['url'] as String,
          path: json['path'] as String,
          name: json['name'] as String,
          size: json['size'] as String,
        );

Map<String, dynamic> _$V1AdminUploadCategoryImagePost$Response$DataToJson(
        V1AdminUploadCategoryImagePost$Response$Data instance) =>
    <String, dynamic>{
      'url': instance.url,
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
    };

V1AdminUploadImagePost$Response$Data
    _$V1AdminUploadImagePost$Response$DataFromJson(Map<String, dynamic> json) =>
        V1AdminUploadImagePost$Response$Data(
          url: json['url'] as String,
          path: json['path'] as String,
          name: json['name'] as String,
          size: json['size'] as String,
        );

Map<String, dynamic> _$V1AdminUploadImagePost$Response$DataToJson(
        V1AdminUploadImagePost$Response$Data instance) =>
    <String, dynamic>{
      'url': instance.url,
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
    };

V1AdminOrdersIdGet$Response$Data _$V1AdminOrdersIdGet$Response$DataFromJson(
        Map<String, dynamic> json) =>
    V1AdminOrdersIdGet$Response$Data(
      id: json['id'] as String,
      user: json['user'] == null
          ? null
          : V1AdminOrdersIdGet$Response$Data$User.fromJson(
              json['user'] as Map<String, dynamic>),
      orderDate: json['order_date'],
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String,
      addressId: json['address_id'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      trackingNumber: json['tracking_number'] as String?,
      notes: json['notes'] as String?,
      shippingAddress: (json['shipping_address'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      orderItems: (json['order_items'] as List<dynamic>)
          .map((e) => V1AdminOrdersIdGet$Response$Data$OrderItems$Item.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$V1AdminOrdersIdGet$Response$DataToJson(
        V1AdminOrdersIdGet$Response$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'order_date': instance.orderDate,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'address_id': instance.addressId,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'discount': instance.discount,
      'total_amount': instance.totalAmount,
      'tracking_number': instance.trackingNumber,
      'notes': instance.notes,
      'shipping_address': instance.shippingAddress,
      'order_items': instance.orderItems.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

V1AdminOrdersIdPatch$Response$Data _$V1AdminOrdersIdPatch$Response$DataFromJson(
        Map<String, dynamic> json) =>
    V1AdminOrdersIdPatch$Response$Data(
      id: json['id'] as String,
      user: json['user'] == null
          ? null
          : V1AdminOrdersIdPatch$Response$Data$User.fromJson(
              json['user'] as Map<String, dynamic>),
      orderDate: json['order_date'],
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String,
      addressId: json['address_id'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shippingCost'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      trackingNumber: json['tracking_number'] as String?,
      notes: json['notes'] as String?,
      shippingAddress: (json['shipping_address'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      orderItems: (json['order_items'] as List<dynamic>)
          .map((e) =>
              V1AdminOrdersIdPatch$Response$Data$OrderItems$Item.fromJson(
                  e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$V1AdminOrdersIdPatch$Response$DataToJson(
        V1AdminOrdersIdPatch$Response$Data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'order_date': instance.orderDate,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'address_id': instance.addressId,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'discount': instance.discount,
      'total_amount': instance.totalAmount,
      'tracking_number': instance.trackingNumber,
      'notes': instance.notes,
      'shipping_address': instance.shippingAddress,
      'order_items': instance.orderItems.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

V1AdminUsersGet$Response$Users$Item
    _$V1AdminUsersGet$Response$Users$ItemFromJson(Map<String, dynamic> json) =>
        V1AdminUsersGet$Response$Users$Item(
          id: json['id'] as String,
          name: json['name'] as String,
          email: json['email'] as String,
          phone: json['phone'] as String,
          isActive: json['is_active'] as bool,
          photoUrl: json['photo_url'] as String,
          totalSpent: (json['total_spent'] as num).toDouble(),
          createdAt: json['created_at'] as String,
          lastLogin: json['last_login'] as Object,
          addresses: json['addresses'] as String,
          ordersCount: (json['orders_count'] as num).toInt(),
        );

Map<String, dynamic> _$V1AdminUsersGet$Response$Users$ItemToJson(
        V1AdminUsersGet$Response$Users$Item instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'is_active': instance.isActive,
      'photo_url': instance.photoUrl,
      'total_spent': instance.totalSpent,
      'created_at': instance.createdAt,
      'last_login': instance.lastLogin,
      'addresses': instance.addresses,
      'orders_count': instance.ordersCount,
    };

V1AdminOrdersIdGet$Response$Data$User
    _$V1AdminOrdersIdGet$Response$Data$UserFromJson(
            Map<String, dynamic> json) =>
        V1AdminOrdersIdGet$Response$Data$User(
          id: (json['id'] as num).toInt(),
          name: json['name'] as String,
          email: json['email'] as String,
        );

Map<String, dynamic> _$V1AdminOrdersIdGet$Response$Data$UserToJson(
        V1AdminOrdersIdGet$Response$Data$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

V1AdminOrdersIdGet$Response$Data$OrderItems$Item
    _$V1AdminOrdersIdGet$Response$Data$OrderItems$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminOrdersIdGet$Response$Data$OrderItems$Item(
          id: json['id'] as String,
          orderId: json['order_id'] as String,
          productId: json['product_id'] as String,
          productName: json['product_name'],
          unitPrice: (json['unit_price'] as num).toDouble(),
          quantity: (json['quantity'] as num).toInt(),
          subtotal: (json['subtotal'] as num).toDouble(),
          imageUrl: json['image_url'] as String,
          selectedFlavor: json['selectedFlavor'] as String?,
          selectedSize: json['selectedSize'] as String?,
          $selectedFlavor: json['selected_flavor'] as String?,
          $selectedSize: json['selected_size'] as String?,
        );

Map<String, dynamic> _$V1AdminOrdersIdGet$Response$Data$OrderItems$ItemToJson(
        V1AdminOrdersIdGet$Response$Data$OrderItems$Item instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      'image_url': instance.imageUrl,
      'selectedFlavor': instance.selectedFlavor,
      'selectedSize': instance.selectedSize,
      'selected_flavor': instance.$selectedFlavor,
      'selected_size': instance.$selectedSize,
    };

V1AdminOrdersIdPatch$Response$Data$User
    _$V1AdminOrdersIdPatch$Response$Data$UserFromJson(
            Map<String, dynamic> json) =>
        V1AdminOrdersIdPatch$Response$Data$User(
          id: (json['id'] as num).toInt(),
          name: json['name'] as String,
          email: json['email'] as String,
        );

Map<String, dynamic> _$V1AdminOrdersIdPatch$Response$Data$UserToJson(
        V1AdminOrdersIdPatch$Response$Data$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

V1AdminOrdersIdPatch$Response$Data$OrderItems$Item
    _$V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemFromJson(
            Map<String, dynamic> json) =>
        V1AdminOrdersIdPatch$Response$Data$OrderItems$Item(
          id: json['id'] as String,
          orderId: json['order_id'] as String,
          productId: json['product_id'] as String,
          productName: json['product_name'],
          unitPrice: (json['unit_price'] as num).toDouble(),
          quantity: (json['quantity'] as num).toInt(),
          subtotal: (json['subtotal'] as num).toDouble(),
          imageUrl: json['image_url'] as String,
          selectedFlavor: json['selectedFlavor'] as String?,
          selectedSize: json['selectedSize'] as String?,
          $selectedFlavor: json['selected_flavor'] as String?,
          $selectedSize: json['selected_size'] as String?,
        );

Map<String, dynamic> _$V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemToJson(
        V1AdminOrdersIdPatch$Response$Data$OrderItems$Item instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      'image_url': instance.imageUrl,
      'selectedFlavor': instance.selectedFlavor,
      'selectedSize': instance.selectedSize,
      'selected_flavor': instance.$selectedFlavor,
      'selected_size': instance.$selectedSize,
    };
