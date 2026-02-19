import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

enum ProductListStatus { initial, loading, loaded, empty, error }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<Product> products;
  final String searchQuery;
  final String? errorMessage;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, searchQuery, errorMessage];
}
