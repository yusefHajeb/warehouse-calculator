import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/calculation_result.dart';

/// Read-only holder for the computed [BulkCalculationResult].
/// Populated at route level and used by [BulkResultsPage].
class BulkResultCubit extends Cubit<BulkCalculationResult> {
  BulkResultCubit(super.result);
}
