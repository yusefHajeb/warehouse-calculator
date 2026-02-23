import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/saved_order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/saved_order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> saveOrder(SavedOrder order) async {
    try {
      final model = SavedOrderModel.fromEntity(order);
      await localDataSource.saveOrder(model);
      return const Right(unit);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<SavedOrder>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, SavedOrder>> getOrderById(String id) async {
    try {
      final order = await localDataSource.getOrderById(id);
      return Right(order);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOrder(String id) async {
    try {
      await localDataSource.deleteOrder(id);
      return const Right(unit);
    } catch (e) {
      return Left(FailureMapper.fromException(e));
    }
  }
}
