// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'api.enums.swagger.dart' as enums;
export 'api.enums.swagger.dart';

part 'api.swagger.chopper.dart';
part 'api.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Api extends ChopperService {
  static Api create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Api(client);
    }

    final newClient = ChopperClient(
        services: [_$Api()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Api(newClient);
  }

  ///
  Future<chopper.Response<User>> v1UserGet() {
    generatedMapping.putIfAbsent(User, () => User.fromJsonFactory);

    return _v1UserGet();
  }

  ///
  @Get(path: '/v1/user')
  Future<chopper.Response<User>> _v1UserGet();

  ///Display a listing of the user's addresses
  Future<chopper.Response<V1CustomerAddressesGet$Response>>
      v1CustomerAddressesGet() {
    generatedMapping.putIfAbsent(V1CustomerAddressesGet$Response,
        () => V1CustomerAddressesGet$Response.fromJsonFactory);

    return _v1CustomerAddressesGet();
  }

  ///Display a listing of the user's addresses
  @Get(path: '/v1/customer/addresses')
  Future<chopper.Response<V1CustomerAddressesGet$Response>>
      _v1CustomerAddressesGet();

  ///Store a newly created address
  Future<chopper.Response<String>> v1CustomerAddressesPost(
      {required V1CustomerAddressesPost$RequestBody? body}) {
    return _v1CustomerAddressesPost(body: body);
  }

  ///Store a newly created address
  @Post(
    path: '/v1/customer/addresses',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _v1CustomerAddressesPost(
      {@Body() required V1CustomerAddressesPost$RequestBody? body});

  ///Display the specified address
  ///@param id
  Future<chopper.Response<V1CustomerAddressesIdGet$Response>>
      v1CustomerAddressesIdGet({required int? id}) {
    generatedMapping.putIfAbsent(V1CustomerAddressesIdGet$Response,
        () => V1CustomerAddressesIdGet$Response.fromJsonFactory);

    return _v1CustomerAddressesIdGet(id: id);
  }

  ///Display the specified address
  ///@param id
  @Get(path: '/v1/customer/addresses/{id}')
  Future<chopper.Response<V1CustomerAddressesIdGet$Response>>
      _v1CustomerAddressesIdGet({@Path('id') required int? id});

  ///Update the specified address
  ///@param id
  Future<chopper.Response<String>> v1CustomerAddressesIdPut({
    required int? id,
    required V1CustomerAddressesIdPut$RequestBody? body,
  }) {
    return _v1CustomerAddressesIdPut(id: id, body: body);
  }

  ///Update the specified address
  ///@param id
  @Put(
    path: '/v1/customer/addresses/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _v1CustomerAddressesIdPut({
    @Path('id') required int? id,
    @Body() required V1CustomerAddressesIdPut$RequestBody? body,
  });

  ///Remove the specified address
  ///@param id
  Future<chopper.Response<String>> v1CustomerAddressesIdDelete(
      {required int? id}) {
    return _v1CustomerAddressesIdDelete(id: id);
  }

  ///Remove the specified address
  ///@param id
  @Delete(path: '/v1/customer/addresses/{id}')
  Future<chopper.Response<String>> _v1CustomerAddressesIdDelete(
      {@Path('id') required int? id});

  ///Set an address as the default
  ///@param id
  Future<chopper.Response<String>> v1CustomerAddressesIdSetDefaultPost(
      {required int? id}) {
    return _v1CustomerAddressesIdSetDefaultPost(id: id);
  }

  ///Set an address as the default
  ///@param id
  @Post(
    path: '/v1/customer/addresses/{id}/set-default',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _v1CustomerAddressesIdSetDefaultPost(
      {@Path('id') required int? id});

  ///
  Future<chopper.Response<V1AdminProfileGet$Response>> v1AdminProfileGet() {
    generatedMapping.putIfAbsent(V1AdminProfileGet$Response,
        () => V1AdminProfileGet$Response.fromJsonFactory);

    return _v1AdminProfileGet();
  }

  ///
  @Get(path: '/v1/admin/profile')
  Future<chopper.Response<V1AdminProfileGet$Response>> _v1AdminProfileGet();

  ///
  Future<chopper.Response<V1AdminLogoutPost$Response>> v1AdminLogoutPost() {
    generatedMapping.putIfAbsent(V1AdminLogoutPost$Response,
        () => V1AdminLogoutPost$Response.fromJsonFactory);

    return _v1AdminLogoutPost();
  }

  ///
  @Post(
    path: '/v1/admin/logout',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminLogoutPost$Response>> _v1AdminLogoutPost();

  ///
  Future<chopper.Response<V1AdminLoginPost$Response>> v1AdminLoginPost(
      {required V1AdminLoginPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AdminLoginPost$Response,
        () => V1AdminLoginPost$Response.fromJsonFactory);

    return _v1AdminLoginPost(body: body);
  }

  ///
  @Post(
    path: '/v1/admin/login',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminLoginPost$Response>> _v1AdminLoginPost(
      {@Body() required V1AdminLoginPost$RequestBody? body});

  ///Get user profile
  Future<chopper.Response<V1CustomerProfileGet$Response>>
      v1CustomerProfileGet() {
    generatedMapping.putIfAbsent(V1CustomerProfileGet$Response,
        () => V1CustomerProfileGet$Response.fromJsonFactory);

    return _v1CustomerProfileGet();
  }

  ///Get user profile
  @Get(path: '/v1/customer/profile')
  Future<chopper.Response<V1CustomerProfileGet$Response>>
      _v1CustomerProfileGet();

  ///Handle Google Sign-In
  Future<chopper.Response<V1AuthGoogleSigninPost$Response>>
      v1AuthGoogleSigninPost(
          {required V1AuthGoogleSigninPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AuthGoogleSigninPost$Response,
        () => V1AuthGoogleSigninPost$Response.fromJsonFactory);

    return _v1AuthGoogleSigninPost(body: body);
  }

  ///Handle Google Sign-In
  @Post(
    path: '/v1/auth/google-signin',
    optionalBody: true,
  )
  Future<chopper.Response<V1AuthGoogleSigninPost$Response>>
      _v1AuthGoogleSigninPost(
          {@Body() required V1AuthGoogleSigninPost$RequestBody? body});

  ///Handle user login
  Future<chopper.Response<V1AuthLoginPost$Response>> v1AuthLoginPost(
      {required V1AuthLoginPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AuthLoginPost$Response,
        () => V1AuthLoginPost$Response.fromJsonFactory);

    return _v1AuthLoginPost(body: body);
  }

  ///Handle user login
  @Post(
    path: '/v1/auth/login',
    optionalBody: true,
  )
  Future<chopper.Response<V1AuthLoginPost$Response>> _v1AuthLoginPost(
      {@Body() required V1AuthLoginPost$RequestBody? body});

  ///Handle user registration
  Future<chopper.Response<V1AuthRegisterPost$Response>> v1AuthRegisterPost(
      {required V1AuthRegisterPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AuthRegisterPost$Response,
        () => V1AuthRegisterPost$Response.fromJsonFactory);

    return _v1AuthRegisterPost(body: body);
  }

  ///Handle user registration
  @Post(
    path: '/v1/auth/register',
    optionalBody: true,
  )
  Future<chopper.Response<V1AuthRegisterPost$Response>> _v1AuthRegisterPost(
      {@Body() required V1AuthRegisterPost$RequestBody? body});

  ///Get user profile
  Future<chopper.Response<V1AuthTestLoginGet$Response>> v1AuthTestLoginGet() {
    generatedMapping.putIfAbsent(V1AuthTestLoginGet$Response,
        () => V1AuthTestLoginGet$Response.fromJsonFactory);

    return _v1AuthTestLoginGet();
  }

  ///Get user profile
  @Get(path: '/v1/auth/test-login')
  Future<chopper.Response<V1AuthTestLoginGet$Response>> _v1AuthTestLoginGet();

  ///Handle user profile update
  Future<chopper.Response<V1AuthUpdateProfilePost$Response>>
      v1AuthUpdateProfilePost(
          {required V1AuthUpdateProfilePost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AuthUpdateProfilePost$Response,
        () => V1AuthUpdateProfilePost$Response.fromJsonFactory);

    return _v1AuthUpdateProfilePost(body: body);
  }

  ///Handle user profile update
  @Post(
    path: '/v1/auth/update-profile',
    optionalBody: true,
  )
  Future<chopper.Response<V1AuthUpdateProfilePost$Response>>
      _v1AuthUpdateProfilePost(
          {@Body() required V1AuthUpdateProfilePost$RequestBody? body});

  ///Handle user logout
  Future<chopper.Response<V1AuthLogoutPost$Response>> v1AuthLogoutPost() {
    generatedMapping.putIfAbsent(V1AuthLogoutPost$Response,
        () => V1AuthLogoutPost$Response.fromJsonFactory);

    return _v1AuthLogoutPost();
  }

  ///Handle user logout
  @Post(
    path: '/v1/auth/logout',
    optionalBody: true,
  )
  Future<chopper.Response<V1AuthLogoutPost$Response>> _v1AuthLogoutPost();

  ///Display a listing of the resource
  Future<chopper.Response<V1CustomerCartGet$Response>> v1CustomerCartGet() {
    generatedMapping.putIfAbsent(V1CustomerCartGet$Response,
        () => V1CustomerCartGet$Response.fromJsonFactory);

    return _v1CustomerCartGet();
  }

  ///Display a listing of the resource
  @Get(path: '/v1/customer/cart')
  Future<chopper.Response<V1CustomerCartGet$Response>> _v1CustomerCartGet();

  ///Store a newly created resource in storage.
  ///Security: Fetch price from database, not from client request
  Future<chopper.Response<V1CustomerCartPost$Response>> v1CustomerCartPost(
      {required V1CustomerCartPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1CustomerCartPost$Response,
        () => V1CustomerCartPost$Response.fromJsonFactory);

    return _v1CustomerCartPost(body: body);
  }

  ///Store a newly created resource in storage.
  ///Security: Fetch price from database, not from client request
  @Post(
    path: '/v1/customer/cart',
    optionalBody: true,
  )
  Future<chopper.Response<V1CustomerCartPost$Response>> _v1CustomerCartPost(
      {@Body() required V1CustomerCartPost$RequestBody? body});

  ///Display the specified resource
  ///@param id
  Future<chopper.Response> v1CustomerCartIdGet({required String? id}) {
    return _v1CustomerCartIdGet(id: id);
  }

  ///Display the specified resource
  ///@param id
  @Get(path: '/v1/customer/cart/{id}')
  Future<chopper.Response> _v1CustomerCartIdGet(
      {@Path('id') required String? id});

  ///Update the specified resource in storage
  ///@param id
  Future<chopper.Response<V1CustomerCartIdPut$Response>> v1CustomerCartIdPut({
    required String? id,
    required V1CustomerCartIdPut$RequestBody? body,
  }) {
    generatedMapping.putIfAbsent(V1CustomerCartIdPut$Response,
        () => V1CustomerCartIdPut$Response.fromJsonFactory);

    return _v1CustomerCartIdPut(id: id, body: body);
  }

  ///Update the specified resource in storage
  ///@param id
  @Put(
    path: '/v1/customer/cart/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<V1CustomerCartIdPut$Response>> _v1CustomerCartIdPut({
    @Path('id') required String? id,
    @Body() required V1CustomerCartIdPut$RequestBody? body,
  });

  ///Remove the specified resource from storage
  ///@param id
  Future<chopper.Response<V1CustomerCartIdDelete$Response>>
      v1CustomerCartIdDelete({required String? id}) {
    generatedMapping.putIfAbsent(V1CustomerCartIdDelete$Response,
        () => V1CustomerCartIdDelete$Response.fromJsonFactory);

    return _v1CustomerCartIdDelete(id: id);
  }

  ///Remove the specified resource from storage
  ///@param id
  @Delete(path: '/v1/customer/cart/{id}')
  Future<chopper.Response<V1CustomerCartIdDelete$Response>>
      _v1CustomerCartIdDelete({@Path('id') required String? id});

  ///Display a listing of the resource
  Future<chopper.Response<V1AdminCategoriesGet$Response>>
      v1AdminCategoriesGet() {
    generatedMapping.putIfAbsent(V1AdminCategoriesGet$Response,
        () => V1AdminCategoriesGet$Response.fromJsonFactory);

    return _v1AdminCategoriesGet();
  }

  ///Display a listing of the resource
  @Get(path: '/v1/admin/categories')
  Future<chopper.Response<V1AdminCategoriesGet$Response>>
      _v1AdminCategoriesGet();

  ///Store a newly created resource in storage
  Future<chopper.Response<V1AdminCategoriesPost$Response>>
      v1AdminCategoriesPost(
          {required V1AdminCategoriesPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AdminCategoriesPost$Response,
        () => V1AdminCategoriesPost$Response.fromJsonFactory);

    return _v1AdminCategoriesPost(body: body);
  }

  ///Store a newly created resource in storage
  @Post(
    path: '/v1/admin/categories',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminCategoriesPost$Response>>
      _v1AdminCategoriesPost(
          {@Body() required V1AdminCategoriesPost$RequestBody? body});

  ///Display the specified resource
  ///@param id
  Future<chopper.Response<V1AdminCategoriesIdGet$Response>>
      v1AdminCategoriesIdGet({required String? id}) {
    generatedMapping.putIfAbsent(V1AdminCategoriesIdGet$Response,
        () => V1AdminCategoriesIdGet$Response.fromJsonFactory);

    return _v1AdminCategoriesIdGet(id: id);
  }

  ///Display the specified resource
  ///@param id
  @Get(path: '/v1/admin/categories/{id}')
  Future<chopper.Response<V1AdminCategoriesIdGet$Response>>
      _v1AdminCategoriesIdGet({@Path('id') required String? id});

  ///Update the specified resource in storage
  ///@param id
  Future<chopper.Response<V1AdminCategoriesIdPut$Response>>
      v1AdminCategoriesIdPut({
    required String? id,
    required V1AdminCategoriesIdPut$RequestBody? body,
  }) {
    generatedMapping.putIfAbsent(V1AdminCategoriesIdPut$Response,
        () => V1AdminCategoriesIdPut$Response.fromJsonFactory);

    return _v1AdminCategoriesIdPut(id: id, body: body);
  }

  ///Update the specified resource in storage
  ///@param id
  @Put(
    path: '/v1/admin/categories/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminCategoriesIdPut$Response>>
      _v1AdminCategoriesIdPut({
    @Path('id') required String? id,
    @Body() required V1AdminCategoriesIdPut$RequestBody? body,
  });

  ///Remove the specified resource from storage
  ///@param id
  Future<chopper.Response> v1AdminCategoriesIdDelete({required String? id}) {
    return _v1AdminCategoriesIdDelete(id: id);
  }

  ///Remove the specified resource from storage
  ///@param id
  @Delete(path: '/v1/admin/categories/{id}')
  Future<chopper.Response> _v1AdminCategoriesIdDelete(
      {@Path('id') required String? id});

  ///Display a listing of active categories
  Future<chopper.Response<V1ShopCategoriesGet$Response>> v1ShopCategoriesGet() {
    generatedMapping.putIfAbsent(V1ShopCategoriesGet$Response,
        () => V1ShopCategoriesGet$Response.fromJsonFactory);

    return _v1ShopCategoriesGet();
  }

  ///Display a listing of active categories
  @Get(path: '/v1/shop/categories')
  Future<chopper.Response<V1ShopCategoriesGet$Response>> _v1ShopCategoriesGet();

  ///Display the specified category
  ///@param id
  Future<chopper.Response<V1ShopCategoriesIdGet$Response>>
      v1ShopCategoriesIdGet({required String? id}) {
    generatedMapping.putIfAbsent(V1ShopCategoriesIdGet$Response,
        () => V1ShopCategoriesIdGet$Response.fromJsonFactory);

    return _v1ShopCategoriesIdGet(id: id);
  }

  ///Display the specified category
  ///@param id
  @Get(path: '/v1/shop/categories/{id}')
  Future<chopper.Response<V1ShopCategoriesIdGet$Response>>
      _v1ShopCategoriesIdGet({@Path('id') required String? id});

  ///Upload a product image
  Future<chopper.Response<V1AdminUploadProductImagePost$Response>>
      v1AdminUploadProductImagePost() {
    generatedMapping.putIfAbsent(V1AdminUploadProductImagePost$Response,
        () => V1AdminUploadProductImagePost$Response.fromJsonFactory);

    return _v1AdminUploadProductImagePost();
  }

  ///Upload a product image
  @Post(
    path: '/v1/admin/upload/product-image',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminUploadProductImagePost$Response>>
      _v1AdminUploadProductImagePost();

  ///Upload a category image
  Future<chopper.Response<V1AdminUploadCategoryImagePost$Response>>
      v1AdminUploadCategoryImagePost() {
    generatedMapping.putIfAbsent(V1AdminUploadCategoryImagePost$Response,
        () => V1AdminUploadCategoryImagePost$Response.fromJsonFactory);

    return _v1AdminUploadCategoryImagePost();
  }

  ///Upload a category image
  @Post(
    path: '/v1/admin/upload/category-image',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminUploadCategoryImagePost$Response>>
      _v1AdminUploadCategoryImagePost();

  ///Upload a generic image
  Future<chopper.Response<V1AdminUploadImagePost$Response>>
      v1AdminUploadImagePost() {
    generatedMapping.putIfAbsent(V1AdminUploadImagePost$Response,
        () => V1AdminUploadImagePost$Response.fromJsonFactory);

    return _v1AdminUploadImagePost();
  }

  ///Upload a generic image
  @Post(
    path: '/v1/admin/upload/image',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminUploadImagePost$Response>>
      _v1AdminUploadImagePost();

  ///Delete an image
  Future<chopper.Response<V1AdminUploadDeletePost$Response>>
      v1AdminUploadDeletePost(
          {required V1AdminUploadDeletePost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AdminUploadDeletePost$Response,
        () => V1AdminUploadDeletePost$Response.fromJsonFactory);

    return _v1AdminUploadDeletePost(body: body);
  }

  ///Delete an image
  @Post(
    path: '/v1/admin/upload/delete',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminUploadDeletePost$Response>>
      _v1AdminUploadDeletePost(
          {@Body() required V1AdminUploadDeletePost$RequestBody? body});

  ///Display a listing of the resource
  ///@param limit
  ///@param status Default pagination limit
  Future<chopper.Response<V1AdminOrdersGet$Response>> v1AdminOrdersGet({
    String? limit,
    String? status,
  }) {
    generatedMapping.putIfAbsent(V1AdminOrdersGet$Response,
        () => V1AdminOrdersGet$Response.fromJsonFactory);

    return _v1AdminOrdersGet(limit: limit, status: status);
  }

  ///Display a listing of the resource
  ///@param limit
  ///@param status Default pagination limit
  @Get(path: '/v1/admin/orders')
  Future<chopper.Response<V1AdminOrdersGet$Response>> _v1AdminOrdersGet({
    @Query('limit') String? limit,
    @Query('status') String? status,
  });

  ///Display the specified resource
  ///@param id
  Future<chopper.Response<V1AdminOrdersIdGet$Response>> v1AdminOrdersIdGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(V1AdminOrdersIdGet$Response,
        () => V1AdminOrdersIdGet$Response.fromJsonFactory);

    return _v1AdminOrdersIdGet(id: id);
  }

  ///Display the specified resource
  ///@param id
  @Get(path: '/v1/admin/orders/{id}')
  Future<chopper.Response<V1AdminOrdersIdGet$Response>> _v1AdminOrdersIdGet(
      {@Path('id') required String? id});

  ///Update the specified resource in storage
  ///@param id
  Future<chopper.Response<V1AdminOrdersIdPatch$Response>> v1AdminOrdersIdPatch({
    required String? id,
    required V1AdminOrdersIdPatch$RequestBody? body,
  }) {
    generatedMapping.putIfAbsent(V1AdminOrdersIdPatch$Response,
        () => V1AdminOrdersIdPatch$Response.fromJsonFactory);

    return _v1AdminOrdersIdPatch(id: id, body: body);
  }

  ///Update the specified resource in storage
  ///@param id
  @Patch(
    path: '/v1/admin/orders/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminOrdersIdPatch$Response>>
      _v1AdminOrdersIdPatch({
    @Path('id') required String? id,
    @Body() required V1AdminOrdersIdPatch$RequestBody? body,
  });

  ///Display a listing of the resource
  ///@param limit
  Future<chopper.Response<V1CustomerOrdersGet$Response>> v1CustomerOrdersGet(
      {String? limit}) {
    generatedMapping.putIfAbsent(V1CustomerOrdersGet$Response,
        () => V1CustomerOrdersGet$Response.fromJsonFactory);

    return _v1CustomerOrdersGet(limit: limit);
  }

  ///Display a listing of the resource
  ///@param limit
  @Get(path: '/v1/customer/orders')
  Future<chopper.Response<V1CustomerOrdersGet$Response>> _v1CustomerOrdersGet(
      {@Query('limit') String? limit});

  ///Store a newly created resource in storage
  Future<chopper.Response<V1CustomerOrdersPost$Response>> v1CustomerOrdersPost(
      {required V1CustomerOrdersPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1CustomerOrdersPost$Response,
        () => V1CustomerOrdersPost$Response.fromJsonFactory);

    return _v1CustomerOrdersPost(body: body);
  }

  ///Store a newly created resource in storage
  @Post(
    path: '/v1/customer/orders',
    optionalBody: true,
  )
  Future<chopper.Response<V1CustomerOrdersPost$Response>> _v1CustomerOrdersPost(
      {@Body() required V1CustomerOrdersPost$RequestBody? body});

  ///Display the specified resource
  ///@param id
  Future<chopper.Response<V1CustomerOrdersIdGet$Response>>
      v1CustomerOrdersIdGet({required String? id}) {
    generatedMapping.putIfAbsent(V1CustomerOrdersIdGet$Response,
        () => V1CustomerOrdersIdGet$Response.fromJsonFactory);

    return _v1CustomerOrdersIdGet(id: id);
  }

  ///Display the specified resource
  ///@param id
  @Get(path: '/v1/customer/orders/{id}')
  Future<chopper.Response<V1CustomerOrdersIdGet$Response>>
      _v1CustomerOrdersIdGet({@Path('id') required String? id});

  ///Display a listing of the resource
  Future<chopper.Response<V1AdminProductsGet$Response>> v1AdminProductsGet() {
    generatedMapping.putIfAbsent(V1AdminProductsGet$Response,
        () => V1AdminProductsGet$Response.fromJsonFactory);

    return _v1AdminProductsGet();
  }

  ///Display a listing of the resource
  @Get(path: '/v1/admin/products')
  Future<chopper.Response<V1AdminProductsGet$Response>> _v1AdminProductsGet();

  ///Store a newly created resource in storage
  Future<chopper.Response<V1AdminProductsPost$Response>> v1AdminProductsPost(
      {required V1AdminProductsPost$RequestBody? body}) {
    generatedMapping.putIfAbsent(V1AdminProductsPost$Response,
        () => V1AdminProductsPost$Response.fromJsonFactory);

    return _v1AdminProductsPost(body: body);
  }

  ///Store a newly created resource in storage
  @Post(
    path: '/v1/admin/products',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminProductsPost$Response>> _v1AdminProductsPost(
      {@Body() required V1AdminProductsPost$RequestBody? body});

  ///Display the specified resource
  ///@param id
  Future<chopper.Response<V1AdminProductsIdGet$Response>> v1AdminProductsIdGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(V1AdminProductsIdGet$Response,
        () => V1AdminProductsIdGet$Response.fromJsonFactory);

    return _v1AdminProductsIdGet(id: id);
  }

  ///Display the specified resource
  ///@param id
  @Get(path: '/v1/admin/products/{id}')
  Future<chopper.Response<V1AdminProductsIdGet$Response>> _v1AdminProductsIdGet(
      {@Path('id') required String? id});

  ///Update the specified resource in storage
  ///@param id
  Future<chopper.Response<V1AdminProductsIdPut$Response>> v1AdminProductsIdPut({
    required String? id,
    required V1AdminProductsIdPut$RequestBody? body,
  }) {
    generatedMapping.putIfAbsent(V1AdminProductsIdPut$Response,
        () => V1AdminProductsIdPut$Response.fromJsonFactory);

    return _v1AdminProductsIdPut(id: id, body: body);
  }

  ///Update the specified resource in storage
  ///@param id
  @Put(
    path: '/v1/admin/products/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<V1AdminProductsIdPut$Response>>
      _v1AdminProductsIdPut({
    @Path('id') required String? id,
    @Body() required V1AdminProductsIdPut$RequestBody? body,
  });

  ///Remove the specified resource from storage
  ///@param id
  Future<chopper.Response<V1AdminProductsIdDelete$Response>>
      v1AdminProductsIdDelete({required String? id}) {
    generatedMapping.putIfAbsent(V1AdminProductsIdDelete$Response,
        () => V1AdminProductsIdDelete$Response.fromJsonFactory);

    return _v1AdminProductsIdDelete(id: id);
  }

  ///Remove the specified resource from storage
  ///@param id
  @Delete(path: '/v1/admin/products/{id}')
  Future<chopper.Response<V1AdminProductsIdDelete$Response>>
      _v1AdminProductsIdDelete({@Path('id') required String? id});

  ///
  ///@param category
  ///@param search
  ///@param sort_by
  ///@param page
  Future<chopper.Response<V1ShopProductsGet$Response>> v1ShopProductsGet({
    String? category,
    String? search,
    String? sortBy,
    String? page,
  }) {
    generatedMapping.putIfAbsent(V1ShopProductsGet$Response,
        () => V1ShopProductsGet$Response.fromJsonFactory);

    return _v1ShopProductsGet(
        category: category, search: search, sortBy: sortBy, page: page);
  }

  ///
  ///@param category
  ///@param search
  ///@param sort_by
  ///@param page
  @Get(path: '/v1/shop/products')
  Future<chopper.Response<V1ShopProductsGet$Response>> _v1ShopProductsGet({
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('sort_by') String? sortBy,
    @Query('page') String? page,
  });

  ///
  ///@param id
  Future<chopper.Response<V1ShopProductsIdGet$Response>> v1ShopProductsIdGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(V1ShopProductsIdGet$Response,
        () => V1ShopProductsIdGet$Response.fromJsonFactory);

    return _v1ShopProductsIdGet(id: id);
  }

  ///
  ///@param id
  @Get(path: '/v1/shop/products/{id}')
  Future<chopper.Response<V1ShopProductsIdGet$Response>> _v1ShopProductsIdGet(
      {@Path('id') required String? id});

  ///Display a listing of the resource
  Future<chopper.Response<V1AdminUsersGet$Response>> v1AdminUsersGet() {
    generatedMapping.putIfAbsent(V1AdminUsersGet$Response,
        () => V1AdminUsersGet$Response.fromJsonFactory);

    return _v1AdminUsersGet();
  }

  ///Display a listing of the resource
  @Get(path: '/v1/admin/users')
  Future<chopper.Response<V1AdminUsersGet$Response>> _v1AdminUsersGet();
}

@JsonSerializable(explicitToJson: true)
class AddressResource {
  const AddressResource({
    required this.id,
    this.userId,
    this.label,
    this.fullName,
    this.phone,
    required this.street,
    required this.city,
    this.state,
    this.postalCode,
    this.country,
    required this.isDefault,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressResource.fromJson(Map<String, dynamic> json) =>
      _$AddressResourceFromJson(json);

  static const toJsonFactory = _$AddressResourceToJson;
  Map<String, dynamic> toJson() => _$AddressResourceToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'label')
  final String? label;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'street')
  final String street;
  @JsonKey(name: 'city')
  final String city;
  @JsonKey(name: 'state')
  final String? state;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @JsonKey(name: 'country')
  final String? country;
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @JsonKey(name: 'latitude')
  final double? latitude;
  @JsonKey(name: 'longitude')
  final double? longitude;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  static const fromJsonFactory = _$AddressResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddressResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.label, label) ||
                const DeepCollectionEquality().equals(other.label, label)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality()
                    .equals(other.fullName, fullName)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.street, street) ||
                const DeepCollectionEquality().equals(other.street, street)) &&
            (identical(other.city, city) ||
                const DeepCollectionEquality().equals(other.city, city)) &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.postalCode, postalCode) ||
                const DeepCollectionEquality()
                    .equals(other.postalCode, postalCode)) &&
            (identical(other.country, country) ||
                const DeepCollectionEquality()
                    .equals(other.country, country)) &&
            (identical(other.isDefault, isDefault) ||
                const DeepCollectionEquality()
                    .equals(other.isDefault, isDefault)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality()
                    .equals(other.latitude, latitude)) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality()
                    .equals(other.longitude, longitude)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(label) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(street) ^
      const DeepCollectionEquality().hash(city) ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(postalCode) ^
      const DeepCollectionEquality().hash(country) ^
      const DeepCollectionEquality().hash(isDefault) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $AddressResourceExtension on AddressResource {
  AddressResource copyWith(
      {int? id,
      int? userId,
      String? label,
      String? fullName,
      String? phone,
      String? street,
      String? city,
      String? state,
      String? postalCode,
      String? country,
      bool? isDefault,
      double? latitude,
      double? longitude,
      String? createdAt,
      String? updatedAt}) {
    return AddressResource(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        country: country ?? this.country,
        isDefault: isDefault ?? this.isDefault,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  AddressResource copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<int?>? userId,
      Wrapped<String?>? label,
      Wrapped<String?>? fullName,
      Wrapped<String?>? phone,
      Wrapped<String>? street,
      Wrapped<String>? city,
      Wrapped<String?>? state,
      Wrapped<String?>? postalCode,
      Wrapped<String?>? country,
      Wrapped<bool>? isDefault,
      Wrapped<double?>? latitude,
      Wrapped<double?>? longitude,
      Wrapped<String>? createdAt,
      Wrapped<String>? updatedAt}) {
    return AddressResource(
        id: (id != null ? id.value : this.id),
        userId: (userId != null ? userId.value : this.userId),
        label: (label != null ? label.value : this.label),
        fullName: (fullName != null ? fullName.value : this.fullName),
        phone: (phone != null ? phone.value : this.phone),
        street: (street != null ? street.value : this.street),
        city: (city != null ? city.value : this.city),
        state: (state != null ? state.value : this.state),
        postalCode: (postalCode != null ? postalCode.value : this.postalCode),
        country: (country != null ? country.value : this.country),
        isDefault: (isDefault != null ? isDefault.value : this.isDefault),
        latitude: (latitude != null ? latitude.value : this.latitude),
        longitude: (longitude != null ? longitude.value : this.longitude),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class CartItem {
  const CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.price,
    this.imageUrls,
    required this.quantity,
    required this.addedAt,
    this.flavors,
    this.size,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  static const toJsonFactory = _$CartItemToJson;
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'image_urls', defaultValue: <Object>[])
  final List<Object>? imageUrls;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'added_at')
  final DateTime addedAt;
  @JsonKey(name: 'flavors', defaultValue: <Object>[])
  final List<Object>? flavors;
  @JsonKey(name: 'size', defaultValue: <Object>[])
  final List<Object>? size;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  static const fromJsonFactory = _$CartItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CartItem &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.productName, productName) ||
                const DeepCollectionEquality()
                    .equals(other.productName, productName)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.imageUrls, imageUrls) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrls, imageUrls)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.addedAt, addedAt) ||
                const DeepCollectionEquality()
                    .equals(other.addedAt, addedAt)) &&
            (identical(other.flavors, flavors) ||
                const DeepCollectionEquality()
                    .equals(other.flavors, flavors)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(productName) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(imageUrls) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(addedAt) ^
      const DeepCollectionEquality().hash(flavors) ^
      const DeepCollectionEquality().hash(size) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $CartItemExtension on CartItem {
  CartItem copyWith(
      {String? id,
      String? userId,
      String? productId,
      String? productName,
      String? price,
      List<Object>? imageUrls,
      int? quantity,
      DateTime? addedAt,
      List<Object>? flavors,
      List<Object>? size,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return CartItem(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        price: price ?? this.price,
        imageUrls: imageUrls ?? this.imageUrls,
        quantity: quantity ?? this.quantity,
        addedAt: addedAt ?? this.addedAt,
        flavors: flavors ?? this.flavors,
        size: size ?? this.size,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  CartItem copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? userId,
      Wrapped<String>? productId,
      Wrapped<String>? productName,
      Wrapped<String>? price,
      Wrapped<List<Object>?>? imageUrls,
      Wrapped<int>? quantity,
      Wrapped<DateTime>? addedAt,
      Wrapped<List<Object>?>? flavors,
      Wrapped<List<Object>?>? size,
      Wrapped<DateTime?>? createdAt,
      Wrapped<DateTime?>? updatedAt}) {
    return CartItem(
        id: (id != null ? id.value : this.id),
        userId: (userId != null ? userId.value : this.userId),
        productId: (productId != null ? productId.value : this.productId),
        productName:
            (productName != null ? productName.value : this.productName),
        price: (price != null ? price.value : this.price),
        imageUrls: (imageUrls != null ? imageUrls.value : this.imageUrls),
        quantity: (quantity != null ? quantity.value : this.quantity),
        addedAt: (addedAt != null ? addedAt.value : this.addedAt),
        flavors: (flavors != null ? flavors.value : this.flavors),
        size: (size != null ? size.value : this.size),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class CategoryResource {
  const CategoryResource({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.icon,
    required this.sortOrder,
    required this.isActive,
    this.productsCount,
    this.createdAt,
  });

  factory CategoryResource.fromJson(Map<String, dynamic> json) =>
      _$CategoryResourceFromJson(json);

  static const toJsonFactory = _$CategoryResourceToJson;
  Map<String, dynamic> toJson() => _$CategoryResourceToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  @JsonKey(name: 'description', defaultValue: <Object>[])
  final List<Object>? description;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'sortOrder')
  final int sortOrder;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'productsCount')
  final int? productsCount;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  static const fromJsonFactory = _$CategoryResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CategoryResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.sortOrder, sortOrder) ||
                const DeepCollectionEquality()
                    .equals(other.sortOrder, sortOrder)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.productsCount, productsCount) ||
                const DeepCollectionEquality()
                    .equals(other.productsCount, productsCount)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(sortOrder) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(productsCount) ^
      const DeepCollectionEquality().hash(createdAt) ^
      runtimeType.hashCode;
}

extension $CategoryResourceExtension on CategoryResource {
  CategoryResource copyWith(
      {String? id,
      List<Object>? name,
      List<Object>? description,
      String? imageUrl,
      String? icon,
      int? sortOrder,
      bool? isActive,
      int? productsCount,
      String? createdAt}) {
    return CategoryResource(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        icon: icon ?? this.icon,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        productsCount: productsCount ?? this.productsCount,
        createdAt: createdAt ?? this.createdAt);
  }

  CategoryResource copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<Object>>? name,
      Wrapped<List<Object>?>? description,
      Wrapped<String?>? imageUrl,
      Wrapped<String>? icon,
      Wrapped<int>? sortOrder,
      Wrapped<bool>? isActive,
      Wrapped<int?>? productsCount,
      Wrapped<String?>? createdAt}) {
    return CategoryResource(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        icon: (icon != null ? icon.value : this.icon),
        sortOrder: (sortOrder != null ? sortOrder.value : this.sortOrder),
        isActive: (isActive != null ? isActive.value : this.isActive),
        productsCount:
            (productsCount != null ? productsCount.value : this.productsCount),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt));
  }
}

