import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class HeaderTop extends StatelessWidget {
  const HeaderTop({super.key, required this.onClear, required this.showClear});

  final VoidCallback onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My DreamHome',
                style: AppTextStyle.base(
                  size: 30,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: sizeService.scaleH(4)),
              Text(
                'Find your perfect property',
                style: AppTextStyle.body(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (showClear)
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: sizeService.scalePaddingSymmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: sizeService.scaleBorderRadiusAll(20),
              ),
              child: Text(
                'Clear',
                style: AppTextStyle.base(
                  size: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
