import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final GetProducts _getProducts;
  final SearchProducts _searchProducts;
  final DeleteProduct _deleteProduct;

  Timer? _debounce;

  ProductListCubit({
    required GetProducts getProducts,
    required SearchProducts searchProducts,
    required DeleteProduct deleteProduct,
  }) : _getProducts = getProducts,
       _searchProducts = searchProducts,
       _deleteProduct = deleteProduct,
       super(const ProductListState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductListStatus.loading, searchQuery: ''));

    final result = await _getProducts(NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: ProductListStatus.error, errorMessage: failure.message)),
      (products) => emit(
        state.copyWith(
          status: products.isEmpty ? ProductListStatus.empty : ProductListStatus.loaded,
          products: products,
        ),
      ),
    );
  }

  void searchProducts(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
      loadProducts();
      return;
    }

    emit(state.copyWith(searchQuery: query));

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      emit(state.copyWith(status: ProductListStatus.loading));

      final result = await _searchProducts(query);

      result.fold(
        (failure) =>
            emit(state.copyWith(status: ProductListStatus.error, errorMessage: failure.message)),
        (products) => emit(
          state.copyWith(
            status: products.isEmpty ? ProductListStatus.empty : ProductListStatus.loaded,
            products: products,
          ),
        ),
      );
    });
  }

  Future<void> deleteProduct(String id) async {
    final result = await _deleteProduct(id);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: ProductListStatus.error, errorMessage: failure.message)),
      (_) {
        // Reload to refresh list after deletion
        if (state.searchQuery.isEmpty) {
          loadProducts();
        } else {
          searchProducts(state.searchQuery);
        }
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
