import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/products_header.dart';
import '../widgets/product_card.dart';

/// Manage Products list page — static presentation only.
///
/// Mirrors the HTML design: header with title, notification bell,
/// search bar, scrollable product cards, and a floating "+" button.
class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      floatingActionButton: const _AddProductFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            const ProductsHeader(),

            // ── Product list ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: const [
                  ProductCard(
                    name: 'تمر',
                    packagingInfo: 'سمسم',
                    itemCode: '#٨٨٣٢-أ',
                    lastUpdate: 'منذ ساعتين',
                    status: ProductStatus.available,
                  ),
                  SizedBox(height: 12),
                  ProductCard(
                    name: 'منظف شديد التحمل',
                    packagingInfo: '٢٤ عبوة/كرتون • ٥٠ كرتون/منصة',
                    itemCode: '#HD-٢٠٠',
                    lastUpdate: 'منذ يوم',
                  ),
                  SizedBox(height: 12),
                  ProductCard(
                    name: 'دهان لامع ممتاز',
                    packagingInfo: '٤ جالون/صندوق • ١٢ صندوق/طبقة',
                    itemCode: '#PG-٥٥٠',
                    lastUpdate: 'منذ ٣ أيام',
                    status: ProductStatus.lowStock,
                  ),
                  SizedBox(height: 12),
                  ProductCard(
                    name: 'قفازات سلامة (كبير جداً)',
                    packagingInfo: '١٠٠ زوج/صندوق • ٢٠ صندوق/كرتون',
                    itemCode: '#SF-GL-XL',
                    lastUpdate: 'منذ أسبوع',
                    status: ProductStatus.archived,
                    isArchived: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating action button for adding a new product.
class _AddProductFab extends StatelessWidget {
  const _AddProductFab();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to Add Product in Phase 2
        },
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
      ),
    );
  }
}
