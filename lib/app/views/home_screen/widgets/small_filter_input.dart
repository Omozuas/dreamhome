import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class SmallFilterInput extends StatelessWidget {
  const SmallFilterInput({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeService.scaleH(52),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: AppTextStyle.base(
          size: 13,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyle.base(size: 12, color: AppColors.textMuted),
          prefixIcon: Icon(
            icon,
            size: sizeService.scaleIcon(18),
            color: AppColors.primary,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: sizeService.scaleW(36),
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: sizeService.scalePaddingSymmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: sizeService.scaleBorderRadiusAll(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
