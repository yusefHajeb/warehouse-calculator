import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/order_repository.dart';

class DeleteOrder implements UseCase<Unit, String> {
  final OrderRepository repository;
  DeleteOrder(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteOrder(params);
  }
}
