import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_order.dart';
import '../repositories/order_repository.dart';

class GetOrders implements UseCase<List<SavedOrder>, NoParams> {
  final OrderRepository repository;
  GetOrders(this.repository);

  @override
  Future<Either<Failure, List<SavedOrder>>> call(NoParams params) {
    return repository.getOrders();
  }
}
