// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Api extends Api {
  _$Api([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Api;

  @override
  Future<Response<User>> _v1UserGet() {
    final Uri $url = Uri.parse('/v1/user');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<V1CustomerAddressesGet$Response>> _v1CustomerAddressesGet() {
    final Uri $url = Uri.parse('/v1/customer/addresses');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1CustomerAddressesGet$Response,
        V1CustomerAddressesGet$Response>($request);
  }

  @override
  Future<Response<String>> _v1CustomerAddressesPost(
      {required V1CustomerAddressesPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/customer/addresses');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<V1CustomerAddressesIdGet$Response>> _v1CustomerAddressesIdGet(
      {required int? id}) {
    final Uri $url = Uri.parse('/v1/customer/addresses/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1CustomerAddressesIdGet$Response,
        V1CustomerAddressesIdGet$Response>($request);
  }

  @override
  Future<Response<String>> _v1CustomerAddressesIdPut({
    required int? id,
    required V1CustomerAddressesIdPut$RequestBody? body,
  }) {
    final Uri $url = Uri.parse('/v1/customer/addresses/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _v1CustomerAddressesIdDelete({required int? id}) {
    final Uri $url = Uri.parse('/v1/customer/addresses/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _v1CustomerAddressesIdSetDefaultPost(
      {required int? id}) {
    final Uri $url = Uri.parse('/v1/customer/addresses/${id}/set-default');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<V1AdminProfileGet$Response>> _v1AdminProfileGet() {
    final Uri $url = Uri.parse('/v1/admin/profile');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<V1AdminProfileGet$Response, V1AdminProfileGet$Response>($request);
  }

  @override
  Future<Response<V1AdminLogoutPost$Response>> _v1AdminLogoutPost() {
    final Uri $url = Uri.parse('/v1/admin/logout');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client
        .send<V1AdminLogoutPost$Response, V1AdminLogoutPost$Response>($request);
  }

  @override
  Future<Response<V1AdminLoginPost$Response>> _v1AdminLoginPost(
      {required V1AdminLoginPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/admin/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1AdminLoginPost$Response, V1AdminLoginPost$Response>($request);
  }

  @override
  Future<Response<V1CustomerProfileGet$Response>> _v1CustomerProfileGet() {
    final Uri $url = Uri.parse('/v1/customer/profile');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1CustomerProfileGet$Response,
        V1CustomerProfileGet$Response>($request);
  }

  @override
  Future<Response<V1AuthGoogleSigninPost$Response>> _v1AuthGoogleSigninPost(
      {required V1AuthGoogleSigninPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/auth/google-signin');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AuthGoogleSigninPost$Response,
        V1AuthGoogleSigninPost$Response>($request);
  }

  @override
  Future<Response<V1AuthLoginPost$Response>> _v1AuthLoginPost(
      {required V1AuthLoginPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1AuthLoginPost$Response, V1AuthLoginPost$Response>($request);
  }

  @override
  Future<Response<V1AuthRegisterPost$Response>> _v1AuthRegisterPost(
      {required V1AuthRegisterPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/auth/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AuthRegisterPost$Response,
        V1AuthRegisterPost$Response>($request);
  }

  @override
  Future<Response<V1AuthTestLoginGet$Response>> _v1AuthTestLoginGet() {
    final Uri $url = Uri.parse('/v1/auth/test-login');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1AuthTestLoginGet$Response,
        V1AuthTestLoginGet$Response>($request);
  }

  @override
  Future<Response<V1AuthUpdateProfilePost$Response>> _v1AuthUpdateProfilePost(
      {required V1AuthUpdateProfilePost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/auth/update-profile');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AuthUpdateProfilePost$Response,
        V1AuthUpdateProfilePost$Response>($request);
  }

  @override
  Future<Response<V1AuthLogoutPost$Response>> _v1AuthLogoutPost() {
    final Uri $url = Uri.parse('/v1/auth/logout');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client
        .send<V1AuthLogoutPost$Response, V1AuthLogoutPost$Response>($request);
  }

  @override
  Future<Response<V1CustomerCartGet$Response>> _v1CustomerCartGet() {
    final Uri $url = Uri.parse('/v1/customer/cart');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<V1CustomerCartGet$Response, V1CustomerCartGet$Response>($request);
  }

  @override
  Future<Response<V1CustomerCartPost$Response>> _v1CustomerCartPost(
      {required V1CustomerCartPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/customer/cart');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1CustomerCartPost$Response,
        V1CustomerCartPost$Response>($request);
  }

  @override
  Future<Response<dynamic>> _v1CustomerCartIdGet({required String? id}) {
    final Uri $url = Uri.parse('/v1/customer/cart/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<V1CustomerCartIdPut$Response>> _v1CustomerCartIdPut({
    required String? id,
    required V1CustomerCartIdPut$RequestBody? body,
  }) {
    final Uri $url = Uri.parse('/v1/customer/cart/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1CustomerCartIdPut$Response,
        V1CustomerCartIdPut$Response>($request);
  }

  @override
  Future<Response<InvalidType>> _v1CustomerCartIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/v1/customer/cart/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<InvalidType, InvalidType>($request);
  }

  @override
  Future<Response<V1AdminCategoriesGet$Response>> _v1AdminCategoriesGet() {
    final Uri $url = Uri.parse('/v1/admin/categories');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminCategoriesGet$Response,
        V1AdminCategoriesGet$Response>($request);
  }

  @override
  Future<Response<V1AdminCategoriesPost$Response>> _v1AdminCategoriesPost(
      {required V1AdminCategoriesPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/admin/categories');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AdminCategoriesPost$Response,
        V1AdminCategoriesPost$Response>($request);
  }

  @override
  Future<Response<V1AdminCategoriesIdGet$Response>> _v1AdminCategoriesIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/admin/categories/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminCategoriesIdGet$Response,
        V1AdminCategoriesIdGet$Response>($request);
  }

  @override
  Future<Response<V1AdminCategoriesIdPut$Response>> _v1AdminCategoriesIdPut({
    required String? id,
    required V1AdminCategoriesIdPut$RequestBody? body,
  }) {
    final Uri $url = Uri.parse('/v1/admin/categories/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AdminCategoriesIdPut$Response,
        V1AdminCategoriesIdPut$Response>($request);
  }

  @override
  Future<Response<dynamic>> _v1AdminCategoriesIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/v1/admin/categories/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<V1ShopCategoriesGet$Response>> _v1ShopCategoriesGet() {
    final Uri $url = Uri.parse('/v1/shop/categories');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1ShopCategoriesGet$Response,
        V1ShopCategoriesGet$Response>($request);
  }

  @override
  Future<Response<V1ShopCategoriesIdGet$Response>> _v1ShopCategoriesIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/shop/categories/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1ShopCategoriesIdGet$Response,
        V1ShopCategoriesIdGet$Response>($request);
  }

  @override
  Future<Response<V1AdminUploadProductImagePost$Response>>
      _v1AdminUploadProductImagePost() {
    final Uri $url = Uri.parse('/v1/admin/upload/product-image');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminUploadProductImagePost$Response,
        V1AdminUploadProductImagePost$Response>($request);
  }

  @override
  Future<Response<V1AdminUploadCategoryImagePost$Response>>
      _v1AdminUploadCategoryImagePost() {
    final Uri $url = Uri.parse('/v1/admin/upload/category-image');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminUploadCategoryImagePost$Response,
        V1AdminUploadCategoryImagePost$Response>($request);
  }

  @override
  Future<Response<V1AdminUploadImagePost$Response>> _v1AdminUploadImagePost() {
    final Uri $url = Uri.parse('/v1/admin/upload/image');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminUploadImagePost$Response,
        V1AdminUploadImagePost$Response>($request);
  }

  @override
  Future<Response<V1AdminUploadDeletePost$Response>> _v1AdminUploadDeletePost(
      {required V1AdminUploadDeletePost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/admin/upload/delete');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AdminUploadDeletePost$Response,
        V1AdminUploadDeletePost$Response>($request);
  }

  @override
  Future<Response<V1AdminOrdersGet$Response>> _v1AdminOrdersGet({
    String? limit,
    String? status,
  }) {
    final Uri $url = Uri.parse('/v1/admin/orders');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'status': status,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<V1AdminOrdersGet$Response, V1AdminOrdersGet$Response>($request);
  }

  @override
  Future<Response<V1AdminOrdersIdGet$Response>> _v1AdminOrdersIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/admin/orders/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminOrdersIdGet$Response,
        V1AdminOrdersIdGet$Response>($request);
  }

  @override
  Future<Response<V1AdminOrdersIdPatch$Response>> _v1AdminOrdersIdPatch({
    required String? id,
    required V1AdminOrdersIdPatch$RequestBody? body,
  }) {
    final Uri $url = Uri.parse('/v1/admin/orders/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AdminOrdersIdPatch$Response,
        V1AdminOrdersIdPatch$Response>($request);
  }

  @override
  Future<Response<V1CustomerOrdersGet$Response>> _v1CustomerOrdersGet(
      {String? limit}) {
    final Uri $url = Uri.parse('/v1/customer/orders');
    final Map<String, dynamic> $params = <String, dynamic>{'limit': limit};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<V1CustomerOrdersGet$Response,
        V1CustomerOrdersGet$Response>($request);
  }

  @override
  Future<Response<V1CustomerOrdersPost$Response>> _v1CustomerOrdersPost(
      {required V1CustomerOrdersPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/customer/orders');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1CustomerOrdersPost$Response,
        V1CustomerOrdersPost$Response>($request);
  }

  @override
  Future<Response<V1CustomerOrdersIdGet$Response>> _v1CustomerOrdersIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/customer/orders/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1CustomerOrdersIdGet$Response,
        V1CustomerOrdersIdGet$Response>($request);
  }

  @override
  Future<Response<V1AdminProductsGet$Response>> _v1AdminProductsGet() {
    final Uri $url = Uri.parse('/v1/admin/products');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminProductsGet$Response,
        V1AdminProductsGet$Response>($request);
  }

  @override
  Future<Response<V1AdminProductsPost$Response>> _v1AdminProductsPost(
      {required V1AdminProductsPost$RequestBody? body}) {
    final Uri $url = Uri.parse('/v1/admin/products');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AdminProductsPost$Response,
        V1AdminProductsPost$Response>($request);
  }

  @override
  Future<Response<V1AdminProductsIdGet$Response>> _v1AdminProductsIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/admin/products/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminProductsIdGet$Response,
        V1AdminProductsIdGet$Response>($request);
  }

  @override
  Future<Response<V1AdminProductsIdPut$Response>> _v1AdminProductsIdPut({
    required String? id,
    required V1AdminProductsIdPut$RequestBody? body,
  }) {
    final Uri $url = Uri.parse('/v1/admin/products/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1AdminProductsIdPut$Response,
        V1AdminProductsIdPut$Response>($request);
  }

  @override
  Future<Response<V1AdminProductsIdDelete$Response>> _v1AdminProductsIdDelete(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/admin/products/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<V1AdminProductsIdDelete$Response,
        V1AdminProductsIdDelete$Response>($request);
  }

  @override
  Future<Response<V1ShopProductsGet$Response>> _v1ShopProductsGet({
    String? category,
    String? search,
    String? sortBy,
    String? page,
  }) {
    final Uri $url = Uri.parse('/v1/shop/products');
    final Map<String, dynamic> $params = <String, dynamic>{
      'category': category,
      'search': search,
      'sort_by': sortBy,
      'page': page,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<V1ShopProductsGet$Response, V1ShopProductsGet$Response>($request);
  }

  @override
  Future<Response<V1ShopProductsIdGet$Response>> _v1ShopProductsIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/v1/shop/products/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<V1ShopProductsIdGet$Response,
        V1ShopProductsIdGet$Response>($request);
  }

  @override
  Future<Response<V1AdminUsersGet$Response>> _v1AdminUsersGet() {
    final Uri $url = Uri.parse('/v1/admin/users');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<V1AdminUsersGet$Response, V1AdminUsersGet$Response>($request);
  }
}
