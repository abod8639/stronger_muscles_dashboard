import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class NetworkErrorHandler {
  const NetworkErrorHandler._();

  /// يحول أي [DioException] إلى [Failure] مناسب موحد
  static Failure handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من سرعة الإنترنت والمحاولة مجدداً.',
          statusCode: e.response?.statusCode,
          originalError: e,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت.',
          statusCode: e.response?.statusCode,
          originalError: e,
        );

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'تم إلغاء العملية بناءً على طلبك.',
          statusCode: e.response?.statusCode,
          originalError: e,
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          message: 'فشل في التحقق من أمان الشهادة الرقمية للاتصال.',
          statusCode: e.response?.statusCode,
          originalError: e,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      case DioExceptionType.unknown:
      default:
        if (e.message != null && e.message!.toLowerCase().contains('socketexception')) {
          return NetworkFailure(
            message: 'لا يوجد اتصال بالإنترنت.',
            statusCode: e.response?.statusCode,
            originalError: e,
          );
        }
        return UnknownFailure(
          message: e.message ?? 'حدث خطأ غير متوقع في الاتصال.',
          statusCode: e.response?.statusCode,
          originalError: e,
        );
    }
  }

  /// معالجة استجابات الخادم غير الناجحة (4xx, 5xx)
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure(message: 'لم يتم استلام أي استجابة من الخادم.');
    }

    final statusCode = response.statusCode ?? 500;
    final dynamic data = response.data;
    String? serverMessage;
    Map<String, List<String>> validationErrors = {};

    if (data is Map) {
      serverMessage = data['message']?.toString() ?? data['error']?.toString();

      if (data['errors'] is Map) {
        final rawErrors = data['errors'] as Map;
        rawErrors.forEach((key, value) {
          if (value is List) {
            validationErrors[key.toString()] =
                value.map((e) => e.toString()).toList();
          } else if (value != null) {
            validationErrors[key.toString()] = [value.toString()];
          }
        });
      }
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: serverMessage ?? 'طلب غير صالح (Bad Request).',
          statusCode: statusCode,
          originalError: data,
        );

      case 401:
        return AuthFailure(
          message: serverMessage ?? 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
          statusCode: statusCode,
          originalError: data,
        );

      case 403:
        return AuthFailure(
          message: serverMessage ?? 'ليس لديك الصلاحيات الكافية للوصول إلى هذا القسم.',
          statusCode: statusCode,
          originalError: data,
        );

      case 404:
        return ServerFailure(
          message: serverMessage ?? 'المورد أو الرابط المطلوب غير موجود.',
          statusCode: statusCode,
          originalError: data,
        );

      case 422:
        return ValidationFailure(
          message: serverMessage ?? 'البيانات المدخلة غير صالحة. يرجى مراجعة الحقول.',
          fieldErrors: validationErrors,
          statusCode: statusCode,
          originalError: data,
        );

      case 429:
        return ServerFailure(
          message: serverMessage ?? 'تم تجاوز الحد الأقصى للطلبات. يرجى الانتظار قليلاً.',
          statusCode: statusCode,
          originalError: data,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: serverMessage ?? 'حدث خطأ في خادم النظام ($statusCode). يرجى المحاولة لاحقاً.',
          statusCode: statusCode,
          originalError: data,
        );

      default:
        return ServerFailure(
          message: serverMessage ?? 'استجابة غير متوقعة من الخادم (كود: $statusCode).',
          statusCode: statusCode,
          originalError: data,
        );
    }
  }

  /// تحويل عام لأي استثناء يطرأ إلى [Failure] موحد
  static Failure handleException(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;

    if (error is DioException) {
      return handleDioError(error);
    }

    if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        fieldErrors: error.errors,
        statusCode: error.statusCode,
        originalError: error.originalError,
      );
    }

    if (error is AuthException) {
      return AuthFailure(
        message: error.message,
        statusCode: error.statusCode,
        originalError: error.originalError,
      );
    }

    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        statusCode: error.statusCode,
        originalError: error.originalError,
      );
    }

    if (error is NetworkException) {
      return NetworkFailure(
        message: error.message,
        statusCode: error.statusCode,
        originalError: error.originalError,
      );
    }

    if (error is CacheException) {
      return CacheFailure(
        message: error.message,
        statusCode: error.statusCode,
        originalError: error.originalError,
      );
    }

    if (error is ParsingException) {
      return ParsingFailure(
        message: error.message,
        statusCode: error.statusCode,
        originalError: error.originalError,
      );
    }

    if (error is FormatException || error is TypeError) {
      return ParsingFailure(
        message: 'خطأ في بنية البيانات المستلمة من الخادم.',
        originalError: error,
      );
    }

    return UnknownFailure(
      message: error.toString(),
      originalError: error,
    );
  }
}
