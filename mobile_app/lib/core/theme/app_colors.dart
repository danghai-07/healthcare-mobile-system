import 'package:flutter/material.dart';

/// Healthcare SaaS color tokens.
///
/// Calm, trustworthy palette inspired by modern health & productivity apps.
abstract final class AppColors {
  // ─── Brand (teal from CareWell logo) ─────────────────────────────────────
  static const Color primary = Color(0xFF009688);
  static const Color primaryDark = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFFB2DFDB);

  /// Soft brand tint for hero sections and highlighted surfaces.
  static const Color primaryMuted = Color(0xFFE0F2F1);

  /// Hover / pressed state for primary actions.
  static const Color primaryHover = Color(0xFF00897B);

  // ─── Semantic ────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E8B57);
  static const Color successLight = Color(0xFFE6F4EC);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ─── Surfaces ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F6F4);
  static const Color surfaceVariant = Color(0xFFEEF2F0);

  // ─── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ─── Borders & dividers ──────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD1D5DB);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color focusRing = Color(0xFF009688);

  // ─── Accent (complementary calm tone) ───────────────────────────────────
  static const Color secondary = Color(0xFF5B7C99);
  static const Color secondaryLight = Color(0xFFE8EEF4);

  // ─── Overlays ───────────────────────────────────────────────────────────
  static const Color scrim = Color(0x991F2937);
  static const Color shadow = Color(0xFF1F2937);
  static const Color shadowBrand = Color(0xFF009688);

  // ─── Legacy aliases (Material on-colors) ─────────────────────────────────
  static const Color onPrimary = textOnPrimary;
  static const Color onSecondary = textOnPrimary;
  static const Color onError = textOnPrimary;
  static const Color onSurface = textPrimary;
}

/// 4 px base spacing scale (Notion / Linear inspired).
abstract final class AppSpacing {
  static const double unit = 4;

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: xxl,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}

/// Border-radius tokens for a soft, friendly SaaS feel.
abstract final class AppRadius {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;

  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
  static const BorderRadius chip = BorderRadius.all(Radius.circular(full));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
}

/// Layered elevation shadows — subtle, premium, never harsh.
abstract final class AppShadows {
  static List<BoxShadow> get none => const [];

  static List<BoxShadow> get xs => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get sm => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: AppColors.shadowBrand.withValues(alpha: 0.03),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get md => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.shadowBrand.withValues(alpha: 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get lg => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.shadowBrand.withValues(alpha: 0.05),
          blurRadius: 40,
          offset: const Offset(0, 16),
        ),
      ];

  static List<BoxShadow> get xl => [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.10),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: AppColors.shadowBrand.withValues(alpha: 0.06),
          blurRadius: 64,
          offset: const Offset(0, 24),
        ),
      ];
}
