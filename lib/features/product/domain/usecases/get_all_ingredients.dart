import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ingredient.dart';
import '../repositories/product_repository.dart';

class GetAllIngredients implements UseCase<List<Ingredient>, NoParams> {
  final ProductRepository repository;
  GetAllIngredients(this.repository);

  @override
  Future<Either<Failure, List<Ingredient>>> call(NoParams params) async {
    return await repository.getAllIngredients();
  }
}
