import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_order.dart';
import '../repositories/order_repository.dart';

class SaveOrder implements UseCase<Unit, SavedOrder> {
  final OrderRepository repository;
  SaveOrder(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SavedOrder params) {
    return repository.saveOrder(params);
  }
}
