import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = value.isEmpty ? null : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.subtitle(color: AppColors.textSecondary),
        ),
        SizedBox(height: sizeService.scaleH(8)),
        DropdownButtonFormField<String>(
          initialValue: selected,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: sizeService.scalePaddingSymmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: sizeService.scaleBorderRadiusAll(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: sizeService.scaleBorderRadiusAll(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: sizeService.scaleBorderRadiusAll(10),
              borderSide: BorderSide(color: AppColors.primary, width: 1.3),
            ),
          ),
          hint: Text(
            hint,
            style: AppTextStyle.body(color: AppColors.textMuted),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.replaceAll('_', ' '),
                style: AppTextStyle.body(color: AppColors.textPrimary),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please select $label';
            return null;
          },
        ),
      ],
    );
  }
}
