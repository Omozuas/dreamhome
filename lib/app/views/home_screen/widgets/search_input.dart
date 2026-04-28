import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search property, area, city...',
        hintStyle: AppTextStyle.body(color: AppColors.textMuted),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: sizeService.scalePaddingSymmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: sizeService.scaleBorderRadiusAll(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
