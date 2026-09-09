import 'package:flutter/material.dart';

// Deliberately restrained: most surfaces are sharp or barely rounded. Larger
// radii are reserved for the few elements meant to feel like they're
// floating (bottom sheets, the single primary CTA) — see design system notes
// in the redesign plan for which components use which value.
class AppRadius {
  AppRadius._();

  static const none = 0.0;
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 24.0;

  static const noneRadius = BorderRadius.zero;
  static const smRadius = BorderRadius.all(Radius.circular(sm));
  static const mdRadius = BorderRadius.all(Radius.circular(md));
  static const lgRadius = BorderRadius.all(Radius.circular(lg));
  static const sheetTopRadius = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
}
