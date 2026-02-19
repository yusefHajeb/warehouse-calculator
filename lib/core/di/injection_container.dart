import 'package:get_it/get_it.dart';
import '../database/database_helper.dart';
import '../../features/product/data/datasources/product_local_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/add_product.dart';
import '../../features/product/domain/usecases/delete_product.dart';
import '../../features/product/domain/usecases/get_products.dart';
import '../../features/product/domain/usecases/search_products.dart';
import '../../features/product/domain/usecases/update_product.dart';
import '../../features/product/presentation/cubit/product_form_cubit.dart';
import '../../features/product/presentation/cubit/product_list_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ══════════════════════════════════════
  //  Features — Product
  // ══════════════════════════════════════

  // Cubits
  sl.registerFactory(
    () => ProductListCubit(getProducts: sl(), searchProducts: sl(), deleteProduct: sl()),
  );

  sl.registerFactory(() => ProductFormCubit(addProduct: sl(), updateProduct: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ══════════════════════════════════════
  //  Core
  // ══════════════════════════════════════
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
