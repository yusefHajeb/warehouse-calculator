import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'حدث خطأ في قاعدة البيانات']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'العنصر المطلوب غير موجود']);
}

class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const ValidationFailure({String message = 'بيانات غير صالحة', this.fieldErrors = const {}})
    : super(message);

  @override
  List<Object?> get props => [message, fieldErrors];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'خطأ في التخزين المؤقت']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({String message = 'خطأ في الخادم', this.statusCode}) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class BusinessFailure extends Failure {
  const BusinessFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع']);
}
