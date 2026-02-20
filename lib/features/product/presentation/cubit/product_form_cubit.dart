import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/get_all_ingredients.dart';
import '../../domain/usecases/update_product.dart';
import 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final GetAllIngredients _getAllIngredients;

  ProductFormCubit({
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required GetAllIngredients getAllIngredients,
  }) : _addProduct = addProduct,
       _updateProduct = updateProduct,
       _getAllIngredients = getAllIngredients,
       super(ProductFormState.initial());

  // ── Initialisation ─────────────────────────────────────────────────────────

  Future<void> initForm(Product? existingProduct) async {
    if (existingProduct != null) {
      emit(ProductFormState(product: existingProduct, isEditing: true));
    } else {
      emit(ProductFormState.initial());
    }
    await loadIngredients();
  }

  /// Loads the canonical ingredient catalogue from the DB and stores it in
  /// state so the autocomplete picker can display it.
  Future<void> loadIngredients() async {
    final result = await _getAllIngredients(NoParams());
    result.fold(
      (_) {}, // silently ignore — picker will just be empty
      (ingredients) => emit(state.copyWith(allIngredients: ingredients)),
    );
  }

  // ── Field Updates ──────────────────────────────────────────────────────────

  void nameChanged(String name) {
    emit(
      state.copyWith(
        product: state.product.copyWith(name: name),
        validationErrors: Map.of(state.validationErrors)..remove('name'),
      ),
    );
  }

  void piecesPerBoxChanged(String value) {
    final parsed = int.tryParse(value) ?? 0;
    emit(
      state.copyWith(
        product: state.product.copyWith(piecesPerBox: parsed),
        validationErrors: Map.of(state.validationErrors)..remove('piecesPerBox'),
      ),
    );
  }

  void boxesPerCartonChanged(String value) {
    final parsed = int.tryParse(value) ?? 0;
    emit(
      state.copyWith(
        product: state.product.copyWith(boxesPerCarton: parsed),
        validationErrors: Map.of(state.validationErrors)..remove('boxesPerCarton'),
      ),
    );
  }

  // ── Ingredient Management ──────────────────────────────────────────────────

  void addIngredient() {
    final updated = List<Ingredient>.from(state.product.ingredients)
      ..add(Ingredient(id: const Uuid().v4(), name: '', quantityPerPiece: 0));
    emit(
      state.copyWith(
        product: state.product.copyWith(ingredients: updated),
        validationErrors: Map.of(state.validationErrors)..remove('ingredients'),
      ),
    );
  }

  /// Selects a canonical ingredient from the catalogue for the row at [index].
  /// Preserves the existing [quantityPerPiece] so the user doesn't lose it.
  void selectIngredient(int index, Ingredient ingredient) {
    final updated = List<Ingredient>.from(state.product.ingredients);
    updated[index] = ingredient.copyWith(quantityPerPiece: updated[index].quantityPerPiece);
    emit(
      state.copyWith(
        product: state.product.copyWith(ingredients: updated),
        validationErrors: Map.of(state.validationErrors)..remove('ingredient_${index}_name'),
      ),
    );
  }

  /// Creates a new ingredient with the typed [name] and assigns it to [index].
  /// The new ingredient is not persisted yet — that happens inside the data
  /// source when the product is saved (upsert-on-write pattern).
  void setIngredientName(int index, String name) {
    final updated = List<Ingredient>.from(state.product.ingredients);
    updated[index] = updated[index].copyWith(name: name);
    emit(
      state.copyWith(
        product: state.product.copyWith(ingredients: updated),
        validationErrors: Map.of(state.validationErrors)..remove('ingredient_${index}_name'),
      ),
    );
  }

  void updateIngredientQuantity(int index, String value) {
    try {
      final parsed = double.tryParse(value) ?? 0;
      final updated = List<Ingredient>.from(state.product.ingredients);
      updated[index] = updated[index].copyWith(quantityPerPiece: parsed);
      emit(state.copyWith(product: state.product.copyWith(ingredients: updated)));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'يجب ان تكون القيمة رقما صحيحا'));
    }
  }

  void removeIngredient(int index, String id) {
    final updated = List<Ingredient>.from(state.product.ingredients)..removeAt(index);
    emit(state.copyWith(product: state.product.copyWith(ingredients: updated)));
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  Map<String, String> _validate() {
    final errors = <String, String>{};
    final product = state.product;

    if (product.name.trim().isEmpty) {
      errors['name'] = 'اسم الصنف مطلوب';
    }

    if (product.piecesPerBox <= 0) {
      errors['piecesPerBox'] = 'عدد القطع يجب أن يكون أكبر من صفر';
    }

    if (product.boxesPerCarton <= 0) {
      errors['boxesPerCarton'] = 'عدد العلب يجب أن يكون أكبر من صفر';
    }

    if (product.ingredients.isEmpty) {
      errors['ingredients'] = 'يجب إضافة مكون واحد على الأقل';
    } else {
      for (int i = 0; i < product.ingredients.length; i++) {
        final ing = product.ingredients[i];
        if (ing.name.trim().isEmpty) {
          errors['ingredient_${i}_name'] = 'اسم المكون مطلوب';
        }
        if (ing.quantityPerPiece <= 0) {
          errors['ingredient_${i}_quantity'] = 'الكمية يجب أن تكون أكبر من صفر';
        }
      }
    }

    return errors;
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  Future<void> saveProduct() async {
    final errors = _validate();

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          validationErrors: errors,
          status: ProductFormStatus.error,
          errorMessage: 'يرجى تصحيح الأخطاء',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ProductFormStatus.submitting));

    final now = DateTime.now();
    final product = state.isEditing
        ? state.product.copyWith(updatedAt: now)
        : state.product.copyWith(id: const Uuid().v4(), createdAt: now, updatedAt: now);

    final result = state.isEditing ? await _updateProduct(product) : await _addProduct(product);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: ProductFormStatus.error, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: ProductFormStatus.success, product: product)),
    );
  }
}
