import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../calculator/domain/entities/calculation_result.dart';
import '../../domain/entities/saved_order.dart';
import '../../domain/usecases/save_order.dart';

// ── State ──────────────────────────────────────────────────────────────────────

enum SaveOrderStatus { initial, saving, success, error }

class SaveOrderState extends Equatable {
  final String name;
  final String notes;
  final DateTime orderDate;
  final SaveOrderStatus status;
  final String? errorMessage;

  const SaveOrderState({
    this.name = '',
    this.notes = '',
    required this.orderDate,
    this.status = SaveOrderStatus.initial,
    this.errorMessage,
  });

  SaveOrderState copyWith({
    String? name,
    String? notes,
    DateTime? orderDate,
    SaveOrderStatus? status,
    String? errorMessage,
  }) {
    return SaveOrderState(
      name: name ?? this.name,
      notes: notes ?? this.notes,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [name, notes, orderDate, status, errorMessage];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class SaveOrderCubit extends Cubit<SaveOrderState> {
  final SaveOrder _saveOrder;
  final BulkCalculationResult calculationResult;

  SaveOrderCubit({required SaveOrder saveOrder, required this.calculationResult})
    : _saveOrder = saveOrder,
      super(SaveOrderState(orderDate: DateTime.now()));

  void nameChanged(String value) => emit(state.copyWith(name: value));
  void notesChanged(String value) => emit(state.copyWith(notes: value));
  void dateChanged(DateTime value) => emit(state.copyWith(orderDate: value));

  Future<void> save() async {
    final trimmedName = state.name.trim();
    if (trimmedName.isEmpty) {
      emit(state.copyWith(status: SaveOrderStatus.error, errorMessage: 'اسم الطلب مطلوب'));
      return;
    }

    emit(state.copyWith(status: SaveOrderStatus.saving));

    final orderId = const Uuid().v4();
    final now = DateTime.now();

    final items = calculationResult.productResults.map((pr) {
      return SavedOrderItem(
        id: const Uuid().v4(),
        orderId: orderId,
        productId: pr.product.id,
        productName: pr.product.name,
        cartonCount: pr.cartonCount,
        piecesPerBox: pr.product.piecesPerBox,
        boxesPerCarton: pr.product.boxesPerCarton,
        totalPieces: pr.totalPieces,
        materials: pr.materials,
      );
    }).toList();

    final order = SavedOrder(
      id: orderId,
      name: trimmedName,
      notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
      orderDate: state.orderDate,
      totalPieces: calculationResult.totalPieces,
      totalWeightKg: calculationResult.totalWeightKg,
      createdAt: now,
      items: items,
    );

    final result = await _saveOrder(order);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: SaveOrderStatus.error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: SaveOrderStatus.success)),
    );
  }
}
