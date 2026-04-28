import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.text, this.light = false});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sizeService.scalePaddingSymmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: light ? AppColors.primary.withOpacity(0.1) : AppColors.primary,
        borderRadius: sizeService.scaleBorderRadiusAll(30),
      ),
      child: Text(
        text.replaceAll('_', ' '),
        style: AppTextStyle.base(
          size: 12,
          color: light ? AppColors.primary : AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
