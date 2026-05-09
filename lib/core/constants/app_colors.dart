import 'package:flutter/material.dart';

/// Palette warna utama aplikasi task_pbm
/// Dominan Biru Terang — Modern, Profesional, Bersih
class AppColors {
  AppColors._();

  // ── Primary Blue ──────────────────────────────────────
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryContainer = Color(0xFFBBDEFB);

  // ── Background ────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundAlt = Color(0xFFEBF4FF);

  // ── Surface / Card ────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // ── Accent (Amber) ────────────────────────────────────
  static const Color accent = Color(0xFFFFC107);
  static const Color accentDark = Color(0xFFF57F17);
  static const Color accentLight = Color(0xFFFFECB3);

  // ── Text Colors ───────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Functional Colors ─────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  // ── Misc ──────────────────────────────────────────────
  static const Color divider = Color(0xFFE2E8F0);
  static const Color cardShadow = Color(0x142196F3);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // ── Gradients ─────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEBF4FF), Color(0xFFF8FAFC)],
  );
}
