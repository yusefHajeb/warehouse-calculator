import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/saved_order.dart';
import '../../domain/usecases/delete_order.dart';
import '../../domain/usecases/get_orders.dart';

// ── State ──────────────────────────────────────────────────────────────────────

enum OrderListStatus { initial, loading, loaded, error }

class OrderListState extends Equatable {
  final List<SavedOrder> orders;
  final OrderListStatus status;
  final String? errorMessage;

  const OrderListState({
    this.orders = const [],
    this.status = OrderListStatus.initial,
    this.errorMessage,
  });

  OrderListState copyWith({
    List<SavedOrder>? orders,
    OrderListStatus? status,
    String? errorMessage,
  }) => OrderListState(
    orders: orders ?? this.orders,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [orders, status, errorMessage];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class OrderListCubit extends Cubit<OrderListState> {
  final GetOrders _getOrders;
  final DeleteOrder _deleteOrder;

  OrderListCubit({required GetOrders getOrders, required DeleteOrder deleteOrder})
    : _getOrders = getOrders,
      _deleteOrder = deleteOrder,
      super(const OrderListState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrderListStatus.loading));
    final result = await _getOrders(NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: OrderListStatus.error, errorMessage: f.message)),
      (orders) => emit(state.copyWith(status: OrderListStatus.loaded, orders: orders)),
    );
  }

  Future<void> deleteOrder(String id) async {
    final result = await _deleteOrder(id);
    result.fold((_) {}, (_) => loadOrders());
  }
}
