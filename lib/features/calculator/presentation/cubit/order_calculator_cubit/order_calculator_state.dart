import 'package:equatable/equatable.dart';
import '../../../../product/domain/entities/product.dart';

enum OrderCalculatorStatus { initial, loading, loaded, error }

class OrderCalculatorState extends Equatable {
  final OrderCalculatorStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final String searchQuery;
  final Product? selectedProduct;
  final int cartonCount;
  final String? errorMessage;
  final String? validationError;

  const OrderCalculatorState({
    this.status = OrderCalculatorStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.selectedProduct,
    this.cartonCount = 0,
    this.errorMessage,
    this.validationError,
  });

  bool get canCalculate => selectedProduct != null && cartonCount > 0;

  OrderCalculatorState copyWith({
    OrderCalculatorStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    String? searchQuery,
    Product? selectedProduct,
    bool clearSelectedProduct = false,
    int? cartonCount,
    String? errorMessage,
    bool clearError = false,
    String? validationError,
    bool clearValidation = false,
  }) {
    return OrderCalculatorState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProduct: clearSelectedProduct ? null : (selectedProduct ?? this.selectedProduct),
      cartonCount: cartonCount ?? this.cartonCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      validationError: clearValidation ? null : (validationError ?? this.validationError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    allProducts,
    filteredProducts,
    searchQuery,
    selectedProduct,
    cartonCount,
    errorMessage,
    validationError,
  ];
}
