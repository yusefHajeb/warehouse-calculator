import 'package:equatable/equatable.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/product.dart';

enum ProductFormStatus { initial, submitting, success, error }

class ProductFormState extends Equatable {
  final Product product;
  final ProductFormStatus status;
  final bool isEditing;
  final String? errorMessage;
  final Map<String, String> validationErrors;

  /// Canonical ingredient catalogue loaded from the DB (for autocomplete).
  final List<Ingredient> allIngredients;

  const ProductFormState({
    required this.product,
    this.status = ProductFormStatus.initial,
    this.isEditing = false,
    this.errorMessage,
    this.validationErrors = const {},
    this.allIngredients = const [],
  });

  factory ProductFormState.initial() {
    return ProductFormState(product: Product.empty());
  }

  ProductFormState copyWith({
    Product? product,
    ProductFormStatus? status,
    bool? isEditing,
    String? errorMessage,
    Map<String, String>? validationErrors,
    List<Ingredient>? allIngredients,
  }) {
    return ProductFormState(
      product: product ?? this.product,
      status: status ?? this.status,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage,
      validationErrors: validationErrors ?? this.validationErrors,
      allIngredients: allIngredients ?? this.allIngredients,
    );
  }

  bool get isValid => validationErrors.isEmpty;

  @override
  List<Object?> get props => [
    product,
    status,
    isEditing,
    errorMessage,
    validationErrors,
    allIngredients,
  ];
}