typedef LengthAwarePaginator = List<Object>;

@JsonSerializable(explicitToJson: true)
class OrderItemResource {
  const OrderItemResource({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    this.imageUrl,
    this.selectedFlavor,
    this.selectedSize,
    this.$selectedFlavor,
    this.$selectedSize,
  });

  factory OrderItemResource.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResourceFromJson(json);

  static const toJsonFactory = _$OrderItemResourceToJson;
  Map<String, dynamic> toJson() => _$OrderItemResourceToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final dynamic productName;
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'selected_flavor')
  final String? selectedFlavor;
  @JsonKey(name: 'selected_size')
  final String? selectedSize;
  @JsonKey(name: 'selectedFlavor')
  final String? $selectedFlavor;
  @JsonKey(name: 'selectedSize')
  final String? $selectedSize;
  static const fromJsonFactory = _$OrderItemResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderItemResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.orderId, orderId) ||
                const DeepCollectionEquality()
                    .equals(other.orderId, orderId)) &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.productName, productName) ||
                const DeepCollectionEquality()
                    .equals(other.productName, productName)) &&
            (identical(other.unitPrice, unitPrice) ||
                const DeepCollectionEquality()
                    .equals(other.unitPrice, unitPrice)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.subtotal, subtotal) ||
                const DeepCollectionEquality()
                    .equals(other.subtotal, subtotal)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.selectedFlavor, selectedFlavor)) &&
            (identical(other.selectedSize, selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.selectedSize, selectedSize)) &&
            (identical(other.$selectedFlavor, $selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedFlavor, $selectedFlavor)) &&
            (identical(other.$selectedSize, $selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedSize, $selectedSize)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(orderId) ^
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(productName) ^
      const DeepCollectionEquality().hash(unitPrice) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(subtotal) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(selectedFlavor) ^
      const DeepCollectionEquality().hash(selectedSize) ^
      const DeepCollectionEquality().hash($selectedFlavor) ^
      const DeepCollectionEquality().hash($selectedSize) ^
      runtimeType.hashCode;
}

extension $OrderItemResourceExtension on OrderItemResource {
  OrderItemResource copyWith(
      {String? id,
      String? orderId,
      String? productId,
      dynamic productName,
      double? unitPrice,
      int? quantity,
      double? subtotal,
      String? imageUrl,
      String? selectedFlavor,
      String? selectedSize,
      String? $selectedFlavor,
      String? $selectedSize}) {
    return OrderItemResource(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        subtotal: subtotal ?? this.subtotal,
        imageUrl: imageUrl ?? this.imageUrl,
        selectedFlavor: selectedFlavor ?? this.selectedFlavor,
        selectedSize: selectedSize ?? this.selectedSize,
        $selectedFlavor: $selectedFlavor ?? this.$selectedFlavor,
        $selectedSize: $selectedSize ?? this.$selectedSize);
  }

  OrderItemResource copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? orderId,
      Wrapped<String>? productId,
      Wrapped<dynamic>? productName,
      Wrapped<double>? unitPrice,
      Wrapped<int>? quantity,
      Wrapped<double>? subtotal,
      Wrapped<String?>? imageUrl,
      Wrapped<String?>? selectedFlavor,
      Wrapped<String?>? selectedSize,
      Wrapped<String?>? $selectedFlavor,
      Wrapped<String?>? $selectedSize}) {
    return OrderItemResource(
        id: (id != null ? id.value : this.id),
        orderId: (orderId != null ? orderId.value : this.orderId),
        productId: (productId != null ? productId.value : this.productId),
        productName:
            (productName != null ? productName.value : this.productName),
        unitPrice: (unitPrice != null ? unitPrice.value : this.unitPrice),
        quantity: (quantity != null ? quantity.value : this.quantity),
        subtotal: (subtotal != null ? subtotal.value : this.subtotal),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        selectedFlavor: (selectedFlavor != null
            ? selectedFlavor.value
            : this.selectedFlavor),
        selectedSize:
            (selectedSize != null ? selectedSize.value : this.selectedSize),
        $selectedFlavor: ($selectedFlavor != null
            ? $selectedFlavor.value
            : this.$selectedFlavor),
        $selectedSize:
            ($selectedSize != null ? $selectedSize.value : this.$selectedSize));
  }
}

@JsonSerializable(explicitToJson: true)
class OrderResource {
  const OrderResource({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.addressId,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.totalAmount,
    this.trackingNumber,
    required this.phoneNumber,
    this.notes,
    this.shippingAddress,
    this.orderItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderResource.fromJson(Map<String, dynamic> json) =>
      _$OrderResourceFromJson(json);

  static const toJsonFactory = _$OrderResourceToJson;
  Map<String, dynamic> toJson() => _$OrderResourceToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'order_date')
  final dynamic orderDate;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'address_id')
  final String addressId;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  @JsonKey(name: 'shippingCost')
  final double shippingCost;
  @JsonKey(name: 'discount')
  final double discount;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'shipping_address', defaultValue: <Object>[])
  final List<Object>? shippingAddress;
  @JsonKey(name: 'order_items', defaultValue: <OrderItemResource>[])
  final List<OrderItemResource>? orderItems;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  static const fromJsonFactory = _$OrderResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OrderResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.orderDate, orderDate) ||
                const DeepCollectionEquality()
                    .equals(other.orderDate, orderDate)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.paymentStatus, paymentStatus) ||
                const DeepCollectionEquality()
                    .equals(other.paymentStatus, paymentStatus)) &&
            (identical(other.paymentMethod, paymentMethod) ||
                const DeepCollectionEquality()
                    .equals(other.paymentMethod, paymentMethod)) &&
            (identical(other.addressId, addressId) ||
                const DeepCollectionEquality()
                    .equals(other.addressId, addressId)) &&
            (identical(other.subtotal, subtotal) ||
                const DeepCollectionEquality()
                    .equals(other.subtotal, subtotal)) &&
            (identical(other.shippingCost, shippingCost) ||
                const DeepCollectionEquality()
                    .equals(other.shippingCost, shippingCost)) &&
            (identical(other.discount, discount) ||
                const DeepCollectionEquality()
                    .equals(other.discount, discount)) &&
            (identical(other.totalAmount, totalAmount) ||
                const DeepCollectionEquality()
                    .equals(other.totalAmount, totalAmount)) &&
            (identical(other.trackingNumber, trackingNumber) ||
                const DeepCollectionEquality()
                    .equals(other.trackingNumber, trackingNumber)) &&
            (identical(other.phoneNumber, phoneNumber) ||
                const DeepCollectionEquality()
                    .equals(other.phoneNumber, phoneNumber)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)) &&
            (identical(other.shippingAddress, shippingAddress) ||
                const DeepCollectionEquality()
                    .equals(other.shippingAddress, shippingAddress)) &&
            (identical(other.orderItems, orderItems) ||
                const DeepCollectionEquality()
                    .equals(other.orderItems, orderItems)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(orderDate) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(paymentStatus) ^
      const DeepCollectionEquality().hash(paymentMethod) ^
      const DeepCollectionEquality().hash(addressId) ^
      const DeepCollectionEquality().hash(subtotal) ^
      const DeepCollectionEquality().hash(shippingCost) ^
      const DeepCollectionEquality().hash(discount) ^
      const DeepCollectionEquality().hash(totalAmount) ^
      const DeepCollectionEquality().hash(trackingNumber) ^
      const DeepCollectionEquality().hash(phoneNumber) ^
      const DeepCollectionEquality().hash(notes) ^
      const DeepCollectionEquality().hash(shippingAddress) ^
      const DeepCollectionEquality().hash(orderItems) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $OrderResourceExtension on OrderResource {
  OrderResource copyWith(
      {String? id,
      String? userId,
      dynamic orderDate,
      String? status,
      String? paymentStatus,
      String? paymentMethod,
      String? addressId,
      double? subtotal,
      double? shippingCost,
      double? discount,
      double? totalAmount,
      String? trackingNumber,
      String? phoneNumber,
      String? notes,
      List<Object>? shippingAddress,
      List<OrderItemResource>? orderItems,
      String? createdAt,
      String? updatedAt}) {
    return OrderResource(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        orderDate: orderDate ?? this.orderDate,
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        addressId: addressId ?? this.addressId,
        subtotal: subtotal ?? this.subtotal,
        shippingCost: shippingCost ?? this.shippingCost,
        discount: discount ?? this.discount,
        totalAmount: totalAmount ?? this.totalAmount,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        notes: notes ?? this.notes,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        orderItems: orderItems ?? this.orderItems,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  OrderResource copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? userId,
      Wrapped<dynamic>? orderDate,
      Wrapped<String>? status,
      Wrapped<String>? paymentStatus,
      Wrapped<String>? paymentMethod,
      Wrapped<String>? addressId,
      Wrapped<double>? subtotal,
      Wrapped<double>? shippingCost,
      Wrapped<double>? discount,
      Wrapped<double>? totalAmount,
      Wrapped<String?>? trackingNumber,
      Wrapped<String>? phoneNumber,
      Wrapped<String?>? notes,
      Wrapped<List<Object>?>? shippingAddress,
      Wrapped<List<OrderItemResource>?>? orderItems,
      Wrapped<String>? createdAt,
      Wrapped<String>? updatedAt}) {
    return OrderResource(
        id: (id != null ? id.value : this.id),
        userId: (userId != null ? userId.value : this.userId),
        orderDate: (orderDate != null ? orderDate.value : this.orderDate),
        status: (status != null ? status.value : this.status),
        paymentStatus:
            (paymentStatus != null ? paymentStatus.value : this.paymentStatus),
        paymentMethod:
            (paymentMethod != null ? paymentMethod.value : this.paymentMethod),
        addressId: (addressId != null ? addressId.value : this.addressId),
        subtotal: (subtotal != null ? subtotal.value : this.subtotal),
        shippingCost:
            (shippingCost != null ? shippingCost.value : this.shippingCost),
        discount: (discount != null ? discount.value : this.discount),
        totalAmount:
            (totalAmount != null ? totalAmount.value : this.totalAmount),
        trackingNumber: (trackingNumber != null
            ? trackingNumber.value
            : this.trackingNumber),
        phoneNumber:
            (phoneNumber != null ? phoneNumber.value : this.phoneNumber),
        notes: (notes != null ? notes.value : this.notes),
        shippingAddress: (shippingAddress != null
            ? shippingAddress.value
            : this.shippingAddress),
        orderItems: (orderItems != null ? orderItems.value : this.orderItems),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class ProductResource {
  const ProductResource({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    this.category,
    required this.imageUrls,
    required this.hasVariants,
    this.productVariants,
    required this.price,
    this.discountPrice,
    required this.stockQuantity,
    required this.averageRating,
    required this.reviewCount,
    this.servingSize,
    required this.servingsPerContainer,
    this.nutritionFacts,
    required this.flavors,
    required this.productSizes,
    required this.size,
    required this.tags,
    this.weight,
    required this.isActive,
    required this.isBackgroundWhite,
    required this.featured,
    required this.newArrival,
    required this.bestSeller,
    this.sku,
    required this.totalSales,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductResource.fromJson(Map<String, dynamic> json) =>
      _$ProductResourceFromJson(json);

  static const toJsonFactory = _$ProductResourceToJson;
  Map<String, dynamic> toJson() => _$ProductResourceToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  @JsonKey(name: 'description', defaultValue: <Object>[])
  final List<Object> description;
  @JsonKey(name: 'brand')
  final String brand;
  @JsonKey(name: 'category')
  final ProductResource$Category? category;
  @JsonKey(name: 'imageUrls')
  final List<ProductResource$ImageUrls$Item> imageUrls;
  @JsonKey(name: 'has_variants')
  final bool hasVariants;
  @JsonKey(name: 'product_variants', defaultValue: <ProductVariantResource>[])
  final List<ProductVariantResource>? productVariants;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'average_rating')
  final double averageRating;
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @JsonKey(name: 'servings_per_container')
  final int servingsPerContainer;
  @JsonKey(name: 'nutrition_facts', defaultValue: <Object>[])
  final List<Object>? nutritionFacts;
  @JsonKey(name: 'flavors')
  final dynamic flavors;
  @JsonKey(name: 'product_sizes')
  final dynamic productSizes;
  @JsonKey(name: 'size')
  final dynamic size;
  @JsonKey(name: 'tags')
  final dynamic tags;
  @JsonKey(name: 'weight')
  final double? weight;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'is_background_white')
  final bool isBackgroundWhite;
  @JsonKey(name: 'featured')
  final bool featured;
  @JsonKey(name: 'new_arrival')
  final bool newArrival;
  @JsonKey(name: 'best_seller')
  final bool bestSeller;
  @JsonKey(name: 'sku')
  final String? sku;
  @JsonKey(name: 'total_sales')
  final int totalSales;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  static const fromJsonFactory = _$ProductResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProductResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.brand, brand) ||
                const DeepCollectionEquality().equals(other.brand, brand)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.imageUrls, imageUrls) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrls, imageUrls)) &&
            (identical(other.hasVariants, hasVariants) ||
                const DeepCollectionEquality()
                    .equals(other.hasVariants, hasVariants)) &&
            (identical(other.productVariants, productVariants) ||
                const DeepCollectionEquality()
                    .equals(other.productVariants, productVariants)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.averageRating, averageRating) ||
                const DeepCollectionEquality()
                    .equals(other.averageRating, averageRating)) &&
            (identical(other.reviewCount, reviewCount) ||
                const DeepCollectionEquality()
                    .equals(other.reviewCount, reviewCount)) &&
            (identical(other.servingSize, servingSize) ||
                const DeepCollectionEquality()
                    .equals(other.servingSize, servingSize)) &&
            (identical(other.servingsPerContainer, servingsPerContainer) ||
                const DeepCollectionEquality().equals(
                    other.servingsPerContainer, servingsPerContainer)) &&
            (identical(other.nutritionFacts, nutritionFacts) ||
                const DeepCollectionEquality()
                    .equals(other.nutritionFacts, nutritionFacts)) &&
            (identical(other.flavors, flavors) ||
                const DeepCollectionEquality()
                    .equals(other.flavors, flavors)) &&
            (identical(other.productSizes, productSizes) ||
                const DeepCollectionEquality()
                    .equals(other.productSizes, productSizes)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)) &&
            (identical(other.weight, weight) ||
                const DeepCollectionEquality().equals(other.weight, weight)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.isBackgroundWhite, isBackgroundWhite) ||
                const DeepCollectionEquality()
                    .equals(other.isBackgroundWhite, isBackgroundWhite)) &&
            (identical(other.featured, featured) ||
                const DeepCollectionEquality()
                    .equals(other.featured, featured)) &&
            (identical(other.newArrival, newArrival) ||
                const DeepCollectionEquality()
                    .equals(other.newArrival, newArrival)) &&
            (identical(other.bestSeller, bestSeller) || const DeepCollectionEquality().equals(other.bestSeller, bestSeller)) &&
            (identical(other.sku, sku) || const DeepCollectionEquality().equals(other.sku, sku)) &&
            (identical(other.totalSales, totalSales) || const DeepCollectionEquality().equals(other.totalSales, totalSales)) &&
            (identical(other.createdAt, createdAt) || const DeepCollectionEquality().equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) || const DeepCollectionEquality().equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(brand) ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(imageUrls) ^
      const DeepCollectionEquality().hash(hasVariants) ^
      const DeepCollectionEquality().hash(productVariants) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(averageRating) ^
      const DeepCollectionEquality().hash(reviewCount) ^
      const DeepCollectionEquality().hash(servingSize) ^
      const DeepCollectionEquality().hash(servingsPerContainer) ^
      const DeepCollectionEquality().hash(nutritionFacts) ^
      const DeepCollectionEquality().hash(flavors) ^
      const DeepCollectionEquality().hash(productSizes) ^
      const DeepCollectionEquality().hash(size) ^
      const DeepCollectionEquality().hash(tags) ^
      const DeepCollectionEquality().hash(weight) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isBackgroundWhite) ^
      const DeepCollectionEquality().hash(featured) ^
      const DeepCollectionEquality().hash(newArrival) ^
      const DeepCollectionEquality().hash(bestSeller) ^
      const DeepCollectionEquality().hash(sku) ^
      const DeepCollectionEquality().hash(totalSales) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $ProductResourceExtension on ProductResource {
  ProductResource copyWith(
      {String? id,
      List<Object>? name,
      List<Object>? description,
      String? brand,
      ProductResource$Category? category,
      List<ProductResource$ImageUrls$Item>? imageUrls,
      bool? hasVariants,
      List<ProductVariantResource>? productVariants,
      double? price,
      double? discountPrice,
      int? stockQuantity,
      double? averageRating,
      int? reviewCount,
      String? servingSize,
      int? servingsPerContainer,
      List<Object>? nutritionFacts,
      dynamic flavors,
      dynamic productSizes,
      dynamic size,
      dynamic tags,
      double? weight,
      bool? isActive,
      bool? isBackgroundWhite,
      bool? featured,
      bool? newArrival,
      bool? bestSeller,
      String? sku,
      int? totalSales,
      String? createdAt,
      String? updatedAt}) {
    return ProductResource(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        brand: brand ?? this.brand,
        category: category ?? this.category,
        imageUrls: imageUrls ?? this.imageUrls,
        hasVariants: hasVariants ?? this.hasVariants,
        productVariants: productVariants ?? this.productVariants,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        averageRating: averageRating ?? this.averageRating,
        reviewCount: reviewCount ?? this.reviewCount,
        servingSize: servingSize ?? this.servingSize,
        servingsPerContainer: servingsPerContainer ?? this.servingsPerContainer,
        nutritionFacts: nutritionFacts ?? this.nutritionFacts,
        flavors: flavors ?? this.flavors,
        productSizes: productSizes ?? this.productSizes,
        size: size ?? this.size,
        tags: tags ?? this.tags,
        weight: weight ?? this.weight,
        isActive: isActive ?? this.isActive,
        isBackgroundWhite: isBackgroundWhite ?? this.isBackgroundWhite,
        featured: featured ?? this.featured,
        newArrival: newArrival ?? this.newArrival,
        bestSeller: bestSeller ?? this.bestSeller,
        sku: sku ?? this.sku,
        totalSales: totalSales ?? this.totalSales,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  ProductResource copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<Object>>? name,
      Wrapped<List<Object>>? description,
      Wrapped<String>? brand,
      Wrapped<ProductResource$Category?>? category,
      Wrapped<List<ProductResource$ImageUrls$Item>>? imageUrls,
      Wrapped<bool>? hasVariants,
      Wrapped<List<ProductVariantResource>?>? productVariants,
      Wrapped<double>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<int>? stockQuantity,
      Wrapped<double>? averageRating,
      Wrapped<int>? reviewCount,
      Wrapped<String?>? servingSize,
      Wrapped<int>? servingsPerContainer,
      Wrapped<List<Object>?>? nutritionFacts,
      Wrapped<dynamic>? flavors,
      Wrapped<dynamic>? productSizes,
      Wrapped<dynamic>? size,
      Wrapped<dynamic>? tags,
      Wrapped<double?>? weight,
      Wrapped<bool>? isActive,
      Wrapped<bool>? isBackgroundWhite,
      Wrapped<bool>? featured,
      Wrapped<bool>? newArrival,
      Wrapped<bool>? bestSeller,
      Wrapped<String?>? sku,
      Wrapped<int>? totalSales,
      Wrapped<String>? createdAt,
      Wrapped<String>? updatedAt}) {
    return ProductResource(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        brand: (brand != null ? brand.value : this.brand),
        category: (category != null ? category.value : this.category),
        imageUrls: (imageUrls != null ? imageUrls.value : this.imageUrls),
        hasVariants:
            (hasVariants != null ? hasVariants.value : this.hasVariants),
        productVariants: (productVariants != null
            ? productVariants.value
            : this.productVariants),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        averageRating:
            (averageRating != null ? averageRating.value : this.averageRating),
        reviewCount:
            (reviewCount != null ? reviewCount.value : this.reviewCount),
        servingSize:
            (servingSize != null ? servingSize.value : this.servingSize),
        servingsPerContainer: (servingsPerContainer != null
            ? servingsPerContainer.value
            : this.servingsPerContainer),
        nutritionFacts: (nutritionFacts != null
            ? nutritionFacts.value
            : this.nutritionFacts),
        flavors: (flavors != null ? flavors.value : this.flavors),
        productSizes:
            (productSizes != null ? productSizes.value : this.productSizes),
        size: (size != null ? size.value : this.size),
        tags: (tags != null ? tags.value : this.tags),
        weight: (weight != null ? weight.value : this.weight),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isBackgroundWhite: (isBackgroundWhite != null
            ? isBackgroundWhite.value
            : this.isBackgroundWhite),
        featured: (featured != null ? featured.value : this.featured),
        newArrival: (newArrival != null ? newArrival.value : this.newArrival),
        bestSeller: (bestSeller != null ? bestSeller.value : this.bestSeller),
        sku: (sku != null ? sku.value : this.sku),
        totalSales: (totalSales != null ? totalSales.value : this.totalSales),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class ProductVariantResource {
  const ProductVariantResource({
    required this.id,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.effectivePrice,
    required this.stockQuantity,
    required this.attributes,
    required this.isActive,
    required this.discountStartDate,
    required this.discountEndDate,
  });

  factory ProductVariantResource.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantResourceFromJson(json);

  static const toJsonFactory = _$ProductVariantResourceToJson;
  Map<String, dynamic> toJson() => _$ProductVariantResourceToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'sku')
  final String sku;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'effective_price')
  final double effectivePrice;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'attributes', defaultValue: <Object>[])
  final List<Object> attributes;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'discount_start_date')
  final String discountStartDate;
  @JsonKey(name: 'discount_end_date')
  final String discountEndDate;
  static const fromJsonFactory = _$ProductVariantResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProductVariantResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.sku, sku) ||
                const DeepCollectionEquality().equals(other.sku, sku)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.effectivePrice, effectivePrice) ||
                const DeepCollectionEquality()
                    .equals(other.effectivePrice, effectivePrice)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.discountStartDate, discountStartDate) ||
                const DeepCollectionEquality()
                    .equals(other.discountStartDate, discountStartDate)) &&
            (identical(other.discountEndDate, discountEndDate) ||
                const DeepCollectionEquality()
                    .equals(other.discountEndDate, discountEndDate)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(sku) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(effectivePrice) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(discountStartDate) ^
      const DeepCollectionEquality().hash(discountEndDate) ^
      runtimeType.hashCode;
}

