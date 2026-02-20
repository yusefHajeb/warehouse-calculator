import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/ingredient.dart';

/// A row inside the Add/Edit Product form that represents one ingredient.
///
/// Shows an autocomplete picker (backed by [allIngredients]) for the name,
/// and a numeric field for the quantity in grams per piece.
class IngredientRow extends StatefulWidget {
  const IngredientRow({
    super.key,
    this.nameValue,
    this.weightValue,
    this.nameError,
    this.quantityError,
    this.allIngredients = const [],
    this.onIngredientSelected,
    this.onNameTyped,
    this.onWeightChanged,
    this.onDelete,
  });

  final String? nameValue;
  final String? weightValue;
  final String? nameError;
  final String? quantityError;

  /// Full catalogue — used to power the autocomplete dropdown.
  final List<Ingredient> allIngredients;

  /// Called when the user selects an existing ingredient from the dropdown.
  final ValueChanged<Ingredient>? onIngredientSelected;

  /// Called when the user types a completely new ingredient name.
  final ValueChanged<String>? onNameTyped;
  final ValueChanged<String>? onWeightChanged;
  final VoidCallback? onDelete;

  @override
  State<IngredientRow> createState() => _IngredientRowState();
}

class _IngredientRowState extends State<IngredientRow> {
  late TextEditingController _nameController;
  late TextEditingController _weightController;

  // Cache decorated borders so they are not recreated every build.
  // Re-built only when the error state or theme changes.
  InputDecoration? _cachedNameDecoration;
  InputDecoration? _cachedWeightDecoration;
  bool? _lastIsDark;
  bool? _lastNameHasError;
  bool? _lastWeightHasError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.nameValue ?? '');
    _weightController = TextEditingController(text: widget.weightValue ?? '');
  }

  @override
  void didUpdateWidget(covariant IngredientRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only sync from outside when the external value actually changed AND it
    // differs from what the controller holds — prevents stomping in-progress edits.
    if (oldWidget.nameValue != widget.nameValue && widget.nameValue != _nameController.text) {
      _nameController.value = TextEditingValue(
        text: widget.nameValue ?? '',
        selection: TextSelection.collapsed(offset: (widget.nameValue ?? '').length),
      );
    }

    if (oldWidget.weightValue != widget.weightValue &&
        widget.weightValue != _weightController.text) {
      _weightController.value = TextEditingValue(
        text: widget.weightValue ?? '',
        selection: TextSelection.collapsed(offset: (widget.weightValue ?? '').length),
      );
    }

    // Invalidate decoration cache when error state changes.
    if (oldWidget.nameError != widget.nameError) _cachedNameDecoration = null;
    if (oldWidget.quantityError != widget.quantityError) _cachedWeightDecoration = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // ── Decoration builders — cached so they survive rebuilds cheaply ──────────

  InputDecoration _nameDecoration(bool isDark) {
    if (_cachedNameDecoration != null &&
        _lastIsDark == isDark &&
        _lastNameHasError == (widget.nameError != null)) {
      return _cachedNameDecoration!;
    }
    _lastIsDark = isDark;
    _lastNameHasError = widget.nameError != null;
    _cachedNameDecoration = InputDecoration(
      hintText: AppStrings.ingredientNameHint,
      filled: true,
      fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDark ? AppColors.ringDark : AppColors.ringLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.nameError != null
              ? AppColors.danger
              : (isDark ? AppColors.ringDark : AppColors.ringLight),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
    return _cachedNameDecoration!;
  }

  InputDecoration _weightDecoration(bool isDark) {
    if (_cachedWeightDecoration != null &&
        _lastIsDark == isDark &&
        _lastWeightHasError == (widget.quantityError != null)) {
      return _cachedWeightDecoration!;
    }
    _lastWeightHasError = widget.quantityError != null;
    _cachedWeightDecoration = InputDecoration(
      hintText: AppStrings.weightHint,
      filled: true,
      fillColor: isDark ? AppColors.inputDark : AppColors.surfaceLight,
      contentPadding: const EdgeInsets.only(right: 12, left: 28, top: 14, bottom: 14),
      suffixIcon: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: Text(
          AppStrings.gramSymbol,
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDark ? AppColors.ringDark : AppColors.ringLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.quantityError != null
              ? AppColors.danger
              : (isDark ? AppColors.ringDark : AppColors.ringLight),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
    return _cachedWeightDecoration!;
  }

  // ── Autocomplete options — filtered once per query string, not per build ───

  Iterable<Ingredient> _buildOptions(TextEditingValue textEditingValue) {
    final query = textEditingValue.text.trim().toLowerCase();
    if (query.isEmpty) return const Iterable<Ingredient>.empty();
    return widget.allIngredients.where((ing) => ing.name.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Autocomplete ingredient name ──────────────────────────────
            Expanded(
              child: Autocomplete<Ingredient>(
                initialValue: TextEditingValue(text: widget.nameValue ?? ''),
                displayStringForOption: (ing) => ing.name,
                optionsBuilder: _buildOptions,
                onSelected: (ingredient) {
                  // Update our local controller first so the field view is
                  // in sync before the cubit rebuild arrives.
                  _nameController.value = TextEditingValue(
                    text: ingredient.name,
                    selection: TextSelection.collapsed(offset: ingredient.name.length),
                  );
                  widget.onIngredientSelected?.call(ingredient);
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200, maxWidth: 260),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            ...options.map(
                              (ing) => InkWell(
                                onTap: () => onSelected(ing),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.label_outline_rounded,
                                        size: 14,
                                        color: isDark
                                            ? AppColors.textDarkTertiary
                                            : AppColors.textTertiary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          ing.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark
                                                ? AppColors.textDarkPrimary
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (context, autoController, focusNode, _) {
                  // Keep the Autocomplete's internal controller in sync with
                  // ours WITHOUT touching it during build (no side-effects in
                  // build). We do this once after the first frame and whenever
                  // our controller changes via a post-frame callback.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    if (autoController.text != _nameController.text) {
                      autoController.value = TextEditingValue(
                        text: _nameController.text,
                        selection: TextSelection.collapsed(offset: _nameController.text.length),
                      );
                    }
                  });

                  return TextFormField(
                    controller: autoController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      _nameController.text = value;
                      widget.onNameTyped?.call(value);
                    },
                    decoration: _nameDecoration(isDark),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // ── Grams per piece ───────────────────────────────────────────
            SizedBox(
              width: 96,
              child: TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                onChanged: widget.onWeightChanged,
                decoration: _weightDecoration(isDark),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // ── Delete ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: AppColors.textTertiary,
                splashRadius: 20,
                tooltip: AppStrings.delete,
              ),
            ),
          ],
        ),

        // Error messages
        if (widget.nameError != null || widget.quantityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.nameError ?? widget.quantityError ?? '',
              style: const TextStyle(fontSize: 11, color: AppColors.danger),
            ),
          ),
      ],
    );
  }
}
