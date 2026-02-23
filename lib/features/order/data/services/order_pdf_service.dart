import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/saved_order.dart';
import '../../../calculator/domain/entities/calculation_result.dart';

class OrderPdfService {
  /// Generates a PDF for the given [order] and opens the system share sheet.
  Future<void> generateAndShare(SavedOrder order) async {
    final pdf = pw.Document();

    // Load Arabic font from bundled assets
    final fontData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/NotoSansArabic-Bold.ttf');
    final arabicFont = pw.Font.ttf(fontData);
    final arabicBoldFont = pw.Font.ttf(boldData);

    final baseStyle = pw.TextStyle(font: arabicFont, fontSize: 10);
    final boldStyle = pw.TextStyle(font: arabicBoldFont, fontSize: 10);
    final headerStyle = pw.TextStyle(font: arabicBoldFont, fontSize: 16);
    final subHeaderStyle = pw.TextStyle(font: arabicBoldFont, fontSize: 12);

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // ── Title
          pw.Center(child: pw.Text(order.name, style: headerStyle)),
          pw.SizedBox(height: 6),
          pw.Center(
            child: pw.Text(
              '${order.orderDate.year}/${order.orderDate.month.toString().padLeft(2, '0')}/${order.orderDate.day.toString().padLeft(2, '0')}',
              style: baseStyle,
            ),
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Center(child: pw.Text(order.notes!, style: baseStyle)),
          ],
          pw.SizedBox(height: 12),

          // ── Summary row
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              _summaryCell('إجمالي القطع', _fmt(order.totalPieces), baseStyle, boldStyle),
              _summaryCell(
                'إجمالي الوزن',
                '${order.totalWeightKg.toStringAsFixed(1)} كجم',
                baseStyle,
                boldStyle,
              ),
              _summaryCell('عدد المنتجات', order.items.length.toString(), baseStyle, boldStyle),
            ],
          ),
          pw.Divider(),
          pw.SizedBox(height: 8),

          // ── Phase 1: Per-product tables
          pw.Text('Phase 1 — تفاصيل كل منتج', style: subHeaderStyle),
          pw.SizedBox(height: 6),

          ...order.items.asMap().entries.expand((entry) {
            final idx = entry.key + 1;
            final item = entry.value;
            return [
              pw.Text(
                '$idx. ${item.productName}  (${item.cartonCount} كرتون  •  ${_fmt(item.totalPieces)} قطعة)',
                style: boldStyle,
              ),
              pw.SizedBox(height: 4),
              pw.TableHelper.fromTextArray(
                headerStyle: boldStyle,
                cellStyle: baseStyle,
                cellAlignment: pw.Alignment.centerRight,
                headerAlignment: pw.Alignment.centerRight,
                headers: ['المكون', 'لكل قطعة (غ)', 'المطلوب (كجم)'],
                data: item.materials
                    .map(
                      (m) => [
                        m.ingredientName,
                        '${m.perPieceGrams}',
                        m.requiredKg.toStringAsFixed(2),
                      ],
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 10),
            ];
          }),

          pw.Divider(),
          pw.SizedBox(height: 8),

          // ── Phase 2: Aggregated
          pw.Text('Phase 2 — المواد الخام المجمعة', style: subHeaderStyle),
          pw.SizedBox(height: 6),

          pw.TableHelper.fromTextArray(
            headerStyle: boldStyle,
            cellStyle: baseStyle,
            cellAlignment: pw.Alignment.centerRight,
            headerAlignment: pw.Alignment.centerRight,
            headers: ['المكون', 'الكمية الإجمالية (كجم)'],
            data: _aggregate(
              order,
            ).map((m) => [m.ingredientName, m.requiredKg.toStringAsFixed(2)]).toList(),
          ),
        ],
      ),
    );

    // Write to temp & share
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/order_${order.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], title: order.name));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  pw.Widget _summaryCell(String label, String value, pw.TextStyle base, pw.TextStyle bold) {
    return pw.Column(
      children: [
        pw.Text(value, style: bold),
        pw.SizedBox(height: 2),
        pw.Text(label, style: base),
      ],
    );
  }

  List<MaterialRequirement> _aggregate(SavedOrder order) {
    final Map<String, MaterialRequirement> agg = {};
    for (final item in order.items) {
      for (final m in item.materials) {
        final key = m.ingredientId.isNotEmpty ? m.ingredientId : m.ingredientName;
        if (agg.containsKey(key)) {
          agg[key] = MaterialRequirement(
            ingredientId: m.ingredientId,
            ingredientName: m.ingredientName,
            perPieceGrams: agg[key]!.perPieceGrams,
            requiredKg: agg[key]!.requiredKg + m.requiredKg,
          );
        } else {
          agg[key] = m;
        }
      }
    }
    return agg.values.toList();
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
