import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class AmenitiesSelector extends StatelessWidget {
  const AmenitiesSelector({
    super.key,
    required this.amenities,
    required this.selected,
    required this.onToggle,
  });

  final List<String> amenities;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: sizeService.scaleW(8),
      runSpacing: sizeService.scaleH(8),
      children: amenities.map((amenity) {
        final isSelected = selected.contains(amenity);

        return GestureDetector(
          onTap: () => onToggle(amenity),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: sizeService.scalePaddingSymmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.white,
              borderRadius: sizeService.scaleBorderRadiusAll(30),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              amenity.replaceAll('_', ' '),
              style: AppTextStyle.base(
                size: 12,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
