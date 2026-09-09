import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Two-family system: Space Grotesk carries display/headings/all numeric
// training data (weights, reps, PRs, volume, duration) so numbers get their
// own visual register instead of blending into body copy. Manrope carries
// body/labels/buttons — legible, geometric-adjacent to Space Grotesk so the
// pairing reads as one family, without being the ubiquitous "default AI app"
// font. Both have full Latin Extended-A coverage for Serbian č/ć/š/ž/đ.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primary, Color secondary) {
    TextStyle display(double size, FontWeight weight, Color color, {double? letterSpacing}) =>
        GoogleFonts.spaceGrotesk(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: letterSpacing,
          height: 1.05,
        );
    TextStyle body(double size, FontWeight weight, Color color, {double? letterSpacing}) =>
        GoogleFonts.manrope(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: letterSpacing,
          height: 1.35,
        );

    return TextTheme(
      displayLarge: display(52, FontWeight.w600, primary, letterSpacing: -1),
      displayMedium: display(40, FontWeight.w600, primary, letterSpacing: -0.5),
      displaySmall: display(32, FontWeight.w600, primary),
      headlineLarge: display(28, FontWeight.w600, primary),
      headlineMedium: display(24, FontWeight.w600, primary),
      headlineSmall: display(20, FontWeight.w600, primary),
      titleLarge: display(18, FontWeight.w600, primary),
      titleMedium: body(16, FontWeight.w700, primary),
      titleSmall: body(14, FontWeight.w700, primary),
      bodyLarge: body(16, FontWeight.w500, primary),
      bodyMedium: body(14, FontWeight.w500, primary),
      bodySmall: body(12, FontWeight.w500, secondary),
      labelLarge: body(14, FontWeight.w700, primary, letterSpacing: 0.2),
      labelMedium: body(12, FontWeight.w700, secondary, letterSpacing: 0.6),
      labelSmall: body(11, FontWeight.w700, secondary, letterSpacing: 0.6),
    );
  }

  // Tabular-figure numeral style for the big-number stat block and any
  // aligned numeric columns (set rows). Not part of TextTheme because it
  // needs explicit sizes per use, not semantic slots.
  static TextStyle numeral({
    required double size,
    required Color color,
    FontWeight weight = FontWeight.w600,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.0,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
