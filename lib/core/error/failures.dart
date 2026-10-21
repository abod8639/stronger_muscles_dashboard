abstract class Failure {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  String toMessage() => message;

  @override
  String toString() => '${runtimeType.toString()}: ${toMessage()}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;
}

/// فشل الاتصال بالشبكة (Timeouts, No Internet, DNS failure)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// فشل ناتج عن أخطاء الخادم (500, 502, 503, etc.)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// فشل المصادقة والصلاحيات (401 Unauthorized, 403 Forbidden)
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// فشل التحقق من صحة المدخلات (422 Unprocessable Entity)
class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
    super.statusCode = 422,
    super.originalError,
  });

  @override
  String toMessage() {
    if (fieldErrors.isNotEmpty) {
      final buffer = StringBuffer();
      buffer.writeln(message);
      fieldErrors.forEach((key, errors) {
        for (final error in errors) {
          buffer.writeln('• $error');
        }
      });
      return buffer.toString().trim();
    }
    return message;
  }
}

/// فشل تحليل واستخراج البيانات (Malformed JSON, TypeError)
class ParsingFailure extends Failure {
  const ParsingFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// فشل عمليات التخزين المحلي (GetStorage, Hive, SharedPrefs)
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

/// فشل عام أو غير متوقع
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}
