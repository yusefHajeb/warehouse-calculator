abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

class LocalDatabaseException extends AppException {
  const LocalDatabaseException({
    super.message = 'حدث خطأ في قاعدة البيانات',
    super.code,
    super.originalError,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'العنصر المطلوب غير موجود',
    super.code,
    super.originalError,
  });
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException({
    super.message = 'بيانات غير صالحة',
    super.code,
    super.originalError,
    this.fieldErrors = const {},
  });
}

class CacheException extends AppException {
  const CacheException({super.message = 'خطأ في التخزين المؤقت', super.code, super.originalError});
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'لا يوجد اتصال بالإنترنت',
    super.code,
    super.originalError,
  });
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    super.message = 'خطأ في الخادم',
    super.code,
    super.originalError,
    this.statusCode,
  });
}

class UnexpectedException extends AppException {
  const UnexpectedException({super.message = 'حدث خطأ غير متوقع', super.code, super.originalError});
}
