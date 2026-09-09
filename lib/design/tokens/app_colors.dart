import 'package:flutter/material.dart';

// LiftIt's dark-first violet identity. Depth comes from this 3-tier
// background scale (bg -> surface -> surfaceElevated) and hairline dividers,
// not drop shadows — see AppMotion/component themes for the one shadow token
// reserved for genuinely floating elements (bottom sheets, rest timer).
class AppColors {
  AppColors._();

  static const darkBackground = Color(0xFF0D0B12);
  static const darkSurface = Color(0xFF12101A);
  static const darkSurfaceElevated = Color(0xFF181520);
  static const darkViolet = Color(0xFF8B5CF6);
  static const darkVioletDark = Color(0xFF6D3FE8);
  static const darkVioletLight = Color(0xFFA78BFA);
  static const darkTextPrimary = Color(0xFFF5F3F7);
  static const darkTextSecondary = Color(0xFFA9A3B2);
  static const darkDivider = Color(0x14FFFFFF); // white @ 8%

  static const lightBackground = Color(0xFFF7F5FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceElevated = Color(0xFFF1EDF7);
  static const lightViolet = Color(0xFF6D3FE8);
  static const lightVioletDark = Color(0xFF5B2FD1);
  static const lightVioletLight = Color(0xFF8B5CF6);
  static const lightTextPrimary = Color(0xFF17131F);
  static const lightTextSecondary = Color(0xFF625C6E);
  static const lightDivider = Color(0x1417131F); // textPrimary @ 8%

  static const success = Color(0xFF4ADE80);
  static const danger = Color(0xFFF87171);
  static const warning = Color(0xFFD9A441);
}

// Semantic token set resolved for the current brightness — read via
// `context.colors` (see app_theme.dart ThemeExtension) instead of branching
// on Theme.of(context).brightness everywhere.
@immutable
class LiftColors extends ThemeExtension<LiftColors> {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color violet;
  final Color violetDark;
  final Color violetLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color success;
  final Color danger;
  final Color warning;

  const LiftColors({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.violet,
    required this.violetDark,
    required this.violetLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.success,
    required this.danger,
    required this.warning,
  });

  static const dark = LiftColors(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceElevated: AppColors.darkSurfaceElevated,
    violet: AppColors.darkViolet,
    violetDark: AppColors.darkVioletDark,
    violetLight: AppColors.darkVioletLight,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    divider: AppColors.darkDivider,
    success: AppColors.success,
    danger: AppColors.danger,
    warning: AppColors.warning,
  );

  static const light = LiftColors(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceElevated: AppColors.lightSurfaceElevated,
    violet: AppColors.lightViolet,
    violetDark: AppColors.lightVioletDark,
    violetLight: AppColors.lightVioletLight,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    divider: AppColors.lightDivider,
    success: AppColors.success,
    danger: AppColors.danger,
    warning: AppColors.warning,
  );

  @override
  LiftColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? violet,
    Color? violetDark,
    Color? violetLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
    Color? success,
    Color? danger,
    Color? warning,
  }) {
    return LiftColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      violet: violet ?? this.violet,
      violetDark: violetDark ?? this.violetDark,
      violetLight: violetLight ?? this.violetLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
    );
  }

  @override
  LiftColors lerp(ThemeExtension<LiftColors>? other, double t) {
    if (other is! LiftColors) return this;
    return LiftColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      violetDark: Color.lerp(violetDark, other.violetDark, t)!,
      violetLight: Color.lerp(violetLight, other.violetLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

extension LiftColorsContext on BuildContext {
  LiftColors get colors => Theme.of(this).extension<LiftColors>()!;
}
