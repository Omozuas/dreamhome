import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class AmenitiesList extends StatelessWidget {
  const AmenitiesList({super.key, required this.amenities});

  final List<dynamic> amenities;

  @override
  Widget build(BuildContext context) {
    final validAmenities = amenities
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (validAmenities.isEmpty) {
      return Text(
        'No amenities listed',
        style: AppTextStyle.body(color: AppColors.textMuted),
      );
    }

    return Wrap(
      spacing: sizeService.scaleW(8),
      runSpacing: sizeService.scaleH(8),
      children: validAmenities.map((amenity) {
        return Container(
          padding: sizeService.scalePaddingSymmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: sizeService.scaleBorderRadiusAll(30),
            border: Border.all(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: sizeService.scaleIcon(15),
                color: AppColors.primary,
              ),
              SizedBox(width: sizeService.scaleW(5)),
              Text(
                amenity.replaceAll('_', ' '),
                style: AppTextStyle.base(
                  size: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
