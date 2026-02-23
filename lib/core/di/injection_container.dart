import 'package:get_it/get_it.dart';
import '../database/database_helper.dart';
import '../../features/product/data/datasources/product_local_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/add_product.dart';
import '../../features/product/domain/usecases/delete_product.dart';
import '../../features/product/domain/usecases/get_all_ingredients.dart';
import '../../features/product/domain/usecases/get_products.dart';
import '../../features/product/domain/usecases/search_products.dart';
import '../../features/product/domain/usecases/update_product.dart';
import '../../features/product/presentation/cubit/product_form_cubit.dart';
import '../../features/product/presentation/cubit/product_list_cubit.dart';
import '../../features/calculator/presentation/cubit/order_calculator_cubit/order_calculator_cubit.dart';
import '../../features/calculator/presentation/cubit/bulk_order_cubit/bulk_order_cubit.dart';
import '../../features/order/data/datasources/order_local_data_source.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/data/services/order_pdf_service.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/save_order.dart';
import '../../features/order/domain/usecases/get_orders.dart';
import '../../features/order/domain/usecases/get_order_by_id.dart';
import '../../features/order/domain/usecases/delete_order.dart' as order_uc;
import '../../features/order/presentation/cubit/order_list_cubit.dart';
import '../../features/order/presentation/cubit/order_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ══════════════════════════════════════
  //  Features — Product
  // ══════════════════════════════════════

  // Cubits
  sl.registerFactory(
    () => ProductListCubit(getProducts: sl(), searchProducts: sl(), deleteProduct: sl()),
  );

  sl.registerFactory(
    () => ProductFormCubit(addProduct: sl(), updateProduct: sl(), getAllIngredients: sl()),
  );

  // ══════════════════════════════════════
  //  Features — Calculator
  // ══════════════════════════════════════

  // Cubits
  sl.registerFactory(() => OrderCalculatorCubit(getProducts: sl(), searchProducts: sl()));
  sl.registerFactory(() => BulkOrderCubit(getProducts: sl(), searchProducts: sl()));

  // ══════════════════════════════════════
  //  Features — Orders
  // ══════════════════════════════════════

  // Cubits
  sl.registerFactory(() => OrderListCubit(getOrders: sl(), deleteOrder: sl()));
  sl.registerFactory(() => OrderDetailCubit(getOrderById: sl()));

  // Use Cases — Product
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetAllIngredients(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // Use Cases — Order
  sl.registerLazySingleton(() => SaveOrder(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => GetOrderById(sl()));
  sl.registerLazySingleton(() => order_uc.DeleteOrder(sl()));

  // Repository — Product
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(localDataSource: sl()));

  // Repository — Order
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Services
  sl.registerLazySingleton(() => OrderPdfService());

  // ══════════════════════════════════════
  //  Core
  // ══════════════════════════════════════
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
