import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_order.dart';
import '../repositories/order_repository.dart';

class GetOrderById implements UseCase<SavedOrder, String> {
  final OrderRepository repository;
  GetOrderById(this.repository);

  @override
  Future<Either<Failure, SavedOrder>> call(String params) {
    return repository.getOrderById(params);
  }
}
