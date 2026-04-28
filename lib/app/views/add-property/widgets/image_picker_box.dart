import 'dart:io';
import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class ImagePickerBox extends StatelessWidget {
  const ImagePickerBox({
    super.key,
    required this.images,
    required this.onPick,
    required this.onRemove,
  });

  final List<File> images;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: double.infinity,
            padding: sizeService.scalePaddingSymmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: sizeService.scaleBorderRadiusAll(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_rounded,
                  color: AppColors.primary,
                  size: sizeService.scaleIcon(38),
                ),
                SizedBox(height: sizeService.scaleH(8)),
                Text(
                  'Upload Images',
                  style: AppTextStyle.base(
                    size: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: sizeService.scaleH(4)),
                Text(
                  'Maximum 6 images',
                  style: AppTextStyle.caption(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
        if (images.isNotEmpty) ...[
          SizedBox(height: sizeService.scaleH(14)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: sizeService.scaleW(10),
              mainAxisSpacing: sizeService.scaleH(10),
            ),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: sizeService.scaleBorderRadiusAll(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(images[index], fit: BoxFit.cover),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => onRemove(index),
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
