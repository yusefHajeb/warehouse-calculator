import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/calculation_result.dart';

/// Read-only holder for computed calculation results.
class CalculationResultCubit extends Cubit<CalculationResult> {
  CalculationResultCubit(super.result);
}
