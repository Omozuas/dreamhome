import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sizeService.scalePaddingSymmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: sizeService.scaleBorderRadiusAll(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: sizeService.scaleIcon(15), color: AppColors.primary),
          SizedBox(width: sizeService.scaleW(4)),
          Text(
            text,
            style: AppTextStyle.base(
              size: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
