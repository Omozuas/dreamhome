import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sizeService.scalePaddingOnly(bottom: 14),
      child: Text(
        title,
        style: AppTextStyle.base(
          size: 21,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
