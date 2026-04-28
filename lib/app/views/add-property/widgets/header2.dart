import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class Header2 extends StatelessWidget {
  const Header2({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sizeService.scalePaddingSymmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isLoading ? null : navigationService.pop,
            child: Container(
              height: sizeService.scaleH(42),
              width: sizeService.scaleW(42),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: sizeService.scaleW(12)),
          Expanded(
            child: Text(
              'Add New Property',
              style: AppTextStyle.base(
                size: 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
