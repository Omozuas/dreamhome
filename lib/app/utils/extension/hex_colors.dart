import 'dart:ui';

extension HexColor on String {
  Color get toColor {
    final cleanHex = replaceAll('#', '');
    return Color(int.parse('FF$cleanHex', radix: 16));
  }
}
