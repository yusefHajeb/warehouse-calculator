import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/saved_order.dart';
import '../../domain/usecases/get_order_by_id.dart';

// ── State ──────────────────────────────────────────────────────────────────────

enum OrderDetailStatus { loading, loaded, error }

class OrderDetailState extends Equatable {
  final SavedOrder? order;
  final OrderDetailStatus status;
  final String? errorMessage;

  const OrderDetailState({this.order, this.status = OrderDetailStatus.loading, this.errorMessage});

  OrderDetailState copyWith({SavedOrder? order, OrderDetailStatus? status, String? errorMessage}) =>
      OrderDetailState(
        order: order ?? this.order,
        status: status ?? this.status,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [order, status, errorMessage];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class OrderDetailCubit extends Cubit<OrderDetailState> {
  final GetOrderById _getOrderById;

  OrderDetailCubit({required GetOrderById getOrderById})
    : _getOrderById = getOrderById,
      super(const OrderDetailState());

  Future<void> load(String orderId) async {
    emit(state.copyWith(status: OrderDetailStatus.loading));
    final result = await _getOrderById(orderId);
    result.fold(
      (f) => emit(state.copyWith(status: OrderDetailStatus.error, errorMessage: f.message)),
      (order) => emit(state.copyWith(status: OrderDetailStatus.loaded, order: order)),
    );
  }
}
