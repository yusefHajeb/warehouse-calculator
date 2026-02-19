import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product/domain/entities/product.dart';
import '../../../../product/domain/usecases/get_products.dart';
import '../../../../product/domain/usecases/search_products.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/calculation_result.dart';
import 'order_calculator_state.dart';

class OrderCalculatorCubit extends Cubit<OrderCalculatorState> {
  final GetProducts _getProducts;
  final SearchProducts _searchProducts;
  Timer? _debounce;

  OrderCalculatorCubit({required GetProducts getProducts, required SearchProducts searchProducts})
    : _getProducts = getProducts,
      _searchProducts = searchProducts,
      super(const OrderCalculatorState());

  // ── Load Products ──

  Future<void> loadProducts() async {
    emit(state.copyWith(status: OrderCalculatorStatus.loading));

    final result = await _getProducts(NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: OrderCalculatorStatus.error, errorMessage: failure.message)),
      (products) => emit(
        state.copyWith(
          status: OrderCalculatorStatus.loaded,
          allProducts: products,
          filteredProducts: products,
        ),
      ),
    );
  }

  // ── Search ──

  void searchProducts(String query) {
    emit(state.copyWith(searchQuery: query, clearValidation: true));
    _debounce?.cancel();

    if (query.isEmpty) {
      emit(state.copyWith(filteredProducts: state.allProducts));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final result = await _searchProducts(query);
      result.fold(
        (failure) => emit(
          state.copyWith(status: OrderCalculatorStatus.error, errorMessage: failure.message),
        ),
        (products) => emit(state.copyWith(filteredProducts: products)),
      );
    });
  }

  // ── Selection ──

  void selectProduct(Product product) {
    emit(
      state.copyWith(
        selectedProduct: product,
        searchQuery: '',
        filteredProducts: state.allProducts,
        clearValidation: true,
      ),
    );
  }

  void clearProduct() {
    emit(state.copyWith(clearSelectedProduct: true, clearValidation: true));
  }

  // ── Carton Count ──

  void setCartonCount(String value) {
    final count = int.tryParse(value) ?? 0;
    emit(state.copyWith(cartonCount: count < 0 ? 0 : count, clearValidation: true));
  }

  void increment() {
    emit(state.copyWith(cartonCount: state.cartonCount + 1, clearValidation: true));
  }

  void decrement() {
    if (state.cartonCount > 0) {
      emit(state.copyWith(cartonCount: state.cartonCount - 1, clearValidation: true));
    }
  }

  // ── Calculate ──

  CalculationResult? calculate() {
    // Validate
    if (state.selectedProduct == null) {
      emit(state.copyWith(validationError: 'يجب اختيار منتج أولاً'));
      return null;
    }
    if (state.cartonCount <= 0) {
      emit(state.copyWith(validationError: 'يجب إدخال عدد الكراتين'));
      return null;
    }

    final product = state.selectedProduct!;

    if (product.ingredients.isEmpty) {
      emit(state.copyWith(validationError: 'المنتج لا يحتوي على مكونات'));
      return null;
    }

    // Compute
    final totalPieces = state.cartonCount * product.boxesPerCarton * product.piecesPerBox;

    final materials = product.ingredients.map((ingredient) {
      final requiredKg = totalPieces * ingredient.quantityPerPiece / 1000;
      return MaterialRequirement(
        ingredientName: ingredient.name,
        perPieceGrams: ingredient.quantityPerPiece,
        requiredKg: requiredKg,
      );
    }).toList();

    final totalWeightKg = materials.fold<double>(0, (sum, m) => sum + m.requiredKg);

    return CalculationResult(
      product: product,
      cartonCount: state.cartonCount,
      totalPieces: totalPieces,
      materials: materials,
      totalWeightKg: totalWeightKg,
      calculatedAt: DateTime.now(),
    );
  }

  // ── Reset ──

  void reset() {
    emit(
      state.copyWith(
        clearSelectedProduct: true,
        cartonCount: 0,
        searchQuery: '',
        filteredProducts: state.allProducts,
        clearValidation: true,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
