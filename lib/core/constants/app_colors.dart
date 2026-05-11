import 'package:flutter/material.dart';

/// Palette warna Neo-Brutalism + Comic Book
/// Tebal, berani, ekspresif — seperti halaman komik yang hidup!
class AppColors {
  AppColors._();

  // ── Primary (Kuning Komik) ────────────────────────────
  static const Color primary = Color(0xFFFFD600);       // Kuning bold
  static const Color primaryDark = Color(0xFFF9A825);   // Kuning tua
  static const Color primaryLight = Color(0xFFFFF176);  // Kuning muda
  static const Color primaryContainer = Color(0xFFFFF8E1);

  // ── Accent (Cyan Listrik) ─────────────────────────────
  static const Color accent = Color(0xFF00E5FF);
  static const Color accentDark = Color(0xFF00B8D4);
  static const Color accentLight = Color(0xFFE0FAFF);

  // ── Red (Aksi Komik) ─────────────────────────────────
  static const Color comicRed = Color(0xFFFF3D00);
  static const Color comicRedLight = Color(0xFFFFEBE0);

  // ── Background (Cream Komik) ──────────────────────────
  static const Color background = Color(0xFFFFF9F0);    // Cream warm
  static const Color backgroundAlt = Color(0xFFFFEFCC);

  // ── Surface / Card ────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF9F0);

  // ── Ink (Teks Hitam Komik) ────────────────────────────
  static const Color ink = Color(0xFF0D0D0D);           // Hitam tinta komik
  static const Color inkMedium = Color(0xFF2D2D2D);
  static const Color inkLight = Color(0xFF555555);

  // ── Text Colors ───────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D0D0D);
  static const Color textSecondary = Color(0xFF444444);
  static const Color textHint = Color(0xFF888888);
  static const Color textOnPrimary = Color(0xFF0D0D0D);  // Hitam di atas kuning

  // ── Functional Colors ─────────────────────────────────
  static const Color error = Color(0xFFFF3D00);
  static const Color errorLight = Color(0xFFFFEBE0);
  static const Color success = Color(0xFF00C853);
  static const Color successLight = Color(0xFFD4F8E8);
  static const Color warning = Color(0xFFFFAB00);
  static const Color warningLight = Color(0xFFFFF3CC);

  // ── Brutalism Core ───────────────────────────────────
  static const Color border = Color(0xFF0D0D0D);         // Border hitam tebal
  static const Color shadow = Color(0xFF0D0D0D);         // Shadow solid (no blur)
  static const Color divider = Color(0xFF0D0D0D);        // Divider hitam

  // ── Misc ─────────────────────────────────────────────
  static const Color cardShadow = Color(0xFF0D0D0D);
  static const Color shimmerBase = Color(0xFFE8E0D0);
  static const Color shimmerHighlight = Color(0xFFFFF9F0);

  // ── Comic Panel Colors ────────────────────────────────
  static const Color panelBlue = Color(0xFF1565C0);
  static const Color panelPink = Color(0xFFFF4081);
  static const Color panelGreen = Color(0xFF00C853);
  static const Color panelPurple = Color(0xFF7C4DFF);

  // ── Gradients (jarang dipakai di brutalism, tapi untuk splash) ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD600), Color(0xFFFF3D00)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF9F0), Color(0xFFFFEFCC)],
  );
}
