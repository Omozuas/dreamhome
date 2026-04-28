import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';

class AppTextStyle {
  static TextStyle base({
    required double size,
    required Color color,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    bool scale = true,
  }) {
    return GoogleFonts.poppins(
      fontSize: scale ? sizeService.scaleText(size) : size,
      color: color,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  static TextStyle title({Color color = Colors.black}) {
    return base(size: 20, color: color, fontWeight: FontWeight.w600);
  }

  static TextStyle subtitle({Color color = Colors.black54}) {
    return base(size: 16, color: color, fontWeight: FontWeight.w500);
  }

  static TextStyle body({Color color = Colors.black}) {
    return base(size: 14, color: color, fontWeight: FontWeight.w400);
  }

  static TextStyle caption({Color color = Colors.grey}) {
    return base(size: 12, color: color, fontWeight: FontWeight.w400);
  }

  static TextStyle button({Color color = Colors.white}) {
    return base(size: 14, color: color, fontWeight: FontWeight.w600);
  }
}
