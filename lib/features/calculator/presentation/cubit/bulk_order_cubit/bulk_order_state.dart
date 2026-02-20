import 'package:equatable/equatable.dart';
import '../../../../product/domain/entities/product.dart';
import '../../../domain/entities/calculation_result.dart';

enum BulkOrderStatus { initial, loading, loaded, error }

class BulkOrderState extends Equatable {
  final BulkOrderStatus status;
  final List<Product> allProducts;
  final List<BulkOrderItem> items;
  final String? errorMessage;
  final String? validationError;

  const BulkOrderState({
    this.status = BulkOrderStatus.initial,
    this.allProducts = const [],
    this.items = const [],
    this.errorMessage,
    this.validationError,
  });

  int get totalPieces => items.fold(0, (sum, item) => sum + item.totalPieces);
  bool get canCalculate => items.isNotEmpty;

  BulkOrderState copyWith({
    BulkOrderStatus? status,
    List<Product>? allProducts,
    List<BulkOrderItem>? items,
    String? errorMessage,
    bool clearError = false,
    String? validationError,
    bool clearValidation = false,
  }) {
    return BulkOrderState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      validationError: clearValidation ? null : (validationError ?? this.validationError),
    );
  }

  @override
  List<Object?> get props => [status, allProducts, items, errorMessage, validationError];
}
