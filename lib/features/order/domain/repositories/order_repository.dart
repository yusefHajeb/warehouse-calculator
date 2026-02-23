import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/saved_order.dart';

abstract class OrderRepository {
  Future<Either<Failure, Unit>> saveOrder(SavedOrder order);
  Future<Either<Failure, List<SavedOrder>>> getOrders();
  Future<Either<Failure, SavedOrder>> getOrderById(String id);
  Future<Either<Failure, Unit>> deleteOrder(String id);
}
