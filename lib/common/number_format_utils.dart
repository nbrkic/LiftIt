// A goal stored in ml displays as liters (friendlier to read/type than a
// 4-digit ml number) without a pointless trailing ".0" on whole numbers.
String formatLiters(int ml) {
  final liters = ml / 1000;
  return liters == liters.roundToDouble() ? liters.toInt().toString() : liters.toString();
}
