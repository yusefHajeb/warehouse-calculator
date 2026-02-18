import 'exceptions.dart';
import 'failures.dart';

class FailureMapper {
  static Failure fromException(dynamic exception) {
    if (exception is LocalDatabaseException) {
      return DatabaseFailure(exception.message);
    }

    if (exception is NotFoundException) {
      return NotFoundFailure(exception.message);
    }

    if (exception is ValidationException) {
      return ValidationFailure(message: exception.message, fieldErrors: exception.fieldErrors);
    }

    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is ServerException) {
      return ServerFailure(message: exception.message, statusCode: exception.statusCode);
    }

    if (exception is AppException) {
      return UnexpectedFailure(exception.message);
    }

    return UnexpectedFailure(exception.toString());
  }
}
