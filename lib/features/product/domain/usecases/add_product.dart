import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProduct implements UseCase<Unit, Product> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Product product) async {
    return await repository.addProduct(product);
  }
}
