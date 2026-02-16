import 'package:flutter/material.dart';

/// Application color palette extracted from the HTML design.
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF135BEC);
  static const Color primaryDark = Color(0xFF0E45B5);

  // ── Backgrounds ──
  static const Color backgroundLight = Color(0xFFF6F6F8);
  static const Color backgroundDark = Color(0xFF101622);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF151B2B);
  static const Color surfaceDarkAlt = Color(0xFF1A2233);
  static const Color inputDark = Color(0xFF1E2533);

  // ── Text ──
  static const Color textPrimary = Color(0xFF0F172A); // slate-900
  static const Color textSecondary = Color(0xFF64748B); // slate-500
  static const Color textTertiary = Color(0xFF94A3B8); // slate-400
  static const Color textDarkPrimary = Colors.white;
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  static const Color textDarkTertiary = Color(0xFF64748B);

  // ── Borders ──
  static const Color borderLight = Color(0xFFF1F5F9); // slate-100
  static const Color borderDark = Color(0xFF1E293B); // slate-800
  static const Color ringLight = Color(0xFFE2E8F0); // slate-200
  static const Color ringDark = Color(0xFF334155); // slate-700

  // ── Danger ──
  static const Color danger = Color(0xFFEF4444); // red-500

  // ── Status Badges ──
  static const Color statusAvailableBg = Color(0xFFDCFCE7); // green-100
  static const Color statusAvailableText = Color(0xFF15803D); // green-700
  static const Color statusAvailableBgDark = Color(0x4D166534); // green-900/30
  static const Color statusAvailableTextDark = Color(0xFF4ADE80); // green-400

  static const Color statusLowStockBg = Color(0xFFFFEDD5); // orange-100
  static const Color statusLowStockText = Color(0xFFC2410C); // orange-700
  static const Color statusLowStockBgDark = Color(0x4D9A3412); // orange-900/30
  static const Color statusLowStockTextDark = Color(0xFFFB923C); // orange-400

  static const Color statusArchivedBg = Color(0xFFF1F5F9); // slate-100
  static const Color statusArchivedText = Color(0xFF475569); // slate-600
  static const Color statusArchivedBgDark = Color(0xFF334155); // slate-700
  static const Color statusArchivedTextDark = Color(0xFFCBD5E1); // slate-300

  // ── Card ──
  static const Color cardDark = Color(0xFF1E293B); // slate-800
  static const Color cardBorderDark = Color(0x80334155); // slate-700/50
  static const Color iconBgLight = Color(0xFFF8FAFC); // slate-50
  static const Color iconBgDark = Color(0xFF334155); // slate-700

  // ── Accent ──
  static const Color success = Color(0xFF22C55E); // green-500
  static const Color successLight = Color(0xFFDCFCE7); // green-100
  static const Color successDark = Color(0xFF166534); // green-800
  static const Color successTextDark = Color(0xFF4ADE80); // green-400
  static const Color warning = Color(0xFFF97316); // orange-500
}