extension $ProductVariantResourceExtension on ProductVariantResource {
  ProductVariantResource copyWith(
      {String? id,
      String? sku,
      double? price,
      double? discountPrice,
      double? effectivePrice,
      int? stockQuantity,
      List<Object>? attributes,
      bool? isActive,
      String? discountStartDate,
      String? discountEndDate}) {
    return ProductVariantResource(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        effectivePrice: effectivePrice ?? this.effectivePrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        attributes: attributes ?? this.attributes,
        isActive: isActive ?? this.isActive,
        discountStartDate: discountStartDate ?? this.discountStartDate,
        discountEndDate: discountEndDate ?? this.discountEndDate);
  }

  ProductVariantResource copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? sku,
      Wrapped<double>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<double>? effectivePrice,
      Wrapped<int>? stockQuantity,
      Wrapped<List<Object>>? attributes,
      Wrapped<bool>? isActive,
      Wrapped<String>? discountStartDate,
      Wrapped<String>? discountEndDate}) {
    return ProductVariantResource(
        id: (id != null ? id.value : this.id),
        sku: (sku != null ? sku.value : this.sku),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        effectivePrice: (effectivePrice != null
            ? effectivePrice.value
            : this.effectivePrice),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        attributes: (attributes != null ? attributes.value : this.attributes),
        isActive: (isActive != null ? isActive.value : this.isActive),
        discountStartDate: (discountStartDate != null
            ? discountStartDate.value
            : this.discountStartDate),
        discountEndDate: (discountEndDate != null
            ? discountEndDate.value
            : this.discountEndDate));
  }
}

@JsonSerializable(explicitToJson: true)
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.photoUrl,
    this.phoneNumber,
    this.defaultAddressId,
    required this.preferredLanguage,
    required this.notificationsEnabled,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    required this.role,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const toJsonFactory = _$UserToJson;
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'default_address_id')
  final String? defaultAddressId;
  @JsonKey(name: 'preferred_language')
  final String preferredLanguage;
  @JsonKey(name: 'notifications_enabled')
  final int notificationsEnabled;
  @JsonKey(name: 'is_active')
  final int isActive;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  static const fromJsonFactory = _$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.emailVerifiedAt, emailVerifiedAt) ||
                const DeepCollectionEquality()
                    .equals(other.emailVerifiedAt, emailVerifiedAt)) &&
            (identical(other.photoUrl, photoUrl) ||
                const DeepCollectionEquality()
                    .equals(other.photoUrl, photoUrl)) &&
            (identical(other.phoneNumber, phoneNumber) ||
                const DeepCollectionEquality()
                    .equals(other.phoneNumber, phoneNumber)) &&
            (identical(other.defaultAddressId, defaultAddressId) ||
                const DeepCollectionEquality()
                    .equals(other.defaultAddressId, defaultAddressId)) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                const DeepCollectionEquality()
                    .equals(other.preferredLanguage, preferredLanguage)) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                const DeepCollectionEquality().equals(
                    other.notificationsEnabled, notificationsEnabled)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.lastLogin, lastLogin) ||
                const DeepCollectionEquality()
                    .equals(other.lastLogin, lastLogin)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(emailVerifiedAt) ^
      const DeepCollectionEquality().hash(photoUrl) ^
      const DeepCollectionEquality().hash(phoneNumber) ^
      const DeepCollectionEquality().hash(defaultAddressId) ^
      const DeepCollectionEquality().hash(preferredLanguage) ^
      const DeepCollectionEquality().hash(notificationsEnabled) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(lastLogin) ^
      runtimeType.hashCode;
}

extension $UserExtension on User {
  User copyWith(
      {int? id,
      String? name,
      String? email,
      DateTime? emailVerifiedAt,
      String? photoUrl,
      String? phoneNumber,
      String? defaultAddressId,
      String? preferredLanguage,
      int? notificationsEnabled,
      int? isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? role,
      DateTime? lastLogin}) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        photoUrl: photoUrl ?? this.photoUrl,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        defaultAddressId: defaultAddressId ?? this.defaultAddressId,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        role: role ?? this.role,
        lastLogin: lastLogin ?? this.lastLogin);
  }

  User copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<String>? name,
      Wrapped<String>? email,
      Wrapped<DateTime?>? emailVerifiedAt,
      Wrapped<String?>? photoUrl,
      Wrapped<String?>? phoneNumber,
      Wrapped<String?>? defaultAddressId,
      Wrapped<String>? preferredLanguage,
      Wrapped<int>? notificationsEnabled,
      Wrapped<int>? isActive,
      Wrapped<DateTime?>? createdAt,
      Wrapped<DateTime?>? updatedAt,
      Wrapped<String>? role,
      Wrapped<DateTime?>? lastLogin}) {
    return User(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        emailVerifiedAt: (emailVerifiedAt != null
            ? emailVerifiedAt.value
            : this.emailVerifiedAt),
        photoUrl: (photoUrl != null ? photoUrl.value : this.photoUrl),
        phoneNumber:
            (phoneNumber != null ? phoneNumber.value : this.phoneNumber),
        defaultAddressId: (defaultAddressId != null
            ? defaultAddressId.value
            : this.defaultAddressId),
        preferredLanguage: (preferredLanguage != null
            ? preferredLanguage.value
            : this.preferredLanguage),
        notificationsEnabled: (notificationsEnabled != null
            ? notificationsEnabled.value
            : this.notificationsEnabled),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
        role: (role != null ? role.value : this.role),
        lastLogin: (lastLogin != null ? lastLogin.value : this.lastLogin));
  }
}

@JsonSerializable(explicitToJson: true)
class UserResource {
  const UserResource({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.defaultAddressId,
    required this.preferredLanguage,
    required this.notificationsEnabled,
    required this.isActive,
    required this.role,
    required this.totalSpent,
    required this.ordersCount,
    this.addresses,
    required this.createdAt,
    required this.lastLogin,
  });

  factory UserResource.fromJson(Map<String, dynamic> json) =>
      _$UserResourceFromJson(json);

  static const toJsonFactory = _$UserResourceToJson;
  Map<String, dynamic> toJson() => _$UserResourceToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(name: 'default_address_id')
  final String? defaultAddressId;
  @JsonKey(name: 'preferred_language')
  final dynamic preferredLanguage;
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'role')
  final dynamic role;
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @JsonKey(name: 'orders_count')
  final int ordersCount;
  @JsonKey(name: 'addresses', defaultValue: <AddressResource>[])
  final List<AddressResource>? addresses;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'last_login')
  final String lastLogin;
  static const fromJsonFactory = _$UserResourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserResource &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.photoUrl, photoUrl) ||
                const DeepCollectionEquality()
                    .equals(other.photoUrl, photoUrl)) &&
            (identical(other.defaultAddressId, defaultAddressId) ||
                const DeepCollectionEquality()
                    .equals(other.defaultAddressId, defaultAddressId)) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                const DeepCollectionEquality()
                    .equals(other.preferredLanguage, preferredLanguage)) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                const DeepCollectionEquality().equals(
                    other.notificationsEnabled, notificationsEnabled)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.totalSpent, totalSpent) ||
                const DeepCollectionEquality()
                    .equals(other.totalSpent, totalSpent)) &&
            (identical(other.ordersCount, ordersCount) ||
                const DeepCollectionEquality()
                    .equals(other.ordersCount, ordersCount)) &&
            (identical(other.addresses, addresses) ||
                const DeepCollectionEquality()
                    .equals(other.addresses, addresses)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.lastLogin, lastLogin) ||
                const DeepCollectionEquality()
                    .equals(other.lastLogin, lastLogin)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(photoUrl) ^
      const DeepCollectionEquality().hash(defaultAddressId) ^
      const DeepCollectionEquality().hash(preferredLanguage) ^
      const DeepCollectionEquality().hash(notificationsEnabled) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(totalSpent) ^
      const DeepCollectionEquality().hash(ordersCount) ^
      const DeepCollectionEquality().hash(addresses) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(lastLogin) ^
      runtimeType.hashCode;
}

extension $UserResourceExtension on UserResource {
  UserResource copyWith(
      {String? id,
      String? name,
      String? email,
      String? phone,
      String? photoUrl,
      String? defaultAddressId,
      dynamic preferredLanguage,
      bool? notificationsEnabled,
      bool? isActive,
      dynamic role,
      double? totalSpent,
      int? ordersCount,
      List<AddressResource>? addresses,
      String? createdAt,
      String? lastLogin}) {
    return UserResource(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        photoUrl: photoUrl ?? this.photoUrl,
        defaultAddressId: defaultAddressId ?? this.defaultAddressId,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        isActive: isActive ?? this.isActive,
        role: role ?? this.role,
        totalSpent: totalSpent ?? this.totalSpent,
        ordersCount: ordersCount ?? this.ordersCount,
        addresses: addresses ?? this.addresses,
        createdAt: createdAt ?? this.createdAt,
        lastLogin: lastLogin ?? this.lastLogin);
  }

  UserResource copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? name,
      Wrapped<String>? email,
      Wrapped<String?>? phone,
      Wrapped<String?>? photoUrl,
      Wrapped<String?>? defaultAddressId,
      Wrapped<dynamic>? preferredLanguage,
      Wrapped<bool>? notificationsEnabled,
      Wrapped<bool>? isActive,
      Wrapped<dynamic>? role,
      Wrapped<double>? totalSpent,
      Wrapped<int>? ordersCount,
      Wrapped<List<AddressResource>?>? addresses,
      Wrapped<String>? createdAt,
      Wrapped<String>? lastLogin}) {
    return UserResource(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        phone: (phone != null ? phone.value : this.phone),
        photoUrl: (photoUrl != null ? photoUrl.value : this.photoUrl),
        defaultAddressId: (defaultAddressId != null
            ? defaultAddressId.value
            : this.defaultAddressId),
        preferredLanguage: (preferredLanguage != null
            ? preferredLanguage.value
            : this.preferredLanguage),
        notificationsEnabled: (notificationsEnabled != null
            ? notificationsEnabled.value
            : this.notificationsEnabled),
        isActive: (isActive != null ? isActive.value : this.isActive),
        role: (role != null ? role.value : this.role),
        totalSpent: (totalSpent != null ? totalSpent.value : this.totalSpent),
        ordersCount:
            (ordersCount != null ? ordersCount.value : this.ordersCount),
        addresses: (addresses != null ? addresses.value : this.addresses),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        lastLogin: (lastLogin != null ? lastLogin.value : this.lastLogin));
  }
}

@JsonSerializable(explicitToJson: true)
class AuthenticationException$Response {
  const AuthenticationException$Response({
    required this.message,
  });

  factory AuthenticationException$Response.fromJson(
          Map<String, dynamic> json) =>
      _$AuthenticationException$ResponseFromJson(json);

