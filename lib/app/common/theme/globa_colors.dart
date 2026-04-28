import 'dart:ui';

import 'package:dreamhome/app/utils/extension/hex_colors.dart';

class AppColors {
  AppColors._();

  static final Color primary = '#EC6C10'.toColor;

  // Variants (VERY IMPORTANT for UI)
  static final Color primaryLight = '#F28A3A'.toColor;
  static final Color primaryDark = '#C2550D'.toColor;

  // Status (align with brand)
  static final Color success = '#54C234'.toColor;
  static final Color error = '#C00000'.toColor;
  static final Color warning = primary;

  // Neutral
  static final Color black = '#000000'.toColor;
  static final Color white = '#FFFFFF'.toColor;
  static final Color background = '#F5F7F9'.toColor;

  // Text
  static final Color textPrimary = black;
  static final Color textSecondary = '#444444'.toColor;
  static final Color textMuted = '#8A8A8A'.toColor;
  static final Color textOnPrimary = white;

  // Borders
  static final Color border = '#E5E7EB'.toColor;
}
