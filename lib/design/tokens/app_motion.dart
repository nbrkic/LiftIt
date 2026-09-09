import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const fast = Duration(milliseconds: 120);
  static const base = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 350);

  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;

  // Reserved for set-completion and PR-confirmation feedback only — kept
  // rare so it stays meaningful instead of becoming decorative bounce.
  static const celebrate = Curves.easeOutBack;
}