  static const toJsonFactory = _$AuthenticationException$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$AuthenticationException$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$AuthenticationException$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AuthenticationException$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $AuthenticationException$ResponseExtension
    on AuthenticationException$Response {
  AuthenticationException$Response copyWith({String? message}) {
    return AuthenticationException$Response(message: message ?? this.message);
  }

  AuthenticationException$Response copyWithWrapped({Wrapped<String>? message}) {
    return AuthenticationException$Response(
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationException$Response {
  const ValidationException$Response({
    required this.message,
    required this.errors,
  });

  factory ValidationException$Response.fromJson(Map<String, dynamic> json) =>
      _$ValidationException$ResponseFromJson(json);

  static const toJsonFactory = _$ValidationException$ResponseToJson;
  Map<String, dynamic> toJson() => _$ValidationException$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'errors')
  final Map<String, dynamic> errors;
  static const fromJsonFactory = _$ValidationException$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationException$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.errors, errors) ||
                const DeepCollectionEquality().equals(other.errors, errors)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(errors) ^
      runtimeType.hashCode;
}

extension $ValidationException$ResponseExtension
    on ValidationException$Response {
  ValidationException$Response copyWith(
      {String? message, Map<String, dynamic>? errors}) {
    return ValidationException$Response(
        message: message ?? this.message, errors: errors ?? this.errors);
  }

  ValidationException$Response copyWithWrapped(
      {Wrapped<String>? message, Wrapped<Map<String, dynamic>>? errors}) {
    return ValidationException$Response(
        message: (message != null ? message.value : this.message),
        errors: (errors != null ? errors.value : this.errors));
  }
}

@JsonSerializable(explicitToJson: true)
class ModelNotFoundException$Response {
  const ModelNotFoundException$Response({
    required this.message,
  });

  factory ModelNotFoundException$Response.fromJson(Map<String, dynamic> json) =>
      _$ModelNotFoundException$ResponseFromJson(json);

  static const toJsonFactory = _$ModelNotFoundException$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$ModelNotFoundException$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$ModelNotFoundException$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ModelNotFoundException$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ModelNotFoundException$ResponseExtension
    on ModelNotFoundException$Response {
  ModelNotFoundException$Response copyWith({String? message}) {
    return ModelNotFoundException$Response(message: message ?? this.message);
  }

  ModelNotFoundException$Response copyWithWrapped({Wrapped<String>? message}) {
    return ModelNotFoundException$Response(
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerAddressesPost$RequestBody {
  const V1CustomerAddressesPost$RequestBody({
    this.label,
    this.fullName,
    this.phone,
    required this.street,
    required this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault,
    this.latitude,
    this.longitude,
  });

  factory V1CustomerAddressesPost$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1CustomerAddressesPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1CustomerAddressesPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerAddressesPost$RequestBodyToJson(this);

  @JsonKey(name: 'label')
  final String? label;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'street')
  final String street;
  @JsonKey(name: 'city')
  final String city;
  @JsonKey(name: 'state')
  final String? state;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @JsonKey(name: 'country')
  final String? country;
  @JsonKey(name: 'is_default')
  final bool? isDefault;
  @JsonKey(name: 'latitude')
  final double? latitude;
  @JsonKey(name: 'longitude')
  final double? longitude;
  static const fromJsonFactory = _$V1CustomerAddressesPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerAddressesPost$RequestBody &&
            (identical(other.label, label) ||
                const DeepCollectionEquality().equals(other.label, label)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality()
                    .equals(other.fullName, fullName)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.street, street) ||
                const DeepCollectionEquality().equals(other.street, street)) &&
            (identical(other.city, city) ||
                const DeepCollectionEquality().equals(other.city, city)) &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.postalCode, postalCode) ||
                const DeepCollectionEquality()
                    .equals(other.postalCode, postalCode)) &&
            (identical(other.country, country) ||
                const DeepCollectionEquality()
                    .equals(other.country, country)) &&
            (identical(other.isDefault, isDefault) ||
                const DeepCollectionEquality()
                    .equals(other.isDefault, isDefault)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality()
                    .equals(other.latitude, latitude)) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality()
                    .equals(other.longitude, longitude)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(label) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(street) ^
      const DeepCollectionEquality().hash(city) ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(postalCode) ^
      const DeepCollectionEquality().hash(country) ^
      const DeepCollectionEquality().hash(isDefault) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      runtimeType.hashCode;
}

extension $V1CustomerAddressesPost$RequestBodyExtension
    on V1CustomerAddressesPost$RequestBody {
  V1CustomerAddressesPost$RequestBody copyWith(
      {String? label,
      String? fullName,
      String? phone,
      String? street,
      String? city,
      String? state,
      String? postalCode,
      String? country,
      bool? isDefault,
      double? latitude,
      double? longitude}) {
    return V1CustomerAddressesPost$RequestBody(
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        country: country ?? this.country,
        isDefault: isDefault ?? this.isDefault,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude);
  }

  V1CustomerAddressesPost$RequestBody copyWithWrapped(
      {Wrapped<String?>? label,
      Wrapped<String?>? fullName,
      Wrapped<String?>? phone,
      Wrapped<String>? street,
      Wrapped<String>? city,
      Wrapped<String?>? state,
      Wrapped<String?>? postalCode,
      Wrapped<String?>? country,
      Wrapped<bool?>? isDefault,
      Wrapped<double?>? latitude,
      Wrapped<double?>? longitude}) {
    return V1CustomerAddressesPost$RequestBody(
        label: (label != null ? label.value : this.label),
        fullName: (fullName != null ? fullName.value : this.fullName),
        phone: (phone != null ? phone.value : this.phone),
        street: (street != null ? street.value : this.street),
        city: (city != null ? city.value : this.city),
        state: (state != null ? state.value : this.state),
        postalCode: (postalCode != null ? postalCode.value : this.postalCode),
        country: (country != null ? country.value : this.country),
        isDefault: (isDefault != null ? isDefault.value : this.isDefault),
        latitude: (latitude != null ? latitude.value : this.latitude),
        longitude: (longitude != null ? longitude.value : this.longitude));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerAddressesIdPut$RequestBody {
  const V1CustomerAddressesIdPut$RequestBody({
    this.label,
    this.fullName,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault,
    this.latitude,
    this.longitude,
  });

  factory V1CustomerAddressesIdPut$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1CustomerAddressesIdPut$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1CustomerAddressesIdPut$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerAddressesIdPut$RequestBodyToJson(this);

  @JsonKey(name: 'label')
  final String? label;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'street')
  final String? street;
  @JsonKey(name: 'city')
  final String? city;
  @JsonKey(name: 'state')
  final String? state;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @JsonKey(name: 'country')
  final String? country;
  @JsonKey(name: 'is_default')
  final bool? isDefault;
  @JsonKey(name: 'latitude')
  final double? latitude;
  @JsonKey(name: 'longitude')
  final double? longitude;
  static const fromJsonFactory = _$V1CustomerAddressesIdPut$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerAddressesIdPut$RequestBody &&
            (identical(other.label, label) ||
                const DeepCollectionEquality().equals(other.label, label)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality()
                    .equals(other.fullName, fullName)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.street, street) ||
                const DeepCollectionEquality().equals(other.street, street)) &&
            (identical(other.city, city) ||
                const DeepCollectionEquality().equals(other.city, city)) &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.postalCode, postalCode) ||
                const DeepCollectionEquality()
                    .equals(other.postalCode, postalCode)) &&
            (identical(other.country, country) ||
                const DeepCollectionEquality()
                    .equals(other.country, country)) &&
            (identical(other.isDefault, isDefault) ||
                const DeepCollectionEquality()
                    .equals(other.isDefault, isDefault)) &&
            (identical(other.latitude, latitude) ||
                const DeepCollectionEquality()
                    .equals(other.latitude, latitude)) &&
            (identical(other.longitude, longitude) ||
                const DeepCollectionEquality()
                    .equals(other.longitude, longitude)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(label) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(street) ^
      const DeepCollectionEquality().hash(city) ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(postalCode) ^
      const DeepCollectionEquality().hash(country) ^
      const DeepCollectionEquality().hash(isDefault) ^
      const DeepCollectionEquality().hash(latitude) ^
      const DeepCollectionEquality().hash(longitude) ^
      runtimeType.hashCode;
}

extension $V1CustomerAddressesIdPut$RequestBodyExtension
    on V1CustomerAddressesIdPut$RequestBody {
  V1CustomerAddressesIdPut$RequestBody copyWith(
      {String? label,
      String? fullName,
      String? phone,
      String? street,
      String? city,
      String? state,
      String? postalCode,
      String? country,
      bool? isDefault,
      double? latitude,
      double? longitude}) {
    return V1CustomerAddressesIdPut$RequestBody(
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        country: country ?? this.country,
        isDefault: isDefault ?? this.isDefault,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude);
  }

  V1CustomerAddressesIdPut$RequestBody copyWithWrapped(
      {Wrapped<String?>? label,
      Wrapped<String?>? fullName,
      Wrapped<String?>? phone,
      Wrapped<String?>? street,
      Wrapped<String?>? city,
      Wrapped<String?>? state,
      Wrapped<String?>? postalCode,
      Wrapped<String?>? country,
      Wrapped<bool?>? isDefault,
      Wrapped<double?>? latitude,
      Wrapped<double?>? longitude}) {
    return V1CustomerAddressesIdPut$RequestBody(
        label: (label != null ? label.value : this.label),
        fullName: (fullName != null ? fullName.value : this.fullName),
        phone: (phone != null ? phone.value : this.phone),
        street: (street != null ? street.value : this.street),
        city: (city != null ? city.value : this.city),
        state: (state != null ? state.value : this.state),
        postalCode: (postalCode != null ? postalCode.value : this.postalCode),
        country: (country != null ? country.value : this.country),
        isDefault: (isDefault != null ? isDefault.value : this.isDefault),
        latitude: (latitude != null ? latitude.value : this.latitude),
        longitude: (longitude != null ? longitude.value : this.longitude));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminLoginPost$RequestBody {
  const V1AdminLoginPost$RequestBody({
    required this.email,
    required this.password,
  });

  factory V1AdminLoginPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$V1AdminLoginPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminLoginPost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$V1AdminLoginPost$RequestBodyToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$V1AdminLoginPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminLoginPost$RequestBody &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $V1AdminLoginPost$RequestBodyExtension
    on V1AdminLoginPost$RequestBody {
  V1AdminLoginPost$RequestBody copyWith({String? email, String? password}) {
    return V1AdminLoginPost$RequestBody(
        email: email ?? this.email, password: password ?? this.password);
  }

  V1AdminLoginPost$RequestBody copyWithWrapped(
      {Wrapped<String>? email, Wrapped<String>? password}) {
    return V1AdminLoginPost$RequestBody(
        email: (email != null ? email.value : this.email),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthGoogleSigninPost$RequestBody {
  const V1AuthGoogleSigninPost$RequestBody({
    required this.email,
    required this.name,
    this.photoUrl,
    this.googleId,
  });

  factory V1AuthGoogleSigninPost$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AuthGoogleSigninPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AuthGoogleSigninPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AuthGoogleSigninPost$RequestBodyToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(name: 'google_id')
  final String? googleId;
  static const fromJsonFactory = _$V1AuthGoogleSigninPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthGoogleSigninPost$RequestBody &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.photoUrl, photoUrl) ||
                const DeepCollectionEquality()
                    .equals(other.photoUrl, photoUrl)) &&
            (identical(other.googleId, googleId) ||
                const DeepCollectionEquality()
                    .equals(other.googleId, googleId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(photoUrl) ^
      const DeepCollectionEquality().hash(googleId) ^
      runtimeType.hashCode;
}

extension $V1AuthGoogleSigninPost$RequestBodyExtension
    on V1AuthGoogleSigninPost$RequestBody {
  V1AuthGoogleSigninPost$RequestBody copyWith(
      {String? email, String? name, String? photoUrl, String? googleId}) {
    return V1AuthGoogleSigninPost$RequestBody(
        email: email ?? this.email,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        googleId: googleId ?? this.googleId);
  }

  V1AuthGoogleSigninPost$RequestBody copyWithWrapped(
      {Wrapped<String>? email,
      Wrapped<String>? name,
      Wrapped<String?>? photoUrl,
      Wrapped<String?>? googleId}) {
    return V1AuthGoogleSigninPost$RequestBody(
        email: (email != null ? email.value : this.email),
        name: (name != null ? name.value : this.name),
        photoUrl: (photoUrl != null ? photoUrl.value : this.photoUrl),
        googleId: (googleId != null ? googleId.value : this.googleId));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthLoginPost$RequestBody {
  const V1AuthLoginPost$RequestBody({
    required this.email,
    required this.password,
  });

  factory V1AuthLoginPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$V1AuthLoginPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AuthLoginPost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$V1AuthLoginPost$RequestBodyToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$V1AuthLoginPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthLoginPost$RequestBody &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $V1AuthLoginPost$RequestBodyExtension on V1AuthLoginPost$RequestBody {
  V1AuthLoginPost$RequestBody copyWith({String? email, String? password}) {
    return V1AuthLoginPost$RequestBody(
        email: email ?? this.email, password: password ?? this.password);
  }

  V1AuthLoginPost$RequestBody copyWithWrapped(
      {Wrapped<String>? email, Wrapped<String>? password}) {
    return V1AuthLoginPost$RequestBody(
        email: (email != null ? email.value : this.email),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthRegisterPost$RequestBody {
  const V1AuthRegisterPost$RequestBody({
    required this.name,
    required this.email,
    required this.password,
  });

  factory V1AuthRegisterPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$V1AuthRegisterPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AuthRegisterPost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$V1AuthRegisterPost$RequestBodyToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$V1AuthRegisterPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthRegisterPost$RequestBody &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $V1AuthRegisterPost$RequestBodyExtension
    on V1AuthRegisterPost$RequestBody {
  V1AuthRegisterPost$RequestBody copyWith(
      {String? name, String? email, String? password}) {
    return V1AuthRegisterPost$RequestBody(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  V1AuthRegisterPost$RequestBody copyWithWrapped(
      {Wrapped<String>? name,
      Wrapped<String>? email,
      Wrapped<String>? password}) {
    return V1AuthRegisterPost$RequestBody(
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthUpdateProfilePost$RequestBody {
  const V1AuthUpdateProfilePost$RequestBody({
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.preferredLanguage,
    this.notificationsEnabled,
  });

  factory V1AuthUpdateProfilePost$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AuthUpdateProfilePost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AuthUpdateProfilePost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AuthUpdateProfilePost$RequestBodyToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(
    name: 'preferred_language',
    toJson: v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableToJson,
    fromJson:
        v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableFromJson,
  )
  final enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage?
      preferredLanguage;
  @JsonKey(name: 'notifications_enabled')
  final bool? notificationsEnabled;
  static const fromJsonFactory = _$V1AuthUpdateProfilePost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthUpdateProfilePost$RequestBody &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.photoUrl, photoUrl) ||
                const DeepCollectionEquality()
                    .equals(other.photoUrl, photoUrl)) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                const DeepCollectionEquality()
                    .equals(other.preferredLanguage, preferredLanguage)) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                const DeepCollectionEquality()
                    .equals(other.notificationsEnabled, notificationsEnabled)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(photoUrl) ^
      const DeepCollectionEquality().hash(preferredLanguage) ^
      const DeepCollectionEquality().hash(notificationsEnabled) ^
      runtimeType.hashCode;
}

extension $V1AuthUpdateProfilePost$RequestBodyExtension
    on V1AuthUpdateProfilePost$RequestBody {
  V1AuthUpdateProfilePost$RequestBody copyWith(
      {String? name,
      String? email,
      String? phone,
      String? photoUrl,
      enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage?
          preferredLanguage,
      bool? notificationsEnabled}) {
    return V1AuthUpdateProfilePost$RequestBody(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        photoUrl: photoUrl ?? this.photoUrl,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        notificationsEnabled:
            notificationsEnabled ?? this.notificationsEnabled);
  }

  V1AuthUpdateProfilePost$RequestBody copyWithWrapped(
      {Wrapped<String?>? name,
      Wrapped<String?>? email,
      Wrapped<String?>? phone,
      Wrapped<String?>? photoUrl,
      Wrapped<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage?>?
          preferredLanguage,
      Wrapped<bool?>? notificationsEnabled}) {
    return V1AuthUpdateProfilePost$RequestBody(
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        phone: (phone != null ? phone.value : this.phone),
        photoUrl: (photoUrl != null ? photoUrl.value : this.photoUrl),
        preferredLanguage: (preferredLanguage != null
            ? preferredLanguage.value
            : this.preferredLanguage),
        notificationsEnabled: (notificationsEnabled != null
            ? notificationsEnabled.value
            : this.notificationsEnabled));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerCartPost$RequestBody {
  const V1CustomerCartPost$RequestBody({
    required this.productId,
    required this.quantity,
    this.flavors,
    this.size,
  });

  factory V1CustomerCartPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerCartPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1CustomerCartPost$RequestBodyToJson;
  Map<String, dynamic> toJson() => _$V1CustomerCartPost$RequestBodyToJson(this);

  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'flavors', defaultValue: <String>[])
  final List<String>? flavors;
  @JsonKey(name: 'size', defaultValue: <String>[])
  final List<String>? size;
  static const fromJsonFactory = _$V1CustomerCartPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerCartPost$RequestBody &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.flavors, flavors) ||
                const DeepCollectionEquality()
                    .equals(other.flavors, flavors)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(flavors) ^
      const DeepCollectionEquality().hash(size) ^
      runtimeType.hashCode;
}

extension $V1CustomerCartPost$RequestBodyExtension
    on V1CustomerCartPost$RequestBody {
  V1CustomerCartPost$RequestBody copyWith(
      {String? productId,
      int? quantity,
      List<String>? flavors,
      List<String>? size}) {
    return V1CustomerCartPost$RequestBody(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        flavors: flavors ?? this.flavors,
        size: size ?? this.size);
  }

  V1CustomerCartPost$RequestBody copyWithWrapped(
      {Wrapped<String>? productId,
      Wrapped<int>? quantity,
      Wrapped<List<String>?>? flavors,
      Wrapped<List<String>?>? size}) {
    return V1CustomerCartPost$RequestBody(
        productId: (productId != null ? productId.value : this.productId),
        quantity: (quantity != null ? quantity.value : this.quantity),
        flavors: (flavors != null ? flavors.value : this.flavors),
        size: (size != null ? size.value : this.size));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerCartIdPut$RequestBody {
  const V1CustomerCartIdPut$RequestBody({
    required this.quantity,
  });

  factory V1CustomerCartIdPut$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerCartIdPut$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1CustomerCartIdPut$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerCartIdPut$RequestBodyToJson(this);

  @JsonKey(name: 'quantity')
  final int quantity;
  static const fromJsonFactory = _$V1CustomerCartIdPut$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerCartIdPut$RequestBody &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(quantity) ^ runtimeType.hashCode;
}

extension $V1CustomerCartIdPut$RequestBodyExtension
    on V1CustomerCartIdPut$RequestBody {
  V1CustomerCartIdPut$RequestBody copyWith({int? quantity}) {
    return V1CustomerCartIdPut$RequestBody(quantity: quantity ?? this.quantity);
  }

  V1CustomerCartIdPut$RequestBody copyWithWrapped({Wrapped<int>? quantity}) {
    return V1CustomerCartIdPut$RequestBody(
        quantity: (quantity != null ? quantity.value : this.quantity));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesPost$RequestBody {
  const V1AdminCategoriesPost$RequestBody({
    this.name,
  });

  factory V1AdminCategoriesPost$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesPost$RequestBodyToJson(this);

  @JsonKey(name: 'name')
  final V1AdminCategoriesPost$RequestBody$Name? name;
  static const fromJsonFactory = _$V1AdminCategoriesPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesPost$RequestBody &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^ runtimeType.hashCode;
}

extension $V1AdminCategoriesPost$RequestBodyExtension
    on V1AdminCategoriesPost$RequestBody {
  V1AdminCategoriesPost$RequestBody copyWith(
      {V1AdminCategoriesPost$RequestBody$Name? name}) {
    return V1AdminCategoriesPost$RequestBody(name: name ?? this.name);
  }

  V1AdminCategoriesPost$RequestBody copyWithWrapped(
      {Wrapped<V1AdminCategoriesPost$RequestBody$Name?>? name}) {
    return V1AdminCategoriesPost$RequestBody(
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesIdPut$RequestBody {
  const V1AdminCategoriesIdPut$RequestBody({
    this.description,
    this.imageUrl,
    this.sortOrder,
    this.isActive,
    this.icon,
    this.parentId,
    this.name,
  });

  factory V1AdminCategoriesIdPut$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesIdPut$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesIdPut$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesIdPut$RequestBodyToJson(this);

  @JsonKey(name: 'description', defaultValue: <String>[])
  final List<String>? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'sort_order')
  final int? sortOrder;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'icon')
  final String? icon;
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @JsonKey(name: 'name')
  final V1AdminCategoriesIdPut$RequestBody$Name? name;
  static const fromJsonFactory = _$V1AdminCategoriesIdPut$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesIdPut$RequestBody &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.sortOrder, sortOrder) ||
                const DeepCollectionEquality()
                    .equals(other.sortOrder, sortOrder)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.parentId, parentId) ||
                const DeepCollectionEquality()
                    .equals(other.parentId, parentId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(sortOrder) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(parentId) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesIdPut$RequestBodyExtension
    on V1AdminCategoriesIdPut$RequestBody {
  V1AdminCategoriesIdPut$RequestBody copyWith(
      {List<String>? description,
      String? imageUrl,
      int? sortOrder,
      bool? isActive,
      String? icon,
      String? parentId,
      V1AdminCategoriesIdPut$RequestBody$Name? name}) {
    return V1AdminCategoriesIdPut$RequestBody(
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        icon: icon ?? this.icon,
        parentId: parentId ?? this.parentId,
        name: name ?? this.name);
  }

  V1AdminCategoriesIdPut$RequestBody copyWithWrapped(
      {Wrapped<List<String>?>? description,
      Wrapped<String?>? imageUrl,
      Wrapped<int?>? sortOrder,
      Wrapped<bool?>? isActive,
      Wrapped<String?>? icon,
      Wrapped<String?>? parentId,
      Wrapped<V1AdminCategoriesIdPut$RequestBody$Name?>? name}) {
    return V1AdminCategoriesIdPut$RequestBody(
        description:
            (description != null ? description.value : this.description),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        sortOrder: (sortOrder != null ? sortOrder.value : this.sortOrder),
        isActive: (isActive != null ? isActive.value : this.isActive),
        icon: (icon != null ? icon.value : this.icon),
        parentId: (parentId != null ? parentId.value : this.parentId),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadDeletePost$RequestBody {
  const V1AdminUploadDeletePost$RequestBody({
    required this.path,
  });

  factory V1AdminUploadDeletePost$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadDeletePost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminUploadDeletePost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadDeletePost$RequestBodyToJson(this);

  @JsonKey(name: 'path')
  final String path;
  static const fromJsonFactory = _$V1AdminUploadDeletePost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadDeletePost$RequestBody &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(path) ^ runtimeType.hashCode;
}

extension $V1AdminUploadDeletePost$RequestBodyExtension
    on V1AdminUploadDeletePost$RequestBody {
  V1AdminUploadDeletePost$RequestBody copyWith({String? path}) {
    return V1AdminUploadDeletePost$RequestBody(path: path ?? this.path);
  }

  V1AdminUploadDeletePost$RequestBody copyWithWrapped({Wrapped<String>? path}) {
    return V1AdminUploadDeletePost$RequestBody(
        path: (path != null ? path.value : this.path));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdPatch$RequestBody {
  const V1AdminOrdersIdPatch$RequestBody({
    required this.status,
    this.paymentStatus,
    this.trackingNumber,
  });

  factory V1AdminOrdersIdPatch$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdPatch$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdPatch$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdPatch$RequestBodyToJson(this);

  @JsonKey(
    name: 'status',
    toJson: v1AdminOrdersIdPatch$RequestBodyStatusToJson,
    fromJson: v1AdminOrdersIdPatch$RequestBodyStatusFromJson,
  )
  final enums.V1AdminOrdersIdPatch$RequestBodyStatus status;
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  static const fromJsonFactory = _$V1AdminOrdersIdPatch$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdPatch$RequestBody &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.paymentStatus, paymentStatus) ||
                const DeepCollectionEquality()
                    .equals(other.paymentStatus, paymentStatus)) &&
            (identical(other.trackingNumber, trackingNumber) ||
                const DeepCollectionEquality()
                    .equals(other.trackingNumber, trackingNumber)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(paymentStatus) ^
      const DeepCollectionEquality().hash(trackingNumber) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdPatch$RequestBodyExtension
    on V1AdminOrdersIdPatch$RequestBody {
  V1AdminOrdersIdPatch$RequestBody copyWith(
      {enums.V1AdminOrdersIdPatch$RequestBodyStatus? status,
      String? paymentStatus,
      String? trackingNumber}) {
    return V1AdminOrdersIdPatch$RequestBody(
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        trackingNumber: trackingNumber ?? this.trackingNumber);
  }

  V1AdminOrdersIdPatch$RequestBody copyWithWrapped(
      {Wrapped<enums.V1AdminOrdersIdPatch$RequestBodyStatus>? status,
      Wrapped<String?>? paymentStatus,
      Wrapped<String?>? trackingNumber}) {
    return V1AdminOrdersIdPatch$RequestBody(
        status: (status != null ? status.value : this.status),
        paymentStatus:
            (paymentStatus != null ? paymentStatus.value : this.paymentStatus),
        trackingNumber: (trackingNumber != null
            ? trackingNumber.value
            : this.trackingNumber));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerOrdersPost$RequestBody {
  const V1CustomerOrdersPost$RequestBody({
    this.paymentMethod,
    required this.addressId,
    this.notes,
    required this.items,
  });

  factory V1CustomerOrdersPost$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1CustomerOrdersPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1CustomerOrdersPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerOrdersPost$RequestBodyToJson(this);

  @JsonKey(
    name: 'payment_method',
    toJson: v1CustomerOrdersPost$RequestBodyPaymentMethodNullableToJson,
    fromJson: v1CustomerOrdersPost$RequestBodyPaymentMethodNullableFromJson,
  )
  final enums.V1CustomerOrdersPost$RequestBodyPaymentMethod? paymentMethod;
  @JsonKey(name: 'address_id')
  final int addressId;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'items')
  final List<V1CustomerOrdersPost$RequestBody$Items$Item> items;
  static const fromJsonFactory = _$V1CustomerOrdersPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerOrdersPost$RequestBody &&
            (identical(other.paymentMethod, paymentMethod) ||
                const DeepCollectionEquality()
                    .equals(other.paymentMethod, paymentMethod)) &&
            (identical(other.addressId, addressId) ||
                const DeepCollectionEquality()
                    .equals(other.addressId, addressId)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)) &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(paymentMethod) ^
      const DeepCollectionEquality().hash(addressId) ^
      const DeepCollectionEquality().hash(notes) ^
      const DeepCollectionEquality().hash(items) ^
      runtimeType.hashCode;
}

extension $V1CustomerOrdersPost$RequestBodyExtension
    on V1CustomerOrdersPost$RequestBody {
  V1CustomerOrdersPost$RequestBody copyWith(
      {enums.V1CustomerOrdersPost$RequestBodyPaymentMethod? paymentMethod,
      int? addressId,
      String? notes,
      List<V1CustomerOrdersPost$RequestBody$Items$Item>? items}) {
    return V1CustomerOrdersPost$RequestBody(
        paymentMethod: paymentMethod ?? this.paymentMethod,
        addressId: addressId ?? this.addressId,
        notes: notes ?? this.notes,
        items: items ?? this.items);
  }

  V1CustomerOrdersPost$RequestBody copyWithWrapped(
      {Wrapped<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod?>?
          paymentMethod,
      Wrapped<int>? addressId,
      Wrapped<String?>? notes,
      Wrapped<List<V1CustomerOrdersPost$RequestBody$Items$Item>>? items}) {
    return V1CustomerOrdersPost$RequestBody(
        paymentMethod:
            (paymentMethod != null ? paymentMethod.value : this.paymentMethod),
        addressId: (addressId != null ? addressId.value : this.addressId),
        notes: (notes != null ? notes.value : this.notes),
        items: (items != null ? items.value : this.items));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$RequestBody {
  const V1AdminProductsPost$RequestBody({
    required this.id,
    required this.price,
    this.discountPrice,
    this.imageUrls,
    required this.categoryId,
    this.stockQuantity,
    this.brand,
    this.isActive,
    this.isBackgroundWhite,
    this.servingSize,
    this.servingsPerContainer,
    this.flavors,
    this.size,
    required this.name,
    required this.description,
    this.productSizes,
    this.productVariants,
    this.variants,
  });

  factory V1AdminProductsPost$RequestBody.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProductsPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminProductsPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsPost$RequestBodyToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'image_urls', defaultValue: <String>[])
  final List<String>? imageUrls;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @JsonKey(name: 'brand')
  final String? brand;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'is_background_white')
  final bool? isBackgroundWhite;
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @JsonKey(name: 'servings_per_container')
  final int? servingsPerContainer;
  @JsonKey(name: 'flavors', defaultValue: <String>[])
  final List<String>? flavors;
  @JsonKey(name: 'size', defaultValue: <String>[])
  final List<String>? size;
  @JsonKey(name: 'name')
  final V1AdminProductsPost$RequestBody$Name name;
  @JsonKey(name: 'description')
  final V1AdminProductsPost$RequestBody$Description description;
  @JsonKey(name: 'product_sizes')
  final List<V1AdminProductsPost$RequestBody$ProductSizes$Item>? productSizes;
  @JsonKey(name: 'product_variants')
  final List<V1AdminProductsPost$RequestBody$ProductVariants$Item>?
      productVariants;
  @JsonKey(name: 'variants')
  final List<V1AdminProductsPost$RequestBody$Variants$Item>? variants;
  static const fromJsonFactory = _$V1AdminProductsPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$RequestBody &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.imageUrls, imageUrls) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrls, imageUrls)) &&
            (identical(other.categoryId, categoryId) ||
                const DeepCollectionEquality()
                    .equals(other.categoryId, categoryId)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.brand, brand) ||
                const DeepCollectionEquality().equals(other.brand, brand)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.isBackgroundWhite, isBackgroundWhite) ||
                const DeepCollectionEquality()
                    .equals(other.isBackgroundWhite, isBackgroundWhite)) &&
            (identical(other.servingSize, servingSize) ||
                const DeepCollectionEquality()
                    .equals(other.servingSize, servingSize)) &&
            (identical(other.servingsPerContainer, servingsPerContainer) ||
                const DeepCollectionEquality().equals(
                    other.servingsPerContainer, servingsPerContainer)) &&
            (identical(other.flavors, flavors) ||
                const DeepCollectionEquality()
                    .equals(other.flavors, flavors)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.productSizes, productSizes) ||
                const DeepCollectionEquality()
                    .equals(other.productSizes, productSizes)) &&
            (identical(other.productVariants, productVariants) ||
                const DeepCollectionEquality()
                    .equals(other.productVariants, productVariants)) &&
            (identical(other.variants, variants) ||
                const DeepCollectionEquality()
                    .equals(other.variants, variants)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(imageUrls) ^
      const DeepCollectionEquality().hash(categoryId) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(brand) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isBackgroundWhite) ^
      const DeepCollectionEquality().hash(servingSize) ^
      const DeepCollectionEquality().hash(servingsPerContainer) ^
      const DeepCollectionEquality().hash(flavors) ^
      const DeepCollectionEquality().hash(size) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(productSizes) ^
      const DeepCollectionEquality().hash(productVariants) ^
      const DeepCollectionEquality().hash(variants) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$RequestBodyExtension
    on V1AdminProductsPost$RequestBody {
  V1AdminProductsPost$RequestBody copyWith(
      {String? id,
      double? price,
      double? discountPrice,
      List<String>? imageUrls,
      String? categoryId,
      int? stockQuantity,
      String? brand,
      bool? isActive,
      bool? isBackgroundWhite,
      String? servingSize,
      int? servingsPerContainer,
      List<String>? flavors,
      List<String>? size,
      V1AdminProductsPost$RequestBody$Name? name,
      V1AdminProductsPost$RequestBody$Description? description,
      List<V1AdminProductsPost$RequestBody$ProductSizes$Item>? productSizes,
      List<V1AdminProductsPost$RequestBody$ProductVariants$Item>?
          productVariants,
      List<V1AdminProductsPost$RequestBody$Variants$Item>? variants}) {
    return V1AdminProductsPost$RequestBody(
        id: id ?? this.id,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        imageUrls: imageUrls ?? this.imageUrls,
        categoryId: categoryId ?? this.categoryId,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        brand: brand ?? this.brand,
        isActive: isActive ?? this.isActive,
        isBackgroundWhite: isBackgroundWhite ?? this.isBackgroundWhite,
        servingSize: servingSize ?? this.servingSize,
        servingsPerContainer: servingsPerContainer ?? this.servingsPerContainer,
        flavors: flavors ?? this.flavors,
        size: size ?? this.size,
        name: name ?? this.name,
        description: description ?? this.description,
        productSizes: productSizes ?? this.productSizes,
        productVariants: productVariants ?? this.productVariants,
        variants: variants ?? this.variants);
  }

  V1AdminProductsPost$RequestBody copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<double>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<List<String>?>? imageUrls,
      Wrapped<String>? categoryId,
      Wrapped<int?>? stockQuantity,
      Wrapped<String?>? brand,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isBackgroundWhite,
      Wrapped<String?>? servingSize,
      Wrapped<int?>? servingsPerContainer,
      Wrapped<List<String>?>? flavors,
      Wrapped<List<String>?>? size,
      Wrapped<V1AdminProductsPost$RequestBody$Name>? name,
      Wrapped<V1AdminProductsPost$RequestBody$Description>? description,
      Wrapped<List<V1AdminProductsPost$RequestBody$ProductSizes$Item>?>?
          productSizes,
      Wrapped<List<V1AdminProductsPost$RequestBody$ProductVariants$Item>?>?
          productVariants,
      Wrapped<List<V1AdminProductsPost$RequestBody$Variants$Item>?>?
          variants}) {
    return V1AdminProductsPost$RequestBody(
        id: (id != null ? id.value : this.id),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        imageUrls: (imageUrls != null ? imageUrls.value : this.imageUrls),
        categoryId: (categoryId != null ? categoryId.value : this.categoryId),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        brand: (brand != null ? brand.value : this.brand),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isBackgroundWhite: (isBackgroundWhite != null
            ? isBackgroundWhite.value
            : this.isBackgroundWhite),
        servingSize:
            (servingSize != null ? servingSize.value : this.servingSize),
        servingsPerContainer: (servingsPerContainer != null
            ? servingsPerContainer.value
            : this.servingsPerContainer),
        flavors: (flavors != null ? flavors.value : this.flavors),
        size: (size != null ? size.value : this.size),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        productSizes:
            (productSizes != null ? productSizes.value : this.productSizes),
        productVariants: (productVariants != null
            ? productVariants.value
            : this.productVariants),
        variants: (variants != null ? variants.value : this.variants));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsIdPut$RequestBody {
  const V1AdminProductsIdPut$RequestBody({
    this.name,
    this.description,
    this.price,
    this.discountPrice,
    this.imageUrls,
    this.categoryId,
    this.stockQuantity,
    this.brand,
    this.isActive,
    this.isBackgroundWhite,
    this.servingSize,
    this.servingsPerContainer,
    this.flavors,
    this.productSizes,
    this.size,
    this.productVariants,
    this.variants,
  });

  factory V1AdminProductsIdPut$RequestBody.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsIdPut$RequestBodyFromJson(json);

  static const toJsonFactory = _$V1AdminProductsIdPut$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsIdPut$RequestBodyToJson(this);

  @JsonKey(name: 'name', defaultValue: <String>[])
  final List<String>? name;
  @JsonKey(name: 'description', defaultValue: <String>[])
  final List<String>? description;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'image_urls', defaultValue: <String>[])
  final List<String>? imageUrls;
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @JsonKey(name: 'brand')
  final String? brand;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'is_background_white')
  final bool? isBackgroundWhite;
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @JsonKey(name: 'servings_per_container')
  final int? servingsPerContainer;
  @JsonKey(name: 'flavors', defaultValue: <String>[])
  final List<String>? flavors;
  @JsonKey(name: 'product_sizes', defaultValue: <String>[])
  final List<String>? productSizes;
  @JsonKey(name: 'size', defaultValue: <String>[])
  final List<String>? size;
  @JsonKey(name: 'product_variants')
  final List<V1AdminProductsIdPut$RequestBody$ProductVariants$Item>?
      productVariants;
  @JsonKey(name: 'variants')
  final List<V1AdminProductsIdPut$RequestBody$Variants$Item>? variants;
  static const fromJsonFactory = _$V1AdminProductsIdPut$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsIdPut$RequestBody &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.imageUrls, imageUrls) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrls, imageUrls)) &&
            (identical(other.categoryId, categoryId) ||
                const DeepCollectionEquality()
                    .equals(other.categoryId, categoryId)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.brand, brand) ||
                const DeepCollectionEquality().equals(other.brand, brand)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.isBackgroundWhite, isBackgroundWhite) ||
                const DeepCollectionEquality()
                    .equals(other.isBackgroundWhite, isBackgroundWhite)) &&
            (identical(other.servingSize, servingSize) ||
                const DeepCollectionEquality()
                    .equals(other.servingSize, servingSize)) &&
            (identical(other.servingsPerContainer, servingsPerContainer) ||
                const DeepCollectionEquality().equals(
                    other.servingsPerContainer, servingsPerContainer)) &&
            (identical(other.flavors, flavors) ||
                const DeepCollectionEquality()
                    .equals(other.flavors, flavors)) &&
            (identical(other.productSizes, productSizes) ||
                const DeepCollectionEquality()
                    .equals(other.productSizes, productSizes)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)) &&
            (identical(other.productVariants, productVariants) ||
                const DeepCollectionEquality()
                    .equals(other.productVariants, productVariants)) &&
            (identical(other.variants, variants) ||
                const DeepCollectionEquality()
                    .equals(other.variants, variants)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(imageUrls) ^
      const DeepCollectionEquality().hash(categoryId) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(brand) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(isBackgroundWhite) ^
      const DeepCollectionEquality().hash(servingSize) ^
      const DeepCollectionEquality().hash(servingsPerContainer) ^
      const DeepCollectionEquality().hash(flavors) ^
      const DeepCollectionEquality().hash(productSizes) ^
      const DeepCollectionEquality().hash(size) ^
      const DeepCollectionEquality().hash(productVariants) ^
      const DeepCollectionEquality().hash(variants) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsIdPut$RequestBodyExtension
    on V1AdminProductsIdPut$RequestBody {
  V1AdminProductsIdPut$RequestBody copyWith(
      {List<String>? name,
      List<String>? description,
      double? price,
      double? discountPrice,
      List<String>? imageUrls,
      String? categoryId,
      int? stockQuantity,
      String? brand,
      bool? isActive,
      bool? isBackgroundWhite,
      String? servingSize,
      int? servingsPerContainer,
      List<String>? flavors,
      List<String>? productSizes,
      List<String>? size,
      List<V1AdminProductsIdPut$RequestBody$ProductVariants$Item>?
          productVariants,
      List<V1AdminProductsIdPut$RequestBody$Variants$Item>? variants}) {
    return V1AdminProductsIdPut$RequestBody(
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        imageUrls: imageUrls ?? this.imageUrls,
        categoryId: categoryId ?? this.categoryId,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        brand: brand ?? this.brand,
        isActive: isActive ?? this.isActive,
        isBackgroundWhite: isBackgroundWhite ?? this.isBackgroundWhite,
        servingSize: servingSize ?? this.servingSize,
        servingsPerContainer: servingsPerContainer ?? this.servingsPerContainer,
        flavors: flavors ?? this.flavors,
        productSizes: productSizes ?? this.productSizes,
        size: size ?? this.size,
        productVariants: productVariants ?? this.productVariants,
        variants: variants ?? this.variants);
  }

  V1AdminProductsIdPut$RequestBody copyWithWrapped(
      {Wrapped<List<String>?>? name,
      Wrapped<List<String>?>? description,
      Wrapped<double?>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<List<String>?>? imageUrls,
      Wrapped<String?>? categoryId,
      Wrapped<int?>? stockQuantity,
      Wrapped<String?>? brand,
      Wrapped<bool?>? isActive,
      Wrapped<bool?>? isBackgroundWhite,
      Wrapped<String?>? servingSize,
      Wrapped<int?>? servingsPerContainer,
      Wrapped<List<String>?>? flavors,
      Wrapped<List<String>?>? productSizes,
      Wrapped<List<String>?>? size,
      Wrapped<List<V1AdminProductsIdPut$RequestBody$ProductVariants$Item>?>?
          productVariants,
      Wrapped<List<V1AdminProductsIdPut$RequestBody$Variants$Item>?>?
          variants}) {
    return V1AdminProductsIdPut$RequestBody(
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        imageUrls: (imageUrls != null ? imageUrls.value : this.imageUrls),
        categoryId: (categoryId != null ? categoryId.value : this.categoryId),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        brand: (brand != null ? brand.value : this.brand),
        isActive: (isActive != null ? isActive.value : this.isActive),
        isBackgroundWhite: (isBackgroundWhite != null
            ? isBackgroundWhite.value
            : this.isBackgroundWhite),
        servingSize:
            (servingSize != null ? servingSize.value : this.servingSize),
        servingsPerContainer: (servingsPerContainer != null
            ? servingsPerContainer.value
            : this.servingsPerContainer),
        flavors: (flavors != null ? flavors.value : this.flavors),
        productSizes:
            (productSizes != null ? productSizes.value : this.productSizes),
        size: (size != null ? size.value : this.size),
        productVariants: (productVariants != null
            ? productVariants.value
            : this.productVariants),
        variants: (variants != null ? variants.value : this.variants));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerAddressesGet$Response {
  const V1CustomerAddressesGet$Response({
    required this.status,
    required this.addresses,
  });

  factory V1CustomerAddressesGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerAddressesGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerAddressesGet$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerAddressesGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'addresses', defaultValue: <AddressResource>[])
  final List<AddressResource> addresses;
  static const fromJsonFactory = _$V1CustomerAddressesGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerAddressesGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.addresses, addresses) ||
                const DeepCollectionEquality()
                    .equals(other.addresses, addresses)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(addresses) ^
      runtimeType.hashCode;
}

extension $V1CustomerAddressesGet$ResponseExtension
    on V1CustomerAddressesGet$Response {
  V1CustomerAddressesGet$Response copyWith(
      {String? status, List<AddressResource>? addresses}) {
    return V1CustomerAddressesGet$Response(
        status: status ?? this.status, addresses: addresses ?? this.addresses);
  }

  V1CustomerAddressesGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<List<AddressResource>>? addresses}) {
    return V1CustomerAddressesGet$Response(
        status: (status != null ? status.value : this.status),
        addresses: (addresses != null ? addresses.value : this.addresses));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerAddressesIdGet$Response {
  const V1CustomerAddressesIdGet$Response({
    required this.status,
    required this.address,
  });

  factory V1CustomerAddressesIdGet$Response.fromJson(
          Map<String, dynamic> json) =>
      _$V1CustomerAddressesIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerAddressesIdGet$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerAddressesIdGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'address')
  final AddressResource address;
  static const fromJsonFactory = _$V1CustomerAddressesIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerAddressesIdGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality().equals(other.address, address)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(address) ^
      runtimeType.hashCode;
}

extension $V1CustomerAddressesIdGet$ResponseExtension
    on V1CustomerAddressesIdGet$Response {
  V1CustomerAddressesIdGet$Response copyWith(
      {String? status, AddressResource? address}) {
    return V1CustomerAddressesIdGet$Response(
        status: status ?? this.status, address: address ?? this.address);
  }

  V1CustomerAddressesIdGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<AddressResource>? address}) {
    return V1CustomerAddressesIdGet$Response(
        status: (status != null ? status.value : this.status),
        address: (address != null ? address.value : this.address));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProfileGet$Response {
  const V1AdminProfileGet$Response({
    required this.status,
    required this.user,
  });

  factory V1AdminProfileGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProfileGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminProfileGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminProfileGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'user')
  final V1AdminProfileGet$Response$User user;
  static const fromJsonFactory = _$V1AdminProfileGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProfileGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AdminProfileGet$ResponseExtension on V1AdminProfileGet$Response {
  V1AdminProfileGet$Response copyWith(
      {String? status, V1AdminProfileGet$Response$User? user}) {
    return V1AdminProfileGet$Response(
        status: status ?? this.status, user: user ?? this.user);
  }

  V1AdminProfileGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminProfileGet$Response$User>? user}) {
    return V1AdminProfileGet$Response(
        status: (status != null ? status.value : this.status),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminLogoutPost$Response {
  const V1AdminLogoutPost$Response({
    required this.status,
    required this.message,
  });

  factory V1AdminLogoutPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminLogoutPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminLogoutPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminLogoutPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$V1AdminLogoutPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminLogoutPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $V1AdminLogoutPost$ResponseExtension on V1AdminLogoutPost$Response {
  V1AdminLogoutPost$Response copyWith({String? status, String? message}) {
    return V1AdminLogoutPost$Response(
        status: status ?? this.status, message: message ?? this.message);
  }

  V1AdminLogoutPost$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<String>? message}) {
    return V1AdminLogoutPost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminLoginPost$Response {
  const V1AdminLoginPost$Response({
    required this.status,
    required this.token,
    required this.user,
  });

  factory V1AdminLoginPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminLoginPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminLoginPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminLoginPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'user')
  final V1AdminLoginPost$Response$User user;
  static const fromJsonFactory = _$V1AdminLoginPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminLoginPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AdminLoginPost$ResponseExtension on V1AdminLoginPost$Response {
  V1AdminLoginPost$Response copyWith(
      {String? status, String? token, V1AdminLoginPost$Response$User? user}) {
    return V1AdminLoginPost$Response(
        status: status ?? this.status,
        token: token ?? this.token,
        user: user ?? this.user);
  }

  V1AdminLoginPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? token,
      Wrapped<V1AdminLoginPost$Response$User>? user}) {
    return V1AdminLoginPost$Response(
        status: (status != null ? status.value : this.status),
        token: (token != null ? token.value : this.token),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerProfileGet$Response {
  const V1CustomerProfileGet$Response({
    required this.status,
    required this.user,
  });

  factory V1CustomerProfileGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerProfileGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerProfileGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerProfileGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'user')
  final UserResource user;
  static const fromJsonFactory = _$V1CustomerProfileGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerProfileGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1CustomerProfileGet$ResponseExtension
    on V1CustomerProfileGet$Response {
  V1CustomerProfileGet$Response copyWith({String? status, UserResource? user}) {
    return V1CustomerProfileGet$Response(
        status: status ?? this.status, user: user ?? this.user);
  }

  V1CustomerProfileGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<UserResource>? user}) {
    return V1CustomerProfileGet$Response(
        status: (status != null ? status.value : this.status),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthGoogleSigninPost$Response {
  const V1AuthGoogleSigninPost$Response({
    required this.status,
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory V1AuthGoogleSigninPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AuthGoogleSigninPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AuthGoogleSigninPost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AuthGoogleSigninPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'user')
  final UserResource user;
  static const fromJsonFactory = _$V1AuthGoogleSigninPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthGoogleSigninPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality()
                    .equals(other.accessToken, accessToken)) &&
            (identical(other.tokenType, tokenType) ||
                const DeepCollectionEquality()
                    .equals(other.tokenType, tokenType)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(tokenType) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AuthGoogleSigninPost$ResponseExtension
    on V1AuthGoogleSigninPost$Response {
  V1AuthGoogleSigninPost$Response copyWith(
      {String? status,
      String? accessToken,
      String? tokenType,
      UserResource? user}) {
    return V1AuthGoogleSigninPost$Response(
        status: status ?? this.status,
        accessToken: accessToken ?? this.accessToken,
        tokenType: tokenType ?? this.tokenType,
        user: user ?? this.user);
  }

  V1AuthGoogleSigninPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? accessToken,
      Wrapped<String>? tokenType,
      Wrapped<UserResource>? user}) {
    return V1AuthGoogleSigninPost$Response(
        status: (status != null ? status.value : this.status),
        accessToken:
            (accessToken != null ? accessToken.value : this.accessToken),
        tokenType: (tokenType != null ? tokenType.value : this.tokenType),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthLoginPost$Response {
  const V1AuthLoginPost$Response({
    required this.status,
    required this.token,
    required this.user,
  });

  factory V1AuthLoginPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AuthLoginPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AuthLoginPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AuthLoginPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'user')
  final UserResource user;
  static const fromJsonFactory = _$V1AuthLoginPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthLoginPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AuthLoginPost$ResponseExtension on V1AuthLoginPost$Response {
  V1AuthLoginPost$Response copyWith(
      {String? status, String? token, UserResource? user}) {
    return V1AuthLoginPost$Response(
        status: status ?? this.status,
        token: token ?? this.token,
        user: user ?? this.user);
  }

  V1AuthLoginPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? token,
      Wrapped<UserResource>? user}) {
    return V1AuthLoginPost$Response(
        status: (status != null ? status.value : this.status),
        token: (token != null ? token.value : this.token),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthRegisterPost$Response {
  const V1AuthRegisterPost$Response({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory V1AuthRegisterPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AuthRegisterPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AuthRegisterPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AuthRegisterPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'user')
  final UserResource user;
  static const fromJsonFactory = _$V1AuthRegisterPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthRegisterPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AuthRegisterPost$ResponseExtension on V1AuthRegisterPost$Response {
  V1AuthRegisterPost$Response copyWith(
      {String? status, String? message, String? token, UserResource? user}) {
    return V1AuthRegisterPost$Response(
        status: status ?? this.status,
        message: message ?? this.message,
        token: token ?? this.token,
        user: user ?? this.user);
  }

  V1AuthRegisterPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? message,
      Wrapped<String>? token,
      Wrapped<UserResource>? user}) {
    return V1AuthRegisterPost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message),
        token: (token != null ? token.value : this.token),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthTestLoginGet$Response {
  const V1AuthTestLoginGet$Response({
    required this.status,
    required this.token,
    required this.user,
  });

  factory V1AuthTestLoginGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AuthTestLoginGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AuthTestLoginGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AuthTestLoginGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'user')
  final UserResource user;
  static const fromJsonFactory = _$V1AuthTestLoginGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthTestLoginGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AuthTestLoginGet$ResponseExtension on V1AuthTestLoginGet$Response {
  V1AuthTestLoginGet$Response copyWith(
      {String? status, String? token, UserResource? user}) {
    return V1AuthTestLoginGet$Response(
        status: status ?? this.status,
        token: token ?? this.token,
        user: user ?? this.user);
  }

  V1AuthTestLoginGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? token,
      Wrapped<UserResource>? user}) {
    return V1AuthTestLoginGet$Response(
        status: (status != null ? status.value : this.status),
        token: (token != null ? token.value : this.token),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthUpdateProfilePost$Response {
  const V1AuthUpdateProfilePost$Response({
    required this.status,
    required this.message,
    required this.user,
  });

  factory V1AuthUpdateProfilePost$Response.fromJson(
          Map<String, dynamic> json) =>
      _$V1AuthUpdateProfilePost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AuthUpdateProfilePost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AuthUpdateProfilePost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'user')
  final UserResource user;
  static const fromJsonFactory = _$V1AuthUpdateProfilePost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthUpdateProfilePost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $V1AuthUpdateProfilePost$ResponseExtension
    on V1AuthUpdateProfilePost$Response {
  V1AuthUpdateProfilePost$Response copyWith(
      {String? status, String? message, UserResource? user}) {
    return V1AuthUpdateProfilePost$Response(
        status: status ?? this.status,
        message: message ?? this.message,
        user: user ?? this.user);
  }

  V1AuthUpdateProfilePost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? message,
      Wrapped<UserResource>? user}) {
    return V1AuthUpdateProfilePost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message),
        user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AuthLogoutPost$Response {
  const V1AuthLogoutPost$Response({
    required this.status,
    required this.message,
  });

  factory V1AuthLogoutPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AuthLogoutPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AuthLogoutPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AuthLogoutPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$V1AuthLogoutPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AuthLogoutPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $V1AuthLogoutPost$ResponseExtension on V1AuthLogoutPost$Response {
  V1AuthLogoutPost$Response copyWith({String? status, String? message}) {
    return V1AuthLogoutPost$Response(
        status: status ?? this.status, message: message ?? this.message);
  }

  V1AuthLogoutPost$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<String>? message}) {
    return V1AuthLogoutPost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerCartGet$Response {
  const V1CustomerCartGet$Response({
    required this.status,
    required this.data,
    required this.grandTotal,
  });

  factory V1CustomerCartGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerCartGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerCartGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerCartGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final List<V1CustomerCartGet$Response$Data$Item> data;
  @JsonKey(name: 'grand_total')
  final String grandTotal;
  static const fromJsonFactory = _$V1CustomerCartGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerCartGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.grandTotal, grandTotal) ||
                const DeepCollectionEquality()
                    .equals(other.grandTotal, grandTotal)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(grandTotal) ^
      runtimeType.hashCode;
}

extension $V1CustomerCartGet$ResponseExtension on V1CustomerCartGet$Response {
  V1CustomerCartGet$Response copyWith(
      {String? status,
      List<V1CustomerCartGet$Response$Data$Item>? data,
      String? grandTotal}) {
    return V1CustomerCartGet$Response(
        status: status ?? this.status,
        data: data ?? this.data,
        grandTotal: grandTotal ?? this.grandTotal);
  }

  V1CustomerCartGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<List<V1CustomerCartGet$Response$Data$Item>>? data,
      Wrapped<String>? grandTotal}) {
    return V1CustomerCartGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data),
        grandTotal: (grandTotal != null ? grandTotal.value : this.grandTotal));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerCartPost$Response {
  const V1CustomerCartPost$Response({
    required this.status,
    required this.message,
    required this.data,
  });

  factory V1CustomerCartPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerCartPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerCartPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerCartPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'data')
  final String data;
  static const fromJsonFactory = _$V1CustomerCartPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerCartPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1CustomerCartPost$ResponseExtension on V1CustomerCartPost$Response {
  V1CustomerCartPost$Response copyWith(
      {String? status, String? message, String? data}) {
    return V1CustomerCartPost$Response(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data);
  }

  V1CustomerCartPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? message,
      Wrapped<String>? data}) {
    return V1CustomerCartPost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerCartIdPut$Response {
  const V1CustomerCartIdPut$Response({
    required this.status,
    required this.message,
    required this.data,
  });

  factory V1CustomerCartIdPut$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerCartIdPut$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerCartIdPut$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerCartIdPut$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'data')
  final String data;
  static const fromJsonFactory = _$V1CustomerCartIdPut$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerCartIdPut$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1CustomerCartIdPut$ResponseExtension
    on V1CustomerCartIdPut$Response {
  V1CustomerCartIdPut$Response copyWith(
      {String? status, String? message, String? data}) {
    return V1CustomerCartIdPut$Response(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data);
  }

  V1CustomerCartIdPut$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? message,
      Wrapped<String>? data}) {
    return V1CustomerCartIdPut$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesGet$Response {
  const V1AdminCategoriesGet$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminCategoriesGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminCategoriesGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminCategoriesGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final List<V1AdminCategoriesGet$Response$Data$Item> data;
  static const fromJsonFactory = _$V1AdminCategoriesGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesGet$ResponseExtension
    on V1AdminCategoriesGet$Response {
  V1AdminCategoriesGet$Response copyWith(
      {String? status, List<V1AdminCategoriesGet$Response$Data$Item>? data}) {
    return V1AdminCategoriesGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminCategoriesGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<List<V1AdminCategoriesGet$Response$Data$Item>>? data}) {
    return V1AdminCategoriesGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesPost$Response {
  const V1AdminCategoriesPost$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminCategoriesPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminCategoriesPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminCategoriesPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminCategoriesPost$Response$Data data;
  static const fromJsonFactory = _$V1AdminCategoriesPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesPost$ResponseExtension
    on V1AdminCategoriesPost$Response {
  V1AdminCategoriesPost$Response copyWith(
      {String? status, V1AdminCategoriesPost$Response$Data? data}) {
    return V1AdminCategoriesPost$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminCategoriesPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminCategoriesPost$Response$Data>? data}) {
    return V1AdminCategoriesPost$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesIdGet$Response {
  const V1AdminCategoriesIdGet$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminCategoriesIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminCategoriesIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesIdGet$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesIdGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminCategoriesIdGet$Response$Data data;
  static const fromJsonFactory = _$V1AdminCategoriesIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesIdGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesIdGet$ResponseExtension
    on V1AdminCategoriesIdGet$Response {
  V1AdminCategoriesIdGet$Response copyWith(
      {String? status, V1AdminCategoriesIdGet$Response$Data? data}) {
    return V1AdminCategoriesIdGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminCategoriesIdGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminCategoriesIdGet$Response$Data>? data}) {
    return V1AdminCategoriesIdGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesIdPut$Response {
  const V1AdminCategoriesIdPut$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminCategoriesIdPut$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminCategoriesIdPut$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesIdPut$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesIdPut$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminCategoriesIdPut$Response$Data data;
  static const fromJsonFactory = _$V1AdminCategoriesIdPut$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesIdPut$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesIdPut$ResponseExtension
    on V1AdminCategoriesIdPut$Response {
  V1AdminCategoriesIdPut$Response copyWith(
      {String? status, V1AdminCategoriesIdPut$Response$Data? data}) {
    return V1AdminCategoriesIdPut$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminCategoriesIdPut$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminCategoriesIdPut$Response$Data>? data}) {
    return V1AdminCategoriesIdPut$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1ShopCategoriesGet$Response {
  const V1ShopCategoriesGet$Response({
    required this.status,
    required this.data,
  });

  factory V1ShopCategoriesGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1ShopCategoriesGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1ShopCategoriesGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1ShopCategoriesGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data', defaultValue: <CategoryResource>[])
  final List<CategoryResource> data;
  static const fromJsonFactory = _$V1ShopCategoriesGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1ShopCategoriesGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1ShopCategoriesGet$ResponseExtension
    on V1ShopCategoriesGet$Response {
  V1ShopCategoriesGet$Response copyWith(
      {String? status, List<CategoryResource>? data}) {
    return V1ShopCategoriesGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1ShopCategoriesGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<List<CategoryResource>>? data}) {
    return V1ShopCategoriesGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1ShopCategoriesIdGet$Response {
  const V1ShopCategoriesIdGet$Response({
    required this.status,
    required this.data,
  });

  factory V1ShopCategoriesIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1ShopCategoriesIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1ShopCategoriesIdGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1ShopCategoriesIdGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final CategoryResource data;
  static const fromJsonFactory = _$V1ShopCategoriesIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1ShopCategoriesIdGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1ShopCategoriesIdGet$ResponseExtension
    on V1ShopCategoriesIdGet$Response {
  V1ShopCategoriesIdGet$Response copyWith(
      {String? status, CategoryResource? data}) {
    return V1ShopCategoriesIdGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1ShopCategoriesIdGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<CategoryResource>? data}) {
    return V1ShopCategoriesIdGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadProductImagePost$Response {
  const V1AdminUploadProductImagePost$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminUploadProductImagePost$Response.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadProductImagePost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminUploadProductImagePost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadProductImagePost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminUploadProductImagePost$Response$Data data;
  static const fromJsonFactory =
      _$V1AdminUploadProductImagePost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadProductImagePost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadProductImagePost$ResponseExtension
    on V1AdminUploadProductImagePost$Response {
  V1AdminUploadProductImagePost$Response copyWith(
      {String? status, V1AdminUploadProductImagePost$Response$Data? data}) {
    return V1AdminUploadProductImagePost$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminUploadProductImagePost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminUploadProductImagePost$Response$Data>? data}) {
    return V1AdminUploadProductImagePost$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadCategoryImagePost$Response {
  const V1AdminUploadCategoryImagePost$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminUploadCategoryImagePost$Response.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadCategoryImagePost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminUploadCategoryImagePost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadCategoryImagePost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminUploadCategoryImagePost$Response$Data data;
  static const fromJsonFactory =
      _$V1AdminUploadCategoryImagePost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadCategoryImagePost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadCategoryImagePost$ResponseExtension
    on V1AdminUploadCategoryImagePost$Response {
  V1AdminUploadCategoryImagePost$Response copyWith(
      {String? status, V1AdminUploadCategoryImagePost$Response$Data? data}) {
    return V1AdminUploadCategoryImagePost$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminUploadCategoryImagePost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminUploadCategoryImagePost$Response$Data>? data}) {
    return V1AdminUploadCategoryImagePost$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadImagePost$Response {
  const V1AdminUploadImagePost$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminUploadImagePost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminUploadImagePost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminUploadImagePost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadImagePost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminUploadImagePost$Response$Data data;
  static const fromJsonFactory = _$V1AdminUploadImagePost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadImagePost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadImagePost$ResponseExtension
    on V1AdminUploadImagePost$Response {
  V1AdminUploadImagePost$Response copyWith(
      {String? status, V1AdminUploadImagePost$Response$Data? data}) {
    return V1AdminUploadImagePost$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminUploadImagePost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminUploadImagePost$Response$Data>? data}) {
    return V1AdminUploadImagePost$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadDeletePost$Response {
  const V1AdminUploadDeletePost$Response({
    required this.status,
    required this.message,
  });

  factory V1AdminUploadDeletePost$Response.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadDeletePost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminUploadDeletePost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadDeletePost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$V1AdminUploadDeletePost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadDeletePost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadDeletePost$ResponseExtension
    on V1AdminUploadDeletePost$Response {
  V1AdminUploadDeletePost$Response copyWith({String? status, String? message}) {
    return V1AdminUploadDeletePost$Response(
        status: status ?? this.status, message: message ?? this.message);
  }

  V1AdminUploadDeletePost$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<String>? message}) {
    return V1AdminUploadDeletePost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersGet$Response {
  const V1AdminOrdersGet$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminOrdersGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminOrdersGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminOrdersGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final LengthAwarePaginator data;
  static const fromJsonFactory = _$V1AdminOrdersGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersGet$ResponseExtension on V1AdminOrdersGet$Response {
  V1AdminOrdersGet$Response copyWith(
      {String? status, LengthAwarePaginator? data}) {
    return V1AdminOrdersGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminOrdersGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<LengthAwarePaginator>? data}) {
    return V1AdminOrdersGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdGet$Response {
  const V1AdminOrdersIdGet$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminOrdersIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminOrdersIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminOrdersIdGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminOrdersIdGet$Response$Data data;
  static const fromJsonFactory = _$V1AdminOrdersIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdGet$ResponseExtension on V1AdminOrdersIdGet$Response {
  V1AdminOrdersIdGet$Response copyWith(
      {String? status, V1AdminOrdersIdGet$Response$Data? data}) {
    return V1AdminOrdersIdGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminOrdersIdGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminOrdersIdGet$Response$Data>? data}) {
    return V1AdminOrdersIdGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdPatch$Response {
  const V1AdminOrdersIdPatch$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminOrdersIdPatch$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminOrdersIdPatch$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdPatch$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminOrdersIdPatch$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final V1AdminOrdersIdPatch$Response$Data data;
  static const fromJsonFactory = _$V1AdminOrdersIdPatch$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdPatch$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdPatch$ResponseExtension
    on V1AdminOrdersIdPatch$Response {
  V1AdminOrdersIdPatch$Response copyWith(
      {String? status, V1AdminOrdersIdPatch$Response$Data? data}) {
    return V1AdminOrdersIdPatch$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminOrdersIdPatch$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<V1AdminOrdersIdPatch$Response$Data>? data}) {
    return V1AdminOrdersIdPatch$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerOrdersGet$Response {
  const V1CustomerOrdersGet$Response({
    required this.data,
    required this.status,
  });

  factory V1CustomerOrdersGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerOrdersGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerOrdersGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerOrdersGet$ResponseToJson(this);

  @JsonKey(name: 'data', defaultValue: <OrderResource>[])
  final List<OrderResource> data;
  @JsonKey(name: 'status')
  final String status;
  static const fromJsonFactory = _$V1CustomerOrdersGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerOrdersGet$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(status) ^
      runtimeType.hashCode;
}

extension $V1CustomerOrdersGet$ResponseExtension
    on V1CustomerOrdersGet$Response {
  V1CustomerOrdersGet$Response copyWith(
      {List<OrderResource>? data, String? status}) {
    return V1CustomerOrdersGet$Response(
        data: data ?? this.data, status: status ?? this.status);
  }

  V1CustomerOrdersGet$Response copyWithWrapped(
      {Wrapped<List<OrderResource>>? data, Wrapped<String>? status}) {
    return V1CustomerOrdersGet$Response(
        data: (data != null ? data.value : this.data),
        status: (status != null ? status.value : this.status));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerOrdersPost$Response {
  const V1CustomerOrdersPost$Response({
    required this.status,
    required this.message,
    required this.data,
  });

  factory V1CustomerOrdersPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerOrdersPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerOrdersPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerOrdersPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'data')
  final OrderResource data;
  static const fromJsonFactory = _$V1CustomerOrdersPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerOrdersPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1CustomerOrdersPost$ResponseExtension
    on V1CustomerOrdersPost$Response {
  V1CustomerOrdersPost$Response copyWith(
      {String? status, String? message, OrderResource? data}) {
    return V1CustomerOrdersPost$Response(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data);
  }

  V1CustomerOrdersPost$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<String>? message,
      Wrapped<OrderResource>? data}) {
    return V1CustomerOrdersPost$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerOrdersIdGet$Response {
  const V1CustomerOrdersIdGet$Response({
    required this.data,
  });

  factory V1CustomerOrdersIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1CustomerOrdersIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1CustomerOrdersIdGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1CustomerOrdersIdGet$ResponseToJson(this);

  @JsonKey(name: 'data')
  final OrderResource data;
  static const fromJsonFactory = _$V1CustomerOrdersIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerOrdersIdGet$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $V1CustomerOrdersIdGet$ResponseExtension
    on V1CustomerOrdersIdGet$Response {
  V1CustomerOrdersIdGet$Response copyWith({OrderResource? data}) {
    return V1CustomerOrdersIdGet$Response(data: data ?? this.data);
  }

  V1CustomerOrdersIdGet$Response copyWithWrapped(
      {Wrapped<OrderResource>? data}) {
    return V1CustomerOrdersIdGet$Response(
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsGet$Response {
  const V1AdminProductsGet$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminProductsGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProductsGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminProductsGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminProductsGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final dynamic data;
  static const fromJsonFactory = _$V1AdminProductsGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsGet$ResponseExtension on V1AdminProductsGet$Response {
  V1AdminProductsGet$Response copyWith({String? status, dynamic data}) {
    return V1AdminProductsGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminProductsGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<dynamic>? data}) {
    return V1AdminProductsGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$Response {
  const V1AdminProductsPost$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminProductsPost$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProductsPost$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminProductsPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminProductsPost$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final ProductResource data;
  static const fromJsonFactory = _$V1AdminProductsPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$ResponseExtension
    on V1AdminProductsPost$Response {
  V1AdminProductsPost$Response copyWith(
      {String? status, ProductResource? data}) {
    return V1AdminProductsPost$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminProductsPost$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<ProductResource>? data}) {
    return V1AdminProductsPost$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsIdGet$Response {
  const V1AdminProductsIdGet$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminProductsIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProductsIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminProductsIdGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminProductsIdGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final ProductResource data;
  static const fromJsonFactory = _$V1AdminProductsIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsIdGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsIdGet$ResponseExtension
    on V1AdminProductsIdGet$Response {
  V1AdminProductsIdGet$Response copyWith(
      {String? status, ProductResource? data}) {
    return V1AdminProductsIdGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminProductsIdGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<ProductResource>? data}) {
    return V1AdminProductsIdGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsIdPut$Response {
  const V1AdminProductsIdPut$Response({
    required this.status,
    required this.data,
  });

  factory V1AdminProductsIdPut$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProductsIdPut$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminProductsIdPut$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminProductsIdPut$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final ProductResource data;
  static const fromJsonFactory = _$V1AdminProductsIdPut$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsIdPut$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsIdPut$ResponseExtension
    on V1AdminProductsIdPut$Response {
  V1AdminProductsIdPut$Response copyWith(
      {String? status, ProductResource? data}) {
    return V1AdminProductsIdPut$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1AdminProductsIdPut$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<ProductResource>? data}) {
    return V1AdminProductsIdPut$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsIdDelete$Response {
  const V1AdminProductsIdDelete$Response({
    required this.status,
    required this.message,
  });

  factory V1AdminProductsIdDelete$Response.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsIdDelete$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminProductsIdDelete$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsIdDelete$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'message')
  final String message;
  static const fromJsonFactory = _$V1AdminProductsIdDelete$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsIdDelete$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsIdDelete$ResponseExtension
    on V1AdminProductsIdDelete$Response {
  V1AdminProductsIdDelete$Response copyWith({String? status, String? message}) {
    return V1AdminProductsIdDelete$Response(
        status: status ?? this.status, message: message ?? this.message);
  }

  V1AdminProductsIdDelete$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<String>? message}) {
    return V1AdminProductsIdDelete$Response(
        status: (status != null ? status.value : this.status),
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class V1ShopProductsGet$Response {
  const V1ShopProductsGet$Response({
    required this.status,
    required this.data,
  });

  factory V1ShopProductsGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1ShopProductsGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1ShopProductsGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1ShopProductsGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final dynamic data;
  static const fromJsonFactory = _$V1ShopProductsGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1ShopProductsGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1ShopProductsGet$ResponseExtension on V1ShopProductsGet$Response {
  V1ShopProductsGet$Response copyWith({String? status, dynamic data}) {
    return V1ShopProductsGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1ShopProductsGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<dynamic>? data}) {
    return V1ShopProductsGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1ShopProductsIdGet$Response {
  const V1ShopProductsIdGet$Response({
    required this.status,
    required this.data,
  });

  factory V1ShopProductsIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1ShopProductsIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1ShopProductsIdGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1ShopProductsIdGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'data')
  final ProductResource data;
  static const fromJsonFactory = _$V1ShopProductsIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1ShopProductsIdGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      runtimeType.hashCode;
}

extension $V1ShopProductsIdGet$ResponseExtension
    on V1ShopProductsIdGet$Response {
  V1ShopProductsIdGet$Response copyWith(
      {String? status, ProductResource? data}) {
    return V1ShopProductsIdGet$Response(
        status: status ?? this.status, data: data ?? this.data);
  }

  V1ShopProductsIdGet$Response copyWithWrapped(
      {Wrapped<String>? status, Wrapped<ProductResource>? data}) {
    return V1ShopProductsIdGet$Response(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUsersGet$Response {
  const V1AdminUsersGet$Response({
    required this.status,
    required this.totalUsers,
    required this.users,
  });

  factory V1AdminUsersGet$Response.fromJson(Map<String, dynamic> json) =>
      _$V1AdminUsersGet$ResponseFromJson(json);

  static const toJsonFactory = _$V1AdminUsersGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$V1AdminUsersGet$ResponseToJson(this);

  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'total_users')
  final int totalUsers;
  @JsonKey(name: 'users')
  final List<V1AdminUsersGet$Response$Users$Item> users;
  static const fromJsonFactory = _$V1AdminUsersGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUsersGet$Response &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.totalUsers, totalUsers) ||
                const DeepCollectionEquality()
                    .equals(other.totalUsers, totalUsers)) &&
            (identical(other.users, users) ||
                const DeepCollectionEquality().equals(other.users, users)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(totalUsers) ^
      const DeepCollectionEquality().hash(users) ^
      runtimeType.hashCode;
}

extension $V1AdminUsersGet$ResponseExtension on V1AdminUsersGet$Response {
  V1AdminUsersGet$Response copyWith(
      {String? status,
      int? totalUsers,
      List<V1AdminUsersGet$Response$Users$Item>? users}) {
    return V1AdminUsersGet$Response(
        status: status ?? this.status,
        totalUsers: totalUsers ?? this.totalUsers,
        users: users ?? this.users);
  }

  V1AdminUsersGet$Response copyWithWrapped(
      {Wrapped<String>? status,
      Wrapped<int>? totalUsers,
      Wrapped<List<V1AdminUsersGet$Response$Users$Item>>? users}) {
    return V1AdminUsersGet$Response(
        status: (status != null ? status.value : this.status),
        totalUsers: (totalUsers != null ? totalUsers.value : this.totalUsers),
        users: (users != null ? users.value : this.users));
  }
}

@JsonSerializable(explicitToJson: true)
class ProductResource$Category {
  const ProductResource$Category({
    required this.id,
    required this.name,
  });

  factory ProductResource$Category.fromJson(Map<String, dynamic> json) =>
      _$ProductResource$CategoryFromJson(json);

  static const toJsonFactory = _$ProductResource$CategoryToJson;
  Map<String, dynamic> toJson() => _$ProductResource$CategoryToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  static const fromJsonFactory = _$ProductResource$CategoryFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProductResource$Category &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $ProductResource$CategoryExtension on ProductResource$Category {
  ProductResource$Category copyWith({String? id, List<Object>? name}) {
    return ProductResource$Category(id: id ?? this.id, name: name ?? this.name);
  }

  ProductResource$Category copyWithWrapped(
      {Wrapped<String>? id, Wrapped<List<Object>>? name}) {
    return ProductResource$Category(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class ProductResource$ImageUrls$Item {
  const ProductResource$ImageUrls$Item({
    required this.thumbnail,
    required this.medium,
    required this.original,
  });

  factory ProductResource$ImageUrls$Item.fromJson(Map<String, dynamic> json) =>
      _$ProductResource$ImageUrls$ItemFromJson(json);

  static const toJsonFactory = _$ProductResource$ImageUrls$ItemToJson;
  Map<String, dynamic> toJson() => _$ProductResource$ImageUrls$ItemToJson(this);

  @JsonKey(name: 'thumbnail')
  final dynamic thumbnail;
  @JsonKey(name: 'medium')
  final dynamic medium;
  @JsonKey(name: 'original')
  final dynamic original;
  static const fromJsonFactory = _$ProductResource$ImageUrls$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ProductResource$ImageUrls$Item &&
            (identical(other.thumbnail, thumbnail) ||
                const DeepCollectionEquality()
                    .equals(other.thumbnail, thumbnail)) &&
            (identical(other.medium, medium) ||
                const DeepCollectionEquality().equals(other.medium, medium)) &&
            (identical(other.original, original) ||
                const DeepCollectionEquality()
                    .equals(other.original, original)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(thumbnail) ^
      const DeepCollectionEquality().hash(medium) ^
      const DeepCollectionEquality().hash(original) ^
      runtimeType.hashCode;
}

extension $ProductResource$ImageUrls$ItemExtension
    on ProductResource$ImageUrls$Item {
  ProductResource$ImageUrls$Item copyWith(
      {dynamic thumbnail, dynamic medium, dynamic original}) {
    return ProductResource$ImageUrls$Item(
        thumbnail: thumbnail ?? this.thumbnail,
        medium: medium ?? this.medium,
        original: original ?? this.original);
  }

  ProductResource$ImageUrls$Item copyWithWrapped(
      {Wrapped<dynamic>? thumbnail,
      Wrapped<dynamic>? medium,
      Wrapped<dynamic>? original}) {
    return ProductResource$ImageUrls$Item(
        thumbnail: (thumbnail != null ? thumbnail.value : this.thumbnail),
        medium: (medium != null ? medium.value : this.medium),
        original: (original != null ? original.value : this.original));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesPost$RequestBody$Name {
  const V1AdminCategoriesPost$RequestBody$Name({
    this.en,
    this.ar,
  });

  factory V1AdminCategoriesPost$RequestBody$Name.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesPost$RequestBody$NameFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesPost$RequestBody$NameToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesPost$RequestBody$NameToJson(this);

  @JsonKey(name: 'en')
  final String? en;
  @JsonKey(name: 'ar')
  final String? ar;
  static const fromJsonFactory =
      _$V1AdminCategoriesPost$RequestBody$NameFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesPost$RequestBody$Name &&
            (identical(other.en, en) ||
                const DeepCollectionEquality().equals(other.en, en)) &&
            (identical(other.ar, ar) ||
                const DeepCollectionEquality().equals(other.ar, ar)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(en) ^
      const DeepCollectionEquality().hash(ar) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesPost$RequestBody$NameExtension
    on V1AdminCategoriesPost$RequestBody$Name {
  V1AdminCategoriesPost$RequestBody$Name copyWith({String? en, String? ar}) {
    return V1AdminCategoriesPost$RequestBody$Name(
        en: en ?? this.en, ar: ar ?? this.ar);
  }

  V1AdminCategoriesPost$RequestBody$Name copyWithWrapped(
      {Wrapped<String?>? en, Wrapped<String?>? ar}) {
    return V1AdminCategoriesPost$RequestBody$Name(
        en: (en != null ? en.value : this.en),
        ar: (ar != null ? ar.value : this.ar));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesIdPut$RequestBody$Name {
  const V1AdminCategoriesIdPut$RequestBody$Name({
    this.ar,
    this.en,
  });

  factory V1AdminCategoriesIdPut$RequestBody$Name.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesIdPut$RequestBody$NameFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesIdPut$RequestBody$NameToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesIdPut$RequestBody$NameToJson(this);

  @JsonKey(name: 'ar')
  final String? ar;
  @JsonKey(name: 'en')
  final String? en;
  static const fromJsonFactory =
      _$V1AdminCategoriesIdPut$RequestBody$NameFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesIdPut$RequestBody$Name &&
            (identical(other.ar, ar) ||
                const DeepCollectionEquality().equals(other.ar, ar)) &&
            (identical(other.en, en) ||
                const DeepCollectionEquality().equals(other.en, en)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ar) ^
      const DeepCollectionEquality().hash(en) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesIdPut$RequestBody$NameExtension
    on V1AdminCategoriesIdPut$RequestBody$Name {
  V1AdminCategoriesIdPut$RequestBody$Name copyWith({String? ar, String? en}) {
    return V1AdminCategoriesIdPut$RequestBody$Name(
        ar: ar ?? this.ar, en: en ?? this.en);
  }

  V1AdminCategoriesIdPut$RequestBody$Name copyWithWrapped(
      {Wrapped<String?>? ar, Wrapped<String?>? en}) {
    return V1AdminCategoriesIdPut$RequestBody$Name(
        ar: (ar != null ? ar.value : this.ar),
        en: (en != null ? en.value : this.en));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerOrdersPost$RequestBody$Items$Item {
  const V1CustomerOrdersPost$RequestBody$Items$Item({
    required this.productId,
    required this.quantity,
    this.selectedFlavor,
    this.selectedSize,
    this.$selectedFlavor,
    this.$selectedSize,
  });

  factory V1CustomerOrdersPost$RequestBody$Items$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1CustomerOrdersPost$RequestBody$Items$ItemFromJson(json);

  static const toJsonFactory =
      _$V1CustomerOrdersPost$RequestBody$Items$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerOrdersPost$RequestBody$Items$ItemToJson(this);

  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'selected_flavor')
  final String? selectedFlavor;
  @JsonKey(name: 'selected_size')
  final String? selectedSize;
  @JsonKey(name: 'selectedFlavor')
  final String? $selectedFlavor;
  @JsonKey(name: 'selectedSize')
  final String? $selectedSize;
  static const fromJsonFactory =
      _$V1CustomerOrdersPost$RequestBody$Items$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerOrdersPost$RequestBody$Items$Item &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.selectedFlavor, selectedFlavor)) &&
            (identical(other.selectedSize, selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.selectedSize, selectedSize)) &&
            (identical(other.$selectedFlavor, $selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedFlavor, $selectedFlavor)) &&
            (identical(other.$selectedSize, $selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedSize, $selectedSize)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(selectedFlavor) ^
      const DeepCollectionEquality().hash(selectedSize) ^
      const DeepCollectionEquality().hash($selectedFlavor) ^
      const DeepCollectionEquality().hash($selectedSize) ^
      runtimeType.hashCode;
}

extension $V1CustomerOrdersPost$RequestBody$Items$ItemExtension
    on V1CustomerOrdersPost$RequestBody$Items$Item {
  V1CustomerOrdersPost$RequestBody$Items$Item copyWith(
      {String? productId,
      int? quantity,
      String? selectedFlavor,
      String? selectedSize,
      String? $selectedFlavor,
      String? $selectedSize}) {
    return V1CustomerOrdersPost$RequestBody$Items$Item(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        selectedFlavor: selectedFlavor ?? this.selectedFlavor,
        selectedSize: selectedSize ?? this.selectedSize,
        $selectedFlavor: $selectedFlavor ?? this.$selectedFlavor,
        $selectedSize: $selectedSize ?? this.$selectedSize);
  }

  V1CustomerOrdersPost$RequestBody$Items$Item copyWithWrapped(
      {Wrapped<String>? productId,
      Wrapped<int>? quantity,
      Wrapped<String?>? selectedFlavor,
      Wrapped<String?>? selectedSize,
      Wrapped<String?>? $selectedFlavor,
      Wrapped<String?>? $selectedSize}) {
    return V1CustomerOrdersPost$RequestBody$Items$Item(
        productId: (productId != null ? productId.value : this.productId),
        quantity: (quantity != null ? quantity.value : this.quantity),
        selectedFlavor: (selectedFlavor != null
            ? selectedFlavor.value
            : this.selectedFlavor),
        selectedSize:
            (selectedSize != null ? selectedSize.value : this.selectedSize),
        $selectedFlavor: ($selectedFlavor != null
            ? $selectedFlavor.value
            : this.$selectedFlavor),
        $selectedSize:
            ($selectedSize != null ? $selectedSize.value : this.$selectedSize));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$RequestBody$Name {
  const V1AdminProductsPost$RequestBody$Name({
    required this.ar,
    this.en,
  });

  factory V1AdminProductsPost$RequestBody$Name.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsPost$RequestBody$NameFromJson(json);

  static const toJsonFactory = _$V1AdminProductsPost$RequestBody$NameToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsPost$RequestBody$NameToJson(this);

  @JsonKey(name: 'ar')
  final String ar;
  @JsonKey(name: 'en')
  final String? en;
  static const fromJsonFactory = _$V1AdminProductsPost$RequestBody$NameFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$RequestBody$Name &&
            (identical(other.ar, ar) ||
                const DeepCollectionEquality().equals(other.ar, ar)) &&
            (identical(other.en, en) ||
                const DeepCollectionEquality().equals(other.en, en)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ar) ^
      const DeepCollectionEquality().hash(en) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$RequestBody$NameExtension
    on V1AdminProductsPost$RequestBody$Name {
  V1AdminProductsPost$RequestBody$Name copyWith({String? ar, String? en}) {
    return V1AdminProductsPost$RequestBody$Name(
        ar: ar ?? this.ar, en: en ?? this.en);
  }

  V1AdminProductsPost$RequestBody$Name copyWithWrapped(
      {Wrapped<String>? ar, Wrapped<String?>? en}) {
    return V1AdminProductsPost$RequestBody$Name(
        ar: (ar != null ? ar.value : this.ar),
        en: (en != null ? en.value : this.en));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$RequestBody$Description {
  const V1AdminProductsPost$RequestBody$Description({
    this.ar,
    this.en,
  });

  factory V1AdminProductsPost$RequestBody$Description.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsPost$RequestBody$DescriptionFromJson(json);

  static const toJsonFactory =
      _$V1AdminProductsPost$RequestBody$DescriptionToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsPost$RequestBody$DescriptionToJson(this);

  @JsonKey(name: 'ar')
  final String? ar;
  @JsonKey(name: 'en')
  final String? en;
  static const fromJsonFactory =
      _$V1AdminProductsPost$RequestBody$DescriptionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$RequestBody$Description &&
            (identical(other.ar, ar) ||
                const DeepCollectionEquality().equals(other.ar, ar)) &&
            (identical(other.en, en) ||
                const DeepCollectionEquality().equals(other.en, en)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ar) ^
      const DeepCollectionEquality().hash(en) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$RequestBody$DescriptionExtension
    on V1AdminProductsPost$RequestBody$Description {
  V1AdminProductsPost$RequestBody$Description copyWith(
      {String? ar, String? en}) {
    return V1AdminProductsPost$RequestBody$Description(
        ar: ar ?? this.ar, en: en ?? this.en);
  }

  V1AdminProductsPost$RequestBody$Description copyWithWrapped(
      {Wrapped<String?>? ar, Wrapped<String?>? en}) {
    return V1AdminProductsPost$RequestBody$Description(
        ar: (ar != null ? ar.value : this.ar),
        en: (en != null ? en.value : this.en));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$RequestBody$ProductSizes$Item {
  const V1AdminProductsPost$RequestBody$ProductSizes$Item({
    required this.size,
    required this.price,
    this.discountPrice,
  });

  factory V1AdminProductsPost$RequestBody$ProductSizes$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsPost$RequestBody$ProductSizes$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminProductsPost$RequestBody$ProductSizes$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsPost$RequestBody$ProductSizes$ItemToJson(this);

  @JsonKey(name: 'size')
  final String size;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  static const fromJsonFactory =
      _$V1AdminProductsPost$RequestBody$ProductSizes$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$RequestBody$ProductSizes$Item &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(size) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$RequestBody$ProductSizes$ItemExtension
    on V1AdminProductsPost$RequestBody$ProductSizes$Item {
  V1AdminProductsPost$RequestBody$ProductSizes$Item copyWith(
      {String? size, double? price, double? discountPrice}) {
    return V1AdminProductsPost$RequestBody$ProductSizes$Item(
        size: size ?? this.size,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice);
  }

  V1AdminProductsPost$RequestBody$ProductSizes$Item copyWithWrapped(
      {Wrapped<String>? size,
      Wrapped<double>? price,
      Wrapped<double?>? discountPrice}) {
    return V1AdminProductsPost$RequestBody$ProductSizes$Item(
        size: (size != null ? size.value : this.size),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$RequestBody$ProductVariants$Item {
  const V1AdminProductsPost$RequestBody$ProductVariants$Item({
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.stockQuantity,
    required this.attributes,
    this.isActive,
  });

  factory V1AdminProductsPost$RequestBody$ProductVariants$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsPost$RequestBody$ProductVariants$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminProductsPost$RequestBody$ProductVariants$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsPost$RequestBody$ProductVariants$ItemToJson(this);

  @JsonKey(name: 'sku')
  final String sku;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'attributes', defaultValue: <Object>[])
  final List<Object> attributes;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  static const fromJsonFactory =
      _$V1AdminProductsPost$RequestBody$ProductVariants$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$RequestBody$ProductVariants$Item &&
            (identical(other.sku, sku) ||
                const DeepCollectionEquality().equals(other.sku, sku)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(sku) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(isActive) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$RequestBody$ProductVariants$ItemExtension
    on V1AdminProductsPost$RequestBody$ProductVariants$Item {
  V1AdminProductsPost$RequestBody$ProductVariants$Item copyWith(
      {String? sku,
      double? price,
      double? discountPrice,
      int? stockQuantity,
      List<Object>? attributes,
      bool? isActive}) {
    return V1AdminProductsPost$RequestBody$ProductVariants$Item(
        sku: sku ?? this.sku,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        attributes: attributes ?? this.attributes,
        isActive: isActive ?? this.isActive);
  }

  V1AdminProductsPost$RequestBody$ProductVariants$Item copyWithWrapped(
      {Wrapped<String>? sku,
      Wrapped<double>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<int>? stockQuantity,
      Wrapped<List<Object>>? attributes,
      Wrapped<bool?>? isActive}) {
    return V1AdminProductsPost$RequestBody$ProductVariants$Item(
        sku: (sku != null ? sku.value : this.sku),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        attributes: (attributes != null ? attributes.value : this.attributes),
        isActive: (isActive != null ? isActive.value : this.isActive));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsPost$RequestBody$Variants$Item {
  const V1AdminProductsPost$RequestBody$Variants$Item({
    this.sku,
    this.price,
    this.discountPrice,
    this.stockQuantity,
    this.attributes,
  });

  factory V1AdminProductsPost$RequestBody$Variants$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsPost$RequestBody$Variants$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminProductsPost$RequestBody$Variants$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsPost$RequestBody$Variants$ItemToJson(this);

  @JsonKey(name: 'sku')
  final String? sku;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @JsonKey(name: 'attributes', defaultValue: <Object>[])
  final List<Object>? attributes;
  static const fromJsonFactory =
      _$V1AdminProductsPost$RequestBody$Variants$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsPost$RequestBody$Variants$Item &&
            (identical(other.sku, sku) ||
                const DeepCollectionEquality().equals(other.sku, sku)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(sku) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(attributes) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsPost$RequestBody$Variants$ItemExtension
    on V1AdminProductsPost$RequestBody$Variants$Item {
  V1AdminProductsPost$RequestBody$Variants$Item copyWith(
      {String? sku,
      double? price,
      double? discountPrice,
      int? stockQuantity,
      List<Object>? attributes}) {
    return V1AdminProductsPost$RequestBody$Variants$Item(
        sku: sku ?? this.sku,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        attributes: attributes ?? this.attributes);
  }

  V1AdminProductsPost$RequestBody$Variants$Item copyWithWrapped(
      {Wrapped<String?>? sku,
      Wrapped<double?>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<int?>? stockQuantity,
      Wrapped<List<Object>?>? attributes}) {
    return V1AdminProductsPost$RequestBody$Variants$Item(
        sku: (sku != null ? sku.value : this.sku),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        attributes: (attributes != null ? attributes.value : this.attributes));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsIdPut$RequestBody$ProductVariants$Item {
  const V1AdminProductsIdPut$RequestBody$ProductVariants$Item({
    this.id,
    this.sku,
    this.price,
    this.discountPrice,
    this.stockQuantity,
    this.attributes,
    this.isActive,
  });

  factory V1AdminProductsIdPut$RequestBody$ProductVariants$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsIdPut$RequestBody$ProductVariants$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminProductsIdPut$RequestBody$ProductVariants$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsIdPut$RequestBody$ProductVariants$ItemToJson(this);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'sku')
  final String? sku;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @JsonKey(name: 'attributes', defaultValue: <Object>[])
  final List<Object>? attributes;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  static const fromJsonFactory =
      _$V1AdminProductsIdPut$RequestBody$ProductVariants$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsIdPut$RequestBody$ProductVariants$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.sku, sku) ||
                const DeepCollectionEquality().equals(other.sku, sku)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(sku) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(attributes) ^
      const DeepCollectionEquality().hash(isActive) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsIdPut$RequestBody$ProductVariants$ItemExtension
    on V1AdminProductsIdPut$RequestBody$ProductVariants$Item {
  V1AdminProductsIdPut$RequestBody$ProductVariants$Item copyWith(
      {String? id,
      String? sku,
      double? price,
      double? discountPrice,
      int? stockQuantity,
      List<Object>? attributes,
      bool? isActive}) {
    return V1AdminProductsIdPut$RequestBody$ProductVariants$Item(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        attributes: attributes ?? this.attributes,
        isActive: isActive ?? this.isActive);
  }

  V1AdminProductsIdPut$RequestBody$ProductVariants$Item copyWithWrapped(
      {Wrapped<String?>? id,
      Wrapped<String?>? sku,
      Wrapped<double?>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<int?>? stockQuantity,
      Wrapped<List<Object>?>? attributes,
      Wrapped<bool?>? isActive}) {
    return V1AdminProductsIdPut$RequestBody$ProductVariants$Item(
        id: (id != null ? id.value : this.id),
        sku: (sku != null ? sku.value : this.sku),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        attributes: (attributes != null ? attributes.value : this.attributes),
        isActive: (isActive != null ? isActive.value : this.isActive));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProductsIdPut$RequestBody$Variants$Item {
  const V1AdminProductsIdPut$RequestBody$Variants$Item({
    this.id,
    this.sku,
    this.price,
    this.discountPrice,
    this.stockQuantity,
    this.attributes,
  });

  factory V1AdminProductsIdPut$RequestBody$Variants$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminProductsIdPut$RequestBody$Variants$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminProductsIdPut$RequestBody$Variants$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProductsIdPut$RequestBody$Variants$ItemToJson(this);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'sku')
  final String? sku;
  @JsonKey(name: 'price')
  final double? price;
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @JsonKey(name: 'attributes', defaultValue: <Object>[])
  final List<Object>? attributes;
  static const fromJsonFactory =
      _$V1AdminProductsIdPut$RequestBody$Variants$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProductsIdPut$RequestBody$Variants$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.sku, sku) ||
                const DeepCollectionEquality().equals(other.sku, sku)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.discountPrice, discountPrice) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrice, discountPrice)) &&
            (identical(other.stockQuantity, stockQuantity) ||
                const DeepCollectionEquality()
                    .equals(other.stockQuantity, stockQuantity)) &&
            (identical(other.attributes, attributes) ||
                const DeepCollectionEquality()
                    .equals(other.attributes, attributes)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(sku) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(discountPrice) ^
      const DeepCollectionEquality().hash(stockQuantity) ^
      const DeepCollectionEquality().hash(attributes) ^
      runtimeType.hashCode;
}

extension $V1AdminProductsIdPut$RequestBody$Variants$ItemExtension
    on V1AdminProductsIdPut$RequestBody$Variants$Item {
  V1AdminProductsIdPut$RequestBody$Variants$Item copyWith(
      {String? id,
      String? sku,
      double? price,
      double? discountPrice,
      int? stockQuantity,
      List<Object>? attributes}) {
    return V1AdminProductsIdPut$RequestBody$Variants$Item(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        attributes: attributes ?? this.attributes);
  }

  V1AdminProductsIdPut$RequestBody$Variants$Item copyWithWrapped(
      {Wrapped<String?>? id,
      Wrapped<String?>? sku,
      Wrapped<double?>? price,
      Wrapped<double?>? discountPrice,
      Wrapped<int?>? stockQuantity,
      Wrapped<List<Object>?>? attributes}) {
    return V1AdminProductsIdPut$RequestBody$Variants$Item(
        id: (id != null ? id.value : this.id),
        sku: (sku != null ? sku.value : this.sku),
        price: (price != null ? price.value : this.price),
        discountPrice:
            (discountPrice != null ? discountPrice.value : this.discountPrice),
        stockQuantity:
            (stockQuantity != null ? stockQuantity.value : this.stockQuantity),
        attributes: (attributes != null ? attributes.value : this.attributes));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminProfileGet$Response$User {
  const V1AdminProfileGet$Response$User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory V1AdminProfileGet$Response$User.fromJson(Map<String, dynamic> json) =>
      _$V1AdminProfileGet$Response$UserFromJson(json);

  static const toJsonFactory = _$V1AdminProfileGet$Response$UserToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminProfileGet$Response$UserToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'role')
  final String role;
  static const fromJsonFactory = _$V1AdminProfileGet$Response$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminProfileGet$Response$User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $V1AdminProfileGet$Response$UserExtension
    on V1AdminProfileGet$Response$User {
  V1AdminProfileGet$Response$User copyWith(
      {int? id, String? name, String? email, String? role}) {
    return V1AdminProfileGet$Response$User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role);
  }

  V1AdminProfileGet$Response$User copyWithWrapped(
      {Wrapped<int>? id,
      Wrapped<String>? name,
      Wrapped<String>? email,
      Wrapped<String>? role}) {
    return V1AdminProfileGet$Response$User(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        role: (role != null ? role.value : this.role));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminLoginPost$Response$User {
  const V1AdminLoginPost$Response$User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory V1AdminLoginPost$Response$User.fromJson(Map<String, dynamic> json) =>
      _$V1AdminLoginPost$Response$UserFromJson(json);

  static const toJsonFactory = _$V1AdminLoginPost$Response$UserToJson;
  Map<String, dynamic> toJson() => _$V1AdminLoginPost$Response$UserToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'role')
  final String role;
  static const fromJsonFactory = _$V1AdminLoginPost$Response$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminLoginPost$Response$User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $V1AdminLoginPost$Response$UserExtension
    on V1AdminLoginPost$Response$User {
  V1AdminLoginPost$Response$User copyWith(
      {String? id, String? name, String? email, String? role}) {
    return V1AdminLoginPost$Response$User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role);
  }

  V1AdminLoginPost$Response$User copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? name,
      Wrapped<String>? email,
      Wrapped<String>? role}) {
    return V1AdminLoginPost$Response$User(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        role: (role != null ? role.value : this.role));
  }
}

@JsonSerializable(explicitToJson: true)
class V1CustomerCartGet$Response$Data$Item {
  const V1CustomerCartGet$Response$Data$Item({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrls,
    required this.quantity,
    required this.flavors,
    required this.size,
    required this.addedAt,
    required this.totalPrice,
    required this.product,
  });

  factory V1CustomerCartGet$Response$Data$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1CustomerCartGet$Response$Data$ItemFromJson(json);

  static const toJsonFactory = _$V1CustomerCartGet$Response$Data$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1CustomerCartGet$Response$Data$ItemToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'image_urls')
  final String imageUrls;
  @JsonKey(name: 'quantity')
  final String quantity;
  @JsonKey(name: 'flavors')
  final String flavors;
  @JsonKey(name: 'size')
  final String size;
  @JsonKey(name: 'added_at')
  final String addedAt;
  @JsonKey(name: 'total_price')
  final String totalPrice;
  @JsonKey(name: 'product')
  final String product;
  static const fromJsonFactory = _$V1CustomerCartGet$Response$Data$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1CustomerCartGet$Response$Data$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.productName, productName) ||
                const DeepCollectionEquality()
                    .equals(other.productName, productName)) &&
            (identical(other.price, price) ||
                const DeepCollectionEquality().equals(other.price, price)) &&
            (identical(other.imageUrls, imageUrls) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrls, imageUrls)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.flavors, flavors) ||
                const DeepCollectionEquality()
                    .equals(other.flavors, flavors)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)) &&
            (identical(other.addedAt, addedAt) ||
                const DeepCollectionEquality()
                    .equals(other.addedAt, addedAt)) &&
            (identical(other.totalPrice, totalPrice) ||
                const DeepCollectionEquality()
                    .equals(other.totalPrice, totalPrice)) &&
            (identical(other.product, product) ||
                const DeepCollectionEquality().equals(other.product, product)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(productName) ^
      const DeepCollectionEquality().hash(price) ^
      const DeepCollectionEquality().hash(imageUrls) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(flavors) ^
      const DeepCollectionEquality().hash(size) ^
      const DeepCollectionEquality().hash(addedAt) ^
      const DeepCollectionEquality().hash(totalPrice) ^
      const DeepCollectionEquality().hash(product) ^
      runtimeType.hashCode;
}

extension $V1CustomerCartGet$Response$Data$ItemExtension
    on V1CustomerCartGet$Response$Data$Item {
  V1CustomerCartGet$Response$Data$Item copyWith(
      {String? id,
      String? productId,
      String? productName,
      String? price,
      String? imageUrls,
      String? quantity,
      String? flavors,
      String? size,
      String? addedAt,
      String? totalPrice,
      String? product}) {
    return V1CustomerCartGet$Response$Data$Item(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        price: price ?? this.price,
        imageUrls: imageUrls ?? this.imageUrls,
        quantity: quantity ?? this.quantity,
        flavors: flavors ?? this.flavors,
        size: size ?? this.size,
        addedAt: addedAt ?? this.addedAt,
        totalPrice: totalPrice ?? this.totalPrice,
        product: product ?? this.product);
  }

  V1CustomerCartGet$Response$Data$Item copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? productId,
      Wrapped<String>? productName,
      Wrapped<String>? price,
      Wrapped<String>? imageUrls,
      Wrapped<String>? quantity,
      Wrapped<String>? flavors,
      Wrapped<String>? size,
      Wrapped<String>? addedAt,
      Wrapped<String>? totalPrice,
      Wrapped<String>? product}) {
    return V1CustomerCartGet$Response$Data$Item(
        id: (id != null ? id.value : this.id),
        productId: (productId != null ? productId.value : this.productId),
        productName:
            (productName != null ? productName.value : this.productName),
        price: (price != null ? price.value : this.price),
        imageUrls: (imageUrls != null ? imageUrls.value : this.imageUrls),
        quantity: (quantity != null ? quantity.value : this.quantity),
        flavors: (flavors != null ? flavors.value : this.flavors),
        size: (size != null ? size.value : this.size),
        addedAt: (addedAt != null ? addedAt.value : this.addedAt),
        totalPrice: (totalPrice != null ? totalPrice.value : this.totalPrice),
        product: (product != null ? product.value : this.product));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesGet$Response$Data$Item {
  const V1AdminCategoriesGet$Response$Data$Item({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
    required this.icon,
    this.parentId,
    required this.children,
  });

  factory V1AdminCategoriesGet$Response$Data$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesGet$Response$Data$ItemFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesGet$Response$Data$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesGet$Response$Data$ItemToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  @JsonKey(name: 'description', defaultValue: <Object>[])
  final List<Object>? description;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'sortOrder')
  final int sortOrder;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'parentId')
  final String? parentId;
  @JsonKey(name: 'children', defaultValue: <Object>[])
  final List<Object> children;
  static const fromJsonFactory =
      _$V1AdminCategoriesGet$Response$Data$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesGet$Response$Data$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.sortOrder, sortOrder) ||
                const DeepCollectionEquality()
                    .equals(other.sortOrder, sortOrder)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.parentId, parentId) ||
                const DeepCollectionEquality()
                    .equals(other.parentId, parentId)) &&
            (identical(other.children, children) ||
                const DeepCollectionEquality()
                    .equals(other.children, children)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(sortOrder) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(parentId) ^
      const DeepCollectionEquality().hash(children) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesGet$Response$Data$ItemExtension
    on V1AdminCategoriesGet$Response$Data$Item {
  V1AdminCategoriesGet$Response$Data$Item copyWith(
      {String? id,
      List<Object>? name,
      List<Object>? description,
      String? imageUrl,
      int? sortOrder,
      bool? isActive,
      String? createdAt,
      String? icon,
      String? parentId,
      List<Object>? children}) {
    return V1AdminCategoriesGet$Response$Data$Item(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        icon: icon ?? this.icon,
        parentId: parentId ?? this.parentId,
        children: children ?? this.children);
  }

  V1AdminCategoriesGet$Response$Data$Item copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<Object>>? name,
      Wrapped<List<Object>?>? description,
      Wrapped<String?>? imageUrl,
      Wrapped<int>? sortOrder,
      Wrapped<bool>? isActive,
      Wrapped<String?>? createdAt,
      Wrapped<String>? icon,
      Wrapped<String?>? parentId,
      Wrapped<List<Object>>? children}) {
    return V1AdminCategoriesGet$Response$Data$Item(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        sortOrder: (sortOrder != null ? sortOrder.value : this.sortOrder),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        icon: (icon != null ? icon.value : this.icon),
        parentId: (parentId != null ? parentId.value : this.parentId),
        children: (children != null ? children.value : this.children));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesPost$Response$Data {
  const V1AdminCategoriesPost$Response$Data({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
    required this.icon,
    this.parentId,
    required this.children,
  });

  factory V1AdminCategoriesPost$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesPost$Response$DataFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesPost$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesPost$Response$DataToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  @JsonKey(name: 'description', defaultValue: <Object>[])
  final List<Object>? description;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'sortOrder')
  final int sortOrder;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'parentId')
  final String? parentId;
  @JsonKey(name: 'children', defaultValue: <List<Object?>>[])
  final List<List<Object?>> children;
  static const fromJsonFactory = _$V1AdminCategoriesPost$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesPost$Response$Data &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.sortOrder, sortOrder) ||
                const DeepCollectionEquality()
                    .equals(other.sortOrder, sortOrder)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.parentId, parentId) ||
                const DeepCollectionEquality()
                    .equals(other.parentId, parentId)) &&
            (identical(other.children, children) ||
                const DeepCollectionEquality()
                    .equals(other.children, children)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(sortOrder) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(parentId) ^
      const DeepCollectionEquality().hash(children) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesPost$Response$DataExtension
    on V1AdminCategoriesPost$Response$Data {
  V1AdminCategoriesPost$Response$Data copyWith(
      {String? id,
      List<Object>? name,
      List<Object>? description,
      String? imageUrl,
      int? sortOrder,
      bool? isActive,
      String? createdAt,
      String? icon,
      String? parentId,
      List<List<Object?>>? children}) {
    return V1AdminCategoriesPost$Response$Data(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        icon: icon ?? this.icon,
        parentId: parentId ?? this.parentId,
        children: children ?? this.children);
  }

  V1AdminCategoriesPost$Response$Data copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<Object>>? name,
      Wrapped<List<Object>?>? description,
      Wrapped<String?>? imageUrl,
      Wrapped<int>? sortOrder,
      Wrapped<bool>? isActive,
      Wrapped<String?>? createdAt,
      Wrapped<String>? icon,
      Wrapped<String?>? parentId,
      Wrapped<List<List<Object?>>>? children}) {
    return V1AdminCategoriesPost$Response$Data(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        sortOrder: (sortOrder != null ? sortOrder.value : this.sortOrder),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        icon: (icon != null ? icon.value : this.icon),
        parentId: (parentId != null ? parentId.value : this.parentId),
        children: (children != null ? children.value : this.children));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesIdGet$Response$Data {
  const V1AdminCategoriesIdGet$Response$Data({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
    required this.icon,
    this.parentId,
    required this.children,
  });

  factory V1AdminCategoriesIdGet$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesIdGet$Response$DataFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesIdGet$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesIdGet$Response$DataToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  @JsonKey(name: 'description', defaultValue: <Object>[])
  final List<Object>? description;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'sortOrder')
  final int sortOrder;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'parentId')
  final String? parentId;
  @JsonKey(name: 'children', defaultValue: <List<Object?>>[])
  final List<List<Object?>> children;
  static const fromJsonFactory = _$V1AdminCategoriesIdGet$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesIdGet$Response$Data &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.sortOrder, sortOrder) ||
                const DeepCollectionEquality()
                    .equals(other.sortOrder, sortOrder)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.parentId, parentId) ||
                const DeepCollectionEquality()
                    .equals(other.parentId, parentId)) &&
            (identical(other.children, children) ||
                const DeepCollectionEquality()
                    .equals(other.children, children)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(sortOrder) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(parentId) ^
      const DeepCollectionEquality().hash(children) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesIdGet$Response$DataExtension
    on V1AdminCategoriesIdGet$Response$Data {
  V1AdminCategoriesIdGet$Response$Data copyWith(
      {String? id,
      List<Object>? name,
      List<Object>? description,
      String? imageUrl,
      int? sortOrder,
      bool? isActive,
      String? createdAt,
      String? icon,
      String? parentId,
      List<List<Object?>>? children}) {
    return V1AdminCategoriesIdGet$Response$Data(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        icon: icon ?? this.icon,
        parentId: parentId ?? this.parentId,
        children: children ?? this.children);
  }

  V1AdminCategoriesIdGet$Response$Data copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<Object>>? name,
      Wrapped<List<Object>?>? description,
      Wrapped<String?>? imageUrl,
      Wrapped<int>? sortOrder,
      Wrapped<bool>? isActive,
      Wrapped<String?>? createdAt,
      Wrapped<String>? icon,
      Wrapped<String?>? parentId,
      Wrapped<List<List<Object?>>>? children}) {
    return V1AdminCategoriesIdGet$Response$Data(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        sortOrder: (sortOrder != null ? sortOrder.value : this.sortOrder),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        icon: (icon != null ? icon.value : this.icon),
        parentId: (parentId != null ? parentId.value : this.parentId),
        children: (children != null ? children.value : this.children));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminCategoriesIdPut$Response$Data {
  const V1AdminCategoriesIdPut$Response$Data({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.sortOrder,
    required this.isActive,
    this.createdAt,
    required this.icon,
    this.parentId,
    required this.children,
  });

  factory V1AdminCategoriesIdPut$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminCategoriesIdPut$Response$DataFromJson(json);

  static const toJsonFactory = _$V1AdminCategoriesIdPut$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminCategoriesIdPut$Response$DataToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name', defaultValue: <Object>[])
  final List<Object> name;
  @JsonKey(name: 'description', defaultValue: <Object>[])
  final List<Object>? description;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'sortOrder')
  final int sortOrder;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'parentId')
  final String? parentId;
  @JsonKey(name: 'children', defaultValue: <List<Object?>>[])
  final List<List<Object?>> children;
  static const fromJsonFactory = _$V1AdminCategoriesIdPut$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminCategoriesIdPut$Response$Data &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.sortOrder, sortOrder) ||
                const DeepCollectionEquality()
                    .equals(other.sortOrder, sortOrder)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.parentId, parentId) ||
                const DeepCollectionEquality()
                    .equals(other.parentId, parentId)) &&
            (identical(other.children, children) ||
                const DeepCollectionEquality()
                    .equals(other.children, children)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(sortOrder) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(parentId) ^
      const DeepCollectionEquality().hash(children) ^
      runtimeType.hashCode;
}

extension $V1AdminCategoriesIdPut$Response$DataExtension
    on V1AdminCategoriesIdPut$Response$Data {
  V1AdminCategoriesIdPut$Response$Data copyWith(
      {String? id,
      List<Object>? name,
      List<Object>? description,
      String? imageUrl,
      int? sortOrder,
      bool? isActive,
      String? createdAt,
      String? icon,
      String? parentId,
      List<List<Object?>>? children}) {
    return V1AdminCategoriesIdPut$Response$Data(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        icon: icon ?? this.icon,
        parentId: parentId ?? this.parentId,
        children: children ?? this.children);
  }

  V1AdminCategoriesIdPut$Response$Data copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<Object>>? name,
      Wrapped<List<Object>?>? description,
      Wrapped<String?>? imageUrl,
      Wrapped<int>? sortOrder,
      Wrapped<bool>? isActive,
      Wrapped<String?>? createdAt,
      Wrapped<String>? icon,
      Wrapped<String?>? parentId,
      Wrapped<List<List<Object?>>>? children}) {
    return V1AdminCategoriesIdPut$Response$Data(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        sortOrder: (sortOrder != null ? sortOrder.value : this.sortOrder),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        icon: (icon != null ? icon.value : this.icon),
        parentId: (parentId != null ? parentId.value : this.parentId),
        children: (children != null ? children.value : this.children));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadProductImagePost$Response$Data {
  const V1AdminUploadProductImagePost$Response$Data({
    required this.url,
    required this.path,
    required this.name,
    required this.size,
  });

  factory V1AdminUploadProductImagePost$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadProductImagePost$Response$DataFromJson(json);

  static const toJsonFactory =
      _$V1AdminUploadProductImagePost$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadProductImagePost$Response$DataToJson(this);

  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'size')
  final String size;
  static const fromJsonFactory =
      _$V1AdminUploadProductImagePost$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadProductImagePost$Response$Data &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(path) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(size) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadProductImagePost$Response$DataExtension
    on V1AdminUploadProductImagePost$Response$Data {
  V1AdminUploadProductImagePost$Response$Data copyWith(
      {String? url, String? path, String? name, String? size}) {
    return V1AdminUploadProductImagePost$Response$Data(
        url: url ?? this.url,
        path: path ?? this.path,
        name: name ?? this.name,
        size: size ?? this.size);
  }

  V1AdminUploadProductImagePost$Response$Data copyWithWrapped(
      {Wrapped<String>? url,
      Wrapped<String>? path,
      Wrapped<String>? name,
      Wrapped<String>? size}) {
    return V1AdminUploadProductImagePost$Response$Data(
        url: (url != null ? url.value : this.url),
        path: (path != null ? path.value : this.path),
        name: (name != null ? name.value : this.name),
        size: (size != null ? size.value : this.size));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadCategoryImagePost$Response$Data {
  const V1AdminUploadCategoryImagePost$Response$Data({
    required this.url,
    required this.path,
    required this.name,
    required this.size,
  });

  factory V1AdminUploadCategoryImagePost$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadCategoryImagePost$Response$DataFromJson(json);

  static const toJsonFactory =
      _$V1AdminUploadCategoryImagePost$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadCategoryImagePost$Response$DataToJson(this);

  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'size')
  final String size;
  static const fromJsonFactory =
      _$V1AdminUploadCategoryImagePost$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadCategoryImagePost$Response$Data &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(path) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(size) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadCategoryImagePost$Response$DataExtension
    on V1AdminUploadCategoryImagePost$Response$Data {
  V1AdminUploadCategoryImagePost$Response$Data copyWith(
      {String? url, String? path, String? name, String? size}) {
    return V1AdminUploadCategoryImagePost$Response$Data(
        url: url ?? this.url,
        path: path ?? this.path,
        name: name ?? this.name,
        size: size ?? this.size);
  }

  V1AdminUploadCategoryImagePost$Response$Data copyWithWrapped(
      {Wrapped<String>? url,
      Wrapped<String>? path,
      Wrapped<String>? name,
      Wrapped<String>? size}) {
    return V1AdminUploadCategoryImagePost$Response$Data(
        url: (url != null ? url.value : this.url),
        path: (path != null ? path.value : this.path),
        name: (name != null ? name.value : this.name),
        size: (size != null ? size.value : this.size));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUploadImagePost$Response$Data {
  const V1AdminUploadImagePost$Response$Data({
    required this.url,
    required this.path,
    required this.name,
    required this.size,
  });

  factory V1AdminUploadImagePost$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUploadImagePost$Response$DataFromJson(json);

  static const toJsonFactory = _$V1AdminUploadImagePost$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUploadImagePost$Response$DataToJson(this);

  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'size')
  final String size;
  static const fromJsonFactory = _$V1AdminUploadImagePost$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUploadImagePost$Response$Data &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.path, path) ||
                const DeepCollectionEquality().equals(other.path, path)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.size, size) ||
                const DeepCollectionEquality().equals(other.size, size)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(path) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(size) ^
      runtimeType.hashCode;
}

extension $V1AdminUploadImagePost$Response$DataExtension
    on V1AdminUploadImagePost$Response$Data {
  V1AdminUploadImagePost$Response$Data copyWith(
      {String? url, String? path, String? name, String? size}) {
    return V1AdminUploadImagePost$Response$Data(
        url: url ?? this.url,
        path: path ?? this.path,
        name: name ?? this.name,
        size: size ?? this.size);
  }

  V1AdminUploadImagePost$Response$Data copyWithWrapped(
      {Wrapped<String>? url,
      Wrapped<String>? path,
      Wrapped<String>? name,
      Wrapped<String>? size}) {
    return V1AdminUploadImagePost$Response$Data(
        url: (url != null ? url.value : this.url),
        path: (path != null ? path.value : this.path),
        name: (name != null ? name.value : this.name),
        size: (size != null ? size.value : this.size));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdGet$Response$Data {
  const V1AdminOrdersIdGet$Response$Data({
    required this.id,
    this.user,
    required this.orderDate,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.addressId,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.totalAmount,
    this.trackingNumber,
    this.notes,
    this.shippingAddress,
    required this.orderItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory V1AdminOrdersIdGet$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdGet$Response$DataFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdGet$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdGet$Response$DataToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'user')
  final V1AdminOrdersIdGet$Response$Data$User? user;
  @JsonKey(name: 'order_date')
  final dynamic orderDate;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'address_id')
  final String addressId;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  @JsonKey(name: 'shippingCost')
  final double shippingCost;
  @JsonKey(name: 'discount')
  final double discount;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'shipping_address', defaultValue: <Object>[])
  final List<Object>? shippingAddress;
  @JsonKey(name: 'order_items')
  final List<V1AdminOrdersIdGet$Response$Data$OrderItems$Item> orderItems;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  static const fromJsonFactory = _$V1AdminOrdersIdGet$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdGet$Response$Data &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.orderDate, orderDate) ||
                const DeepCollectionEquality()
                    .equals(other.orderDate, orderDate)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.paymentStatus, paymentStatus) ||
                const DeepCollectionEquality()
                    .equals(other.paymentStatus, paymentStatus)) &&
            (identical(other.paymentMethod, paymentMethod) ||
                const DeepCollectionEquality()
                    .equals(other.paymentMethod, paymentMethod)) &&
            (identical(other.addressId, addressId) ||
                const DeepCollectionEquality()
                    .equals(other.addressId, addressId)) &&
            (identical(other.subtotal, subtotal) ||
                const DeepCollectionEquality()
                    .equals(other.subtotal, subtotal)) &&
            (identical(other.shippingCost, shippingCost) ||
                const DeepCollectionEquality()
                    .equals(other.shippingCost, shippingCost)) &&
            (identical(other.discount, discount) ||
                const DeepCollectionEquality()
                    .equals(other.discount, discount)) &&
            (identical(other.totalAmount, totalAmount) ||
                const DeepCollectionEquality()
                    .equals(other.totalAmount, totalAmount)) &&
            (identical(other.trackingNumber, trackingNumber) ||
                const DeepCollectionEquality()
                    .equals(other.trackingNumber, trackingNumber)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)) &&
            (identical(other.shippingAddress, shippingAddress) ||
                const DeepCollectionEquality()
                    .equals(other.shippingAddress, shippingAddress)) &&
            (identical(other.orderItems, orderItems) ||
                const DeepCollectionEquality()
                    .equals(other.orderItems, orderItems)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(orderDate) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(paymentStatus) ^
      const DeepCollectionEquality().hash(paymentMethod) ^
      const DeepCollectionEquality().hash(addressId) ^
      const DeepCollectionEquality().hash(subtotal) ^
      const DeepCollectionEquality().hash(shippingCost) ^
      const DeepCollectionEquality().hash(discount) ^
      const DeepCollectionEquality().hash(totalAmount) ^
      const DeepCollectionEquality().hash(trackingNumber) ^
      const DeepCollectionEquality().hash(notes) ^
      const DeepCollectionEquality().hash(shippingAddress) ^
      const DeepCollectionEquality().hash(orderItems) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdGet$Response$DataExtension
    on V1AdminOrdersIdGet$Response$Data {
  V1AdminOrdersIdGet$Response$Data copyWith(
      {String? id,
      V1AdminOrdersIdGet$Response$Data$User? user,
      dynamic orderDate,
      String? status,
      String? paymentStatus,
      String? paymentMethod,
      String? addressId,
      double? subtotal,
      double? shippingCost,
      double? discount,
      double? totalAmount,
      String? trackingNumber,
      String? notes,
      List<Object>? shippingAddress,
      List<V1AdminOrdersIdGet$Response$Data$OrderItems$Item>? orderItems,
      String? createdAt,
      String? updatedAt}) {
    return V1AdminOrdersIdGet$Response$Data(
        id: id ?? this.id,
        user: user ?? this.user,
        orderDate: orderDate ?? this.orderDate,
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        addressId: addressId ?? this.addressId,
        subtotal: subtotal ?? this.subtotal,
        shippingCost: shippingCost ?? this.shippingCost,
        discount: discount ?? this.discount,
        totalAmount: totalAmount ?? this.totalAmount,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        notes: notes ?? this.notes,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        orderItems: orderItems ?? this.orderItems,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  V1AdminOrdersIdGet$Response$Data copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<V1AdminOrdersIdGet$Response$Data$User?>? user,
      Wrapped<dynamic>? orderDate,
      Wrapped<String>? status,
      Wrapped<String>? paymentStatus,
      Wrapped<String>? paymentMethod,
      Wrapped<String>? addressId,
      Wrapped<double>? subtotal,
      Wrapped<double>? shippingCost,
      Wrapped<double>? discount,
      Wrapped<double>? totalAmount,
      Wrapped<String?>? trackingNumber,
      Wrapped<String?>? notes,
      Wrapped<List<Object>?>? shippingAddress,
      Wrapped<List<V1AdminOrdersIdGet$Response$Data$OrderItems$Item>>?
          orderItems,
      Wrapped<String>? createdAt,
      Wrapped<String>? updatedAt}) {
    return V1AdminOrdersIdGet$Response$Data(
        id: (id != null ? id.value : this.id),
        user: (user != null ? user.value : this.user),
        orderDate: (orderDate != null ? orderDate.value : this.orderDate),
        status: (status != null ? status.value : this.status),
        paymentStatus:
            (paymentStatus != null ? paymentStatus.value : this.paymentStatus),
        paymentMethod:
            (paymentMethod != null ? paymentMethod.value : this.paymentMethod),
        addressId: (addressId != null ? addressId.value : this.addressId),
        subtotal: (subtotal != null ? subtotal.value : this.subtotal),
        shippingCost:
            (shippingCost != null ? shippingCost.value : this.shippingCost),
        discount: (discount != null ? discount.value : this.discount),
        totalAmount:
            (totalAmount != null ? totalAmount.value : this.totalAmount),
        trackingNumber: (trackingNumber != null
            ? trackingNumber.value
            : this.trackingNumber),
        notes: (notes != null ? notes.value : this.notes),
        shippingAddress: (shippingAddress != null
            ? shippingAddress.value
            : this.shippingAddress),
        orderItems: (orderItems != null ? orderItems.value : this.orderItems),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdPatch$Response$Data {
  const V1AdminOrdersIdPatch$Response$Data({
    required this.id,
    this.user,
    required this.orderDate,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.addressId,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.totalAmount,
    this.trackingNumber,
    this.notes,
    this.shippingAddress,
    required this.orderItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory V1AdminOrdersIdPatch$Response$Data.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdPatch$Response$DataFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdPatch$Response$DataToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdPatch$Response$DataToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'user')
  final V1AdminOrdersIdPatch$Response$Data$User? user;
  @JsonKey(name: 'order_date')
  final dynamic orderDate;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'address_id')
  final String addressId;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  @JsonKey(name: 'shippingCost')
  final double shippingCost;
  @JsonKey(name: 'discount')
  final double discount;
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  @JsonKey(name: 'notes')
  final String? notes;
  @JsonKey(name: 'shipping_address', defaultValue: <Object>[])
  final List<Object>? shippingAddress;
  @JsonKey(name: 'order_items')
  final List<V1AdminOrdersIdPatch$Response$Data$OrderItems$Item> orderItems;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'updatedAt')
  final String updatedAt;
  static const fromJsonFactory = _$V1AdminOrdersIdPatch$Response$DataFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdPatch$Response$Data &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
            (identical(other.orderDate, orderDate) ||
                const DeepCollectionEquality()
                    .equals(other.orderDate, orderDate)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.paymentStatus, paymentStatus) ||
                const DeepCollectionEquality()
                    .equals(other.paymentStatus, paymentStatus)) &&
            (identical(other.paymentMethod, paymentMethod) ||
                const DeepCollectionEquality()
                    .equals(other.paymentMethod, paymentMethod)) &&
            (identical(other.addressId, addressId) ||
                const DeepCollectionEquality()
                    .equals(other.addressId, addressId)) &&
            (identical(other.subtotal, subtotal) ||
                const DeepCollectionEquality()
                    .equals(other.subtotal, subtotal)) &&
            (identical(other.shippingCost, shippingCost) ||
                const DeepCollectionEquality()
                    .equals(other.shippingCost, shippingCost)) &&
            (identical(other.discount, discount) ||
                const DeepCollectionEquality()
                    .equals(other.discount, discount)) &&
            (identical(other.totalAmount, totalAmount) ||
                const DeepCollectionEquality()
                    .equals(other.totalAmount, totalAmount)) &&
            (identical(other.trackingNumber, trackingNumber) ||
                const DeepCollectionEquality()
                    .equals(other.trackingNumber, trackingNumber)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)) &&
            (identical(other.shippingAddress, shippingAddress) ||
                const DeepCollectionEquality()
                    .equals(other.shippingAddress, shippingAddress)) &&
            (identical(other.orderItems, orderItems) ||
                const DeepCollectionEquality()
                    .equals(other.orderItems, orderItems)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(orderDate) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(paymentStatus) ^
      const DeepCollectionEquality().hash(paymentMethod) ^
      const DeepCollectionEquality().hash(addressId) ^
      const DeepCollectionEquality().hash(subtotal) ^
      const DeepCollectionEquality().hash(shippingCost) ^
      const DeepCollectionEquality().hash(discount) ^
      const DeepCollectionEquality().hash(totalAmount) ^
      const DeepCollectionEquality().hash(trackingNumber) ^
      const DeepCollectionEquality().hash(notes) ^
      const DeepCollectionEquality().hash(shippingAddress) ^
      const DeepCollectionEquality().hash(orderItems) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdPatch$Response$DataExtension
    on V1AdminOrdersIdPatch$Response$Data {
  V1AdminOrdersIdPatch$Response$Data copyWith(
      {String? id,
      V1AdminOrdersIdPatch$Response$Data$User? user,
      dynamic orderDate,
      String? status,
      String? paymentStatus,
      String? paymentMethod,
      String? addressId,
      double? subtotal,
      double? shippingCost,
      double? discount,
      double? totalAmount,
      String? trackingNumber,
      String? notes,
      List<Object>? shippingAddress,
      List<V1AdminOrdersIdPatch$Response$Data$OrderItems$Item>? orderItems,
      String? createdAt,
      String? updatedAt}) {
    return V1AdminOrdersIdPatch$Response$Data(
        id: id ?? this.id,
        user: user ?? this.user,
        orderDate: orderDate ?? this.orderDate,
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        addressId: addressId ?? this.addressId,
        subtotal: subtotal ?? this.subtotal,
        shippingCost: shippingCost ?? this.shippingCost,
        discount: discount ?? this.discount,
        totalAmount: totalAmount ?? this.totalAmount,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        notes: notes ?? this.notes,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        orderItems: orderItems ?? this.orderItems,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  V1AdminOrdersIdPatch$Response$Data copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<V1AdminOrdersIdPatch$Response$Data$User?>? user,
      Wrapped<dynamic>? orderDate,
      Wrapped<String>? status,
      Wrapped<String>? paymentStatus,
      Wrapped<String>? paymentMethod,
      Wrapped<String>? addressId,
      Wrapped<double>? subtotal,
      Wrapped<double>? shippingCost,
      Wrapped<double>? discount,
      Wrapped<double>? totalAmount,
      Wrapped<String?>? trackingNumber,
      Wrapped<String?>? notes,
      Wrapped<List<Object>?>? shippingAddress,
      Wrapped<List<V1AdminOrdersIdPatch$Response$Data$OrderItems$Item>>?
          orderItems,
      Wrapped<String>? createdAt,
      Wrapped<String>? updatedAt}) {
    return V1AdminOrdersIdPatch$Response$Data(
        id: (id != null ? id.value : this.id),
        user: (user != null ? user.value : this.user),
        orderDate: (orderDate != null ? orderDate.value : this.orderDate),
        status: (status != null ? status.value : this.status),
        paymentStatus:
            (paymentStatus != null ? paymentStatus.value : this.paymentStatus),
        paymentMethod:
            (paymentMethod != null ? paymentMethod.value : this.paymentMethod),
        addressId: (addressId != null ? addressId.value : this.addressId),
        subtotal: (subtotal != null ? subtotal.value : this.subtotal),
        shippingCost:
            (shippingCost != null ? shippingCost.value : this.shippingCost),
        discount: (discount != null ? discount.value : this.discount),
        totalAmount:
            (totalAmount != null ? totalAmount.value : this.totalAmount),
        trackingNumber: (trackingNumber != null
            ? trackingNumber.value
            : this.trackingNumber),
        notes: (notes != null ? notes.value : this.notes),
        shippingAddress: (shippingAddress != null
            ? shippingAddress.value
            : this.shippingAddress),
        orderItems: (orderItems != null ? orderItems.value : this.orderItems),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminUsersGet$Response$Users$Item {
  const V1AdminUsersGet$Response$Users$Item({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.photoUrl,
    required this.totalSpent,
    required this.createdAt,
    required this.lastLogin,
    required this.addresses,
    required this.ordersCount,
  });

  factory V1AdminUsersGet$Response$Users$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminUsersGet$Response$Users$ItemFromJson(json);

  static const toJsonFactory = _$V1AdminUsersGet$Response$Users$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminUsersGet$Response$Users$ItemToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'phone')
  final String phone;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'photo_url')
  final String photoUrl;
  @JsonKey(name: 'total_spent')
  final double totalSpent;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'last_login')
  final Object lastLogin;
  @JsonKey(name: 'addresses')
  final String addresses;
  @JsonKey(name: 'orders_count')
  final int ordersCount;
  static const fromJsonFactory = _$V1AdminUsersGet$Response$Users$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminUsersGet$Response$Users$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.photoUrl, photoUrl) ||
                const DeepCollectionEquality()
                    .equals(other.photoUrl, photoUrl)) &&
            (identical(other.totalSpent, totalSpent) ||
                const DeepCollectionEquality()
                    .equals(other.totalSpent, totalSpent)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.lastLogin, lastLogin) ||
                const DeepCollectionEquality()
                    .equals(other.lastLogin, lastLogin)) &&
            (identical(other.addresses, addresses) ||
                const DeepCollectionEquality()
                    .equals(other.addresses, addresses)) &&
            (identical(other.ordersCount, ordersCount) ||
                const DeepCollectionEquality()
                    .equals(other.ordersCount, ordersCount)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(photoUrl) ^
      const DeepCollectionEquality().hash(totalSpent) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(lastLogin) ^
      const DeepCollectionEquality().hash(addresses) ^
      const DeepCollectionEquality().hash(ordersCount) ^
      runtimeType.hashCode;
}

extension $V1AdminUsersGet$Response$Users$ItemExtension
    on V1AdminUsersGet$Response$Users$Item {
  V1AdminUsersGet$Response$Users$Item copyWith(
      {String? id,
      String? name,
      String? email,
      String? phone,
      bool? isActive,
      String? photoUrl,
      double? totalSpent,
      String? createdAt,
      Object? lastLogin,
      String? addresses,
      int? ordersCount}) {
    return V1AdminUsersGet$Response$Users$Item(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        isActive: isActive ?? this.isActive,
        photoUrl: photoUrl ?? this.photoUrl,
        totalSpent: totalSpent ?? this.totalSpent,
        createdAt: createdAt ?? this.createdAt,
        lastLogin: lastLogin ?? this.lastLogin,
        addresses: addresses ?? this.addresses,
        ordersCount: ordersCount ?? this.ordersCount);
  }

  V1AdminUsersGet$Response$Users$Item copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? name,
      Wrapped<String>? email,
      Wrapped<String>? phone,
      Wrapped<bool>? isActive,
      Wrapped<String>? photoUrl,
      Wrapped<double>? totalSpent,
      Wrapped<String>? createdAt,
      Wrapped<Object>? lastLogin,
      Wrapped<String>? addresses,
      Wrapped<int>? ordersCount}) {
    return V1AdminUsersGet$Response$Users$Item(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email),
        phone: (phone != null ? phone.value : this.phone),
        isActive: (isActive != null ? isActive.value : this.isActive),
        photoUrl: (photoUrl != null ? photoUrl.value : this.photoUrl),
        totalSpent: (totalSpent != null ? totalSpent.value : this.totalSpent),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        lastLogin: (lastLogin != null ? lastLogin.value : this.lastLogin),
        addresses: (addresses != null ? addresses.value : this.addresses),
        ordersCount:
            (ordersCount != null ? ordersCount.value : this.ordersCount));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdGet$Response$Data$User {
  const V1AdminOrdersIdGet$Response$Data$User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory V1AdminOrdersIdGet$Response$Data$User.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdGet$Response$Data$UserFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdGet$Response$Data$UserToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdGet$Response$Data$UserToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  static const fromJsonFactory =
      _$V1AdminOrdersIdGet$Response$Data$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdGet$Response$Data$User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdGet$Response$Data$UserExtension
    on V1AdminOrdersIdGet$Response$Data$User {
  V1AdminOrdersIdGet$Response$Data$User copyWith(
      {int? id, String? name, String? email}) {
    return V1AdminOrdersIdGet$Response$Data$User(
        id: id ?? this.id, name: name ?? this.name, email: email ?? this.email);
  }

  V1AdminOrdersIdGet$Response$Data$User copyWithWrapped(
      {Wrapped<int>? id, Wrapped<String>? name, Wrapped<String>? email}) {
    return V1AdminOrdersIdGet$Response$Data$User(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdGet$Response$Data$OrderItems$Item {
  const V1AdminOrdersIdGet$Response$Data$OrderItems$Item({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    required this.imageUrl,
    this.selectedFlavor,
    this.selectedSize,
    this.$selectedFlavor,
    this.$selectedSize,
  });

  factory V1AdminOrdersIdGet$Response$Data$OrderItems$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdGet$Response$Data$OrderItems$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminOrdersIdGet$Response$Data$OrderItems$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdGet$Response$Data$OrderItems$ItemToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final dynamic productName;
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'selectedFlavor')
  final String? selectedFlavor;
  @JsonKey(name: 'selectedSize')
  final String? selectedSize;
  @JsonKey(name: 'selected_flavor')
  final String? $selectedFlavor;
  @JsonKey(name: 'selected_size')
  final String? $selectedSize;
  static const fromJsonFactory =
      _$V1AdminOrdersIdGet$Response$Data$OrderItems$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdGet$Response$Data$OrderItems$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.orderId, orderId) ||
                const DeepCollectionEquality()
                    .equals(other.orderId, orderId)) &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.productName, productName) ||
                const DeepCollectionEquality()
                    .equals(other.productName, productName)) &&
            (identical(other.unitPrice, unitPrice) ||
                const DeepCollectionEquality()
                    .equals(other.unitPrice, unitPrice)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.subtotal, subtotal) ||
                const DeepCollectionEquality()
                    .equals(other.subtotal, subtotal)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.selectedFlavor, selectedFlavor)) &&
            (identical(other.selectedSize, selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.selectedSize, selectedSize)) &&
            (identical(other.$selectedFlavor, $selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedFlavor, $selectedFlavor)) &&
            (identical(other.$selectedSize, $selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedSize, $selectedSize)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(orderId) ^
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(productName) ^
      const DeepCollectionEquality().hash(unitPrice) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(subtotal) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(selectedFlavor) ^
      const DeepCollectionEquality().hash(selectedSize) ^
      const DeepCollectionEquality().hash($selectedFlavor) ^
      const DeepCollectionEquality().hash($selectedSize) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdGet$Response$Data$OrderItems$ItemExtension
    on V1AdminOrdersIdGet$Response$Data$OrderItems$Item {
  V1AdminOrdersIdGet$Response$Data$OrderItems$Item copyWith(
      {String? id,
      String? orderId,
      String? productId,
      dynamic productName,
      double? unitPrice,
      int? quantity,
      double? subtotal,
      String? imageUrl,
      String? selectedFlavor,
      String? selectedSize,
      String? $selectedFlavor,
      String? $selectedSize}) {
    return V1AdminOrdersIdGet$Response$Data$OrderItems$Item(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        subtotal: subtotal ?? this.subtotal,
        imageUrl: imageUrl ?? this.imageUrl,
        selectedFlavor: selectedFlavor ?? this.selectedFlavor,
        selectedSize: selectedSize ?? this.selectedSize,
        $selectedFlavor: $selectedFlavor ?? this.$selectedFlavor,
        $selectedSize: $selectedSize ?? this.$selectedSize);
  }

  V1AdminOrdersIdGet$Response$Data$OrderItems$Item copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? orderId,
      Wrapped<String>? productId,
      Wrapped<dynamic>? productName,
      Wrapped<double>? unitPrice,
      Wrapped<int>? quantity,
      Wrapped<double>? subtotal,
      Wrapped<String>? imageUrl,
      Wrapped<String?>? selectedFlavor,
      Wrapped<String?>? selectedSize,
      Wrapped<String?>? $selectedFlavor,
      Wrapped<String?>? $selectedSize}) {
    return V1AdminOrdersIdGet$Response$Data$OrderItems$Item(
        id: (id != null ? id.value : this.id),
        orderId: (orderId != null ? orderId.value : this.orderId),
        productId: (productId != null ? productId.value : this.productId),
        productName:
            (productName != null ? productName.value : this.productName),
        unitPrice: (unitPrice != null ? unitPrice.value : this.unitPrice),
        quantity: (quantity != null ? quantity.value : this.quantity),
        subtotal: (subtotal != null ? subtotal.value : this.subtotal),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        selectedFlavor: (selectedFlavor != null
            ? selectedFlavor.value
            : this.selectedFlavor),
        selectedSize:
            (selectedSize != null ? selectedSize.value : this.selectedSize),
        $selectedFlavor: ($selectedFlavor != null
            ? $selectedFlavor.value
            : this.$selectedFlavor),
        $selectedSize:
            ($selectedSize != null ? $selectedSize.value : this.$selectedSize));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdPatch$Response$Data$User {
  const V1AdminOrdersIdPatch$Response$Data$User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory V1AdminOrdersIdPatch$Response$Data$User.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdPatch$Response$Data$UserFromJson(json);

  static const toJsonFactory = _$V1AdminOrdersIdPatch$Response$Data$UserToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdPatch$Response$Data$UserToJson(this);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  static const fromJsonFactory =
      _$V1AdminOrdersIdPatch$Response$Data$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdPatch$Response$Data$User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdPatch$Response$Data$UserExtension
    on V1AdminOrdersIdPatch$Response$Data$User {
  V1AdminOrdersIdPatch$Response$Data$User copyWith(
      {int? id, String? name, String? email}) {
    return V1AdminOrdersIdPatch$Response$Data$User(
        id: id ?? this.id, name: name ?? this.name, email: email ?? this.email);
  }

  V1AdminOrdersIdPatch$Response$Data$User copyWithWrapped(
      {Wrapped<int>? id, Wrapped<String>? name, Wrapped<String>? email}) {
    return V1AdminOrdersIdPatch$Response$Data$User(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        email: (email != null ? email.value : this.email));
  }
}

@JsonSerializable(explicitToJson: true)
class V1AdminOrdersIdPatch$Response$Data$OrderItems$Item {
  const V1AdminOrdersIdPatch$Response$Data$OrderItems$Item({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    required this.imageUrl,
    this.selectedFlavor,
    this.selectedSize,
    this.$selectedFlavor,
    this.$selectedSize,
  });

  factory V1AdminOrdersIdPatch$Response$Data$OrderItems$Item.fromJson(
          Map<String, dynamic> json) =>
      _$V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemFromJson(json);

  static const toJsonFactory =
      _$V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemToJson;
  Map<String, dynamic> toJson() =>
      _$V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'product_name')
  final dynamic productName;
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'subtotal')
  final double subtotal;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'selectedFlavor')
  final String? selectedFlavor;
  @JsonKey(name: 'selectedSize')
  final String? selectedSize;
  @JsonKey(name: 'selected_flavor')
  final String? $selectedFlavor;
  @JsonKey(name: 'selected_size')
  final String? $selectedSize;
  static const fromJsonFactory =
      _$V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is V1AdminOrdersIdPatch$Response$Data$OrderItems$Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.orderId, orderId) ||
                const DeepCollectionEquality()
                    .equals(other.orderId, orderId)) &&
            (identical(other.productId, productId) ||
                const DeepCollectionEquality()
                    .equals(other.productId, productId)) &&
            (identical(other.productName, productName) ||
                const DeepCollectionEquality()
                    .equals(other.productName, productName)) &&
            (identical(other.unitPrice, unitPrice) ||
                const DeepCollectionEquality()
                    .equals(other.unitPrice, unitPrice)) &&
            (identical(other.quantity, quantity) ||
                const DeepCollectionEquality()
                    .equals(other.quantity, quantity)) &&
            (identical(other.subtotal, subtotal) ||
                const DeepCollectionEquality()
                    .equals(other.subtotal, subtotal)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.selectedFlavor, selectedFlavor)) &&
            (identical(other.selectedSize, selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.selectedSize, selectedSize)) &&
            (identical(other.$selectedFlavor, $selectedFlavor) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedFlavor, $selectedFlavor)) &&
            (identical(other.$selectedSize, $selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.$selectedSize, $selectedSize)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(orderId) ^
      const DeepCollectionEquality().hash(productId) ^
      const DeepCollectionEquality().hash(productName) ^
      const DeepCollectionEquality().hash(unitPrice) ^
      const DeepCollectionEquality().hash(quantity) ^
      const DeepCollectionEquality().hash(subtotal) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(selectedFlavor) ^
      const DeepCollectionEquality().hash(selectedSize) ^
      const DeepCollectionEquality().hash($selectedFlavor) ^
      const DeepCollectionEquality().hash($selectedSize) ^
      runtimeType.hashCode;
}

extension $V1AdminOrdersIdPatch$Response$Data$OrderItems$ItemExtension
    on V1AdminOrdersIdPatch$Response$Data$OrderItems$Item {
  V1AdminOrdersIdPatch$Response$Data$OrderItems$Item copyWith(
      {String? id,
      String? orderId,
      String? productId,
      dynamic productName,
      double? unitPrice,
      int? quantity,
      double? subtotal,
      String? imageUrl,
      String? selectedFlavor,
      String? selectedSize,
      String? $selectedFlavor,
      String? $selectedSize}) {
    return V1AdminOrdersIdPatch$Response$Data$OrderItems$Item(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        unitPrice: unitPrice ?? this.unitPrice,
        quantity: quantity ?? this.quantity,
        subtotal: subtotal ?? this.subtotal,
        imageUrl: imageUrl ?? this.imageUrl,
        selectedFlavor: selectedFlavor ?? this.selectedFlavor,
        selectedSize: selectedSize ?? this.selectedSize,
        $selectedFlavor: $selectedFlavor ?? this.$selectedFlavor,
        $selectedSize: $selectedSize ?? this.$selectedSize);
  }

  V1AdminOrdersIdPatch$Response$Data$OrderItems$Item copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? orderId,
      Wrapped<String>? productId,
      Wrapped<dynamic>? productName,
      Wrapped<double>? unitPrice,
      Wrapped<int>? quantity,
      Wrapped<double>? subtotal,
      Wrapped<String>? imageUrl,
      Wrapped<String?>? selectedFlavor,
      Wrapped<String?>? selectedSize,
      Wrapped<String?>? $selectedFlavor,
      Wrapped<String?>? $selectedSize}) {
    return V1AdminOrdersIdPatch$Response$Data$OrderItems$Item(
        id: (id != null ? id.value : this.id),
        orderId: (orderId != null ? orderId.value : this.orderId),
        productId: (productId != null ? productId.value : this.productId),
        productName:
            (productName != null ? productName.value : this.productName),
        unitPrice: (unitPrice != null ? unitPrice.value : this.unitPrice),
        quantity: (quantity != null ? quantity.value : this.quantity),
        subtotal: (subtotal != null ? subtotal.value : this.subtotal),
        imageUrl: (imageUrl != null ? imageUrl.value : this.imageUrl),
        selectedFlavor: (selectedFlavor != null
            ? selectedFlavor.value
            : this.selectedFlavor),
        selectedSize:
            (selectedSize != null ? selectedSize.value : this.selectedSize),
        $selectedFlavor: ($selectedFlavor != null
            ? $selectedFlavor.value
            : this.$selectedFlavor),
        $selectedSize:
            ($selectedSize != null ? $selectedSize.value : this.$selectedSize));
  }
}

String? v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableToJson(
    enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage?
        v1AuthUpdateProfilePost$RequestBodyPreferredLanguage) {
  return v1AuthUpdateProfilePost$RequestBodyPreferredLanguage?.value;
}

String? v1AuthUpdateProfilePost$RequestBodyPreferredLanguageToJson(
    enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage
        v1AuthUpdateProfilePost$RequestBodyPreferredLanguage) {
  return v1AuthUpdateProfilePost$RequestBodyPreferredLanguage.value;
}

enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage
    v1AuthUpdateProfilePost$RequestBodyPreferredLanguageFromJson(
  Object? v1AuthUpdateProfilePost$RequestBodyPreferredLanguage, [
  enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage? defaultValue,
]) {
  return enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage.values
          .firstWhereOrNull((e) =>
              e.value.toString().toLowerCase() ==
              v1AuthUpdateProfilePost$RequestBodyPreferredLanguage
                  ?.toString()
                  .toLowerCase()) ??
      defaultValue ??
      enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage
          .swaggerGeneratedUnknown;
}

enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage?
    v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableFromJson(
  Object? v1AuthUpdateProfilePost$RequestBodyPreferredLanguage, [
  enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage? defaultValue,
]) {
  if (v1AuthUpdateProfilePost$RequestBodyPreferredLanguage == null) {
    return null;
  }
  return enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage.values
          .firstWhereOrNull((e) =>
              e.value.toString().toLowerCase() ==
              v1AuthUpdateProfilePost$RequestBodyPreferredLanguage
                  .toString()
                  .toLowerCase()) ??
      defaultValue;
}

String v1AuthUpdateProfilePost$RequestBodyPreferredLanguageExplodedListToJson(
    List<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage>?
        v1AuthUpdateProfilePost$RequestBodyPreferredLanguage) {
  return v1AuthUpdateProfilePost$RequestBodyPreferredLanguage
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> v1AuthUpdateProfilePost$RequestBodyPreferredLanguageListToJson(
    List<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage>?
        v1AuthUpdateProfilePost$RequestBodyPreferredLanguage) {
  if (v1AuthUpdateProfilePost$RequestBodyPreferredLanguage == null) {
    return [];
  }

  return v1AuthUpdateProfilePost$RequestBodyPreferredLanguage
      .map((e) => e.value!)
      .toList();
}

List<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage>
    v1AuthUpdateProfilePost$RequestBodyPreferredLanguageListFromJson(
  List? v1AuthUpdateProfilePost$RequestBodyPreferredLanguage, [
  List<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage>?
      defaultValue,
]) {
  if (v1AuthUpdateProfilePost$RequestBodyPreferredLanguage == null) {
    return defaultValue ?? [];
  }

  return v1AuthUpdateProfilePost$RequestBodyPreferredLanguage
      .map((e) => v1AuthUpdateProfilePost$RequestBodyPreferredLanguageFromJson(
          e.toString()))
      .toList();
}

List<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage>?
    v1AuthUpdateProfilePost$RequestBodyPreferredLanguageNullableListFromJson(
  List? v1AuthUpdateProfilePost$RequestBodyPreferredLanguage, [
  List<enums.V1AuthUpdateProfilePost$RequestBodyPreferredLanguage>?
      defaultValue,
]) {
  if (v1AuthUpdateProfilePost$RequestBodyPreferredLanguage == null) {
    return defaultValue;
  }

  return v1AuthUpdateProfilePost$RequestBodyPreferredLanguage
      .map((e) => v1AuthUpdateProfilePost$RequestBodyPreferredLanguageFromJson(
          e.toString()))
      .toList();
}

String? v1AdminOrdersIdPatch$RequestBodyStatusNullableToJson(
    enums.V1AdminOrdersIdPatch$RequestBodyStatus?
        v1AdminOrdersIdPatch$RequestBodyStatus) {
  return v1AdminOrdersIdPatch$RequestBodyStatus?.value;
}

String? v1AdminOrdersIdPatch$RequestBodyStatusToJson(
    enums.V1AdminOrdersIdPatch$RequestBodyStatus
        v1AdminOrdersIdPatch$RequestBodyStatus) {
  return v1AdminOrdersIdPatch$RequestBodyStatus.value;
}

enums.V1AdminOrdersIdPatch$RequestBodyStatus
    v1AdminOrdersIdPatch$RequestBodyStatusFromJson(
  Object? v1AdminOrdersIdPatch$RequestBodyStatus, [
  enums.V1AdminOrdersIdPatch$RequestBodyStatus? defaultValue,
]) {
  return enums.V1AdminOrdersIdPatch$RequestBodyStatus.values.firstWhereOrNull(
          (e) =>
              e.value.toString().toLowerCase() ==
              v1AdminOrdersIdPatch$RequestBodyStatus
                  ?.toString()
                  .toLowerCase()) ??
      defaultValue ??
      enums.V1AdminOrdersIdPatch$RequestBodyStatus.swaggerGeneratedUnknown;
}

enums.V1AdminOrdersIdPatch$RequestBodyStatus?
    v1AdminOrdersIdPatch$RequestBodyStatusNullableFromJson(
  Object? v1AdminOrdersIdPatch$RequestBodyStatus, [
  enums.V1AdminOrdersIdPatch$RequestBodyStatus? defaultValue,
]) {
  if (v1AdminOrdersIdPatch$RequestBodyStatus == null) {
    return null;
  }
  return enums.V1AdminOrdersIdPatch$RequestBodyStatus.values.firstWhereOrNull(
          (e) =>
              e.value.toString().toLowerCase() ==
              v1AdminOrdersIdPatch$RequestBodyStatus
                  .toString()
                  .toLowerCase()) ??
      defaultValue;
}

String v1AdminOrdersIdPatch$RequestBodyStatusExplodedListToJson(
    List<enums.V1AdminOrdersIdPatch$RequestBodyStatus>?
        v1AdminOrdersIdPatch$RequestBodyStatus) {
  return v1AdminOrdersIdPatch$RequestBodyStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> v1AdminOrdersIdPatch$RequestBodyStatusListToJson(
    List<enums.V1AdminOrdersIdPatch$RequestBodyStatus>?
        v1AdminOrdersIdPatch$RequestBodyStatus) {
  if (v1AdminOrdersIdPatch$RequestBodyStatus == null) {
    return [];
  }

  return v1AdminOrdersIdPatch$RequestBodyStatus.map((e) => e.value!).toList();
}

List<enums.V1AdminOrdersIdPatch$RequestBodyStatus>
    v1AdminOrdersIdPatch$RequestBodyStatusListFromJson(
  List? v1AdminOrdersIdPatch$RequestBodyStatus, [
  List<enums.V1AdminOrdersIdPatch$RequestBodyStatus>? defaultValue,
]) {
  if (v1AdminOrdersIdPatch$RequestBodyStatus == null) {
    return defaultValue ?? [];
  }

  return v1AdminOrdersIdPatch$RequestBodyStatus
      .map((e) => v1AdminOrdersIdPatch$RequestBodyStatusFromJson(e.toString()))
      .toList();
}

List<enums.V1AdminOrdersIdPatch$RequestBodyStatus>?
    v1AdminOrdersIdPatch$RequestBodyStatusNullableListFromJson(
  List? v1AdminOrdersIdPatch$RequestBodyStatus, [
  List<enums.V1AdminOrdersIdPatch$RequestBodyStatus>? defaultValue,
]) {
  if (v1AdminOrdersIdPatch$RequestBodyStatus == null) {
    return defaultValue;
  }

  return v1AdminOrdersIdPatch$RequestBodyStatus
      .map((e) => v1AdminOrdersIdPatch$RequestBodyStatusFromJson(e.toString()))
      .toList();
}

String? v1CustomerOrdersPost$RequestBodyPaymentMethodNullableToJson(
    enums.V1CustomerOrdersPost$RequestBodyPaymentMethod?
        v1CustomerOrdersPost$RequestBodyPaymentMethod) {
  return v1CustomerOrdersPost$RequestBodyPaymentMethod?.value;
}

String? v1CustomerOrdersPost$RequestBodyPaymentMethodToJson(
    enums.V1CustomerOrdersPost$RequestBodyPaymentMethod
        v1CustomerOrdersPost$RequestBodyPaymentMethod) {
  return v1CustomerOrdersPost$RequestBodyPaymentMethod.value;
}

enums.V1CustomerOrdersPost$RequestBodyPaymentMethod
    v1CustomerOrdersPost$RequestBodyPaymentMethodFromJson(
  Object? v1CustomerOrdersPost$RequestBodyPaymentMethod, [
  enums.V1CustomerOrdersPost$RequestBodyPaymentMethod? defaultValue,
]) {
  return enums.V1CustomerOrdersPost$RequestBodyPaymentMethod.values
          .firstWhereOrNull((e) =>
              e.value.toString().toLowerCase() ==
              v1CustomerOrdersPost$RequestBodyPaymentMethod
                  ?.toString()
                  .toLowerCase()) ??
      defaultValue ??
      enums.V1CustomerOrdersPost$RequestBodyPaymentMethod
          .swaggerGeneratedUnknown;
}

enums.V1CustomerOrdersPost$RequestBodyPaymentMethod?
    v1CustomerOrdersPost$RequestBodyPaymentMethodNullableFromJson(
  Object? v1CustomerOrdersPost$RequestBodyPaymentMethod, [
  enums.V1CustomerOrdersPost$RequestBodyPaymentMethod? defaultValue,
]) {
  if (v1CustomerOrdersPost$RequestBodyPaymentMethod == null) {
    return null;
  }
  return enums.V1CustomerOrdersPost$RequestBodyPaymentMethod.values
          .firstWhereOrNull((e) =>
              e.value.toString().toLowerCase() ==
              v1CustomerOrdersPost$RequestBodyPaymentMethod
                  .toString()
                  .toLowerCase()) ??
      defaultValue;
}

String v1CustomerOrdersPost$RequestBodyPaymentMethodExplodedListToJson(
    List<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod>?
        v1CustomerOrdersPost$RequestBodyPaymentMethod) {
  return v1CustomerOrdersPost$RequestBodyPaymentMethod
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> v1CustomerOrdersPost$RequestBodyPaymentMethodListToJson(
    List<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod>?
        v1CustomerOrdersPost$RequestBodyPaymentMethod) {
  if (v1CustomerOrdersPost$RequestBodyPaymentMethod == null) {
    return [];
  }

  return v1CustomerOrdersPost$RequestBodyPaymentMethod
      .map((e) => e.value!)
      .toList();
}

List<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod>
    v1CustomerOrdersPost$RequestBodyPaymentMethodListFromJson(
  List? v1CustomerOrdersPost$RequestBodyPaymentMethod, [
  List<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod>? defaultValue,
]) {
  if (v1CustomerOrdersPost$RequestBodyPaymentMethod == null) {
    return defaultValue ?? [];
  }

  return v1CustomerOrdersPost$RequestBodyPaymentMethod
      .map((e) =>
          v1CustomerOrdersPost$RequestBodyPaymentMethodFromJson(e.toString()))
      .toList();
}

List<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod>?
    v1CustomerOrdersPost$RequestBodyPaymentMethodNullableListFromJson(
  List? v1CustomerOrdersPost$RequestBodyPaymentMethod, [
  List<enums.V1CustomerOrdersPost$RequestBodyPaymentMethod>? defaultValue,
]) {
  if (v1CustomerOrdersPost$RequestBodyPaymentMethod == null) {
    return defaultValue;
  }

  return v1CustomerOrdersPost$RequestBodyPaymentMethod
      .map((e) =>
          v1CustomerOrdersPost$RequestBodyPaymentMethodFromJson(e.toString()))
      .toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
