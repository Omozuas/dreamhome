import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart' hide Image;

class ImageGallerys extends StatelessWidget {
  const ImageGallerys({
    super.key,
    required this.images,
    required this.imageIndex,
    required this.onChanged,
  });

  final List<Image1> images;
  final int imageIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeService.scaleH(360),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.isEmpty ? 1 : images.length,
            onPageChanged: onChanged,
            itemBuilder: (context, index) {
              if (images.isEmpty) {
                return Container(
                  color: AppColors.border,
                  child: Icon(
                    Icons.home_rounded,
                    size: sizeService.scaleIcon(70),
                    color: AppColors.textMuted,
                  ),
                );
              }

              return CachedNetworkImage(
                imageUrl: images[index].url!,
                cacheManager: cacheService.manager,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) {
                  return Container(
                    color: AppColors.border,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
                errorWidget: (_, __, ___) {
                  return Container(
                    color: AppColors.border,
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: sizeService.scaleIcon(48),
                      color: AppColors.textMuted,
                    ),
                  );
                },
              );
            },
          ),

          Positioned(
            bottom: sizeService.scaleH(18),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.isEmpty ? 1 : images.length, (
                index,
              ) {
                final active = index == imageIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: sizeService.scalePaddingSymmetric(horizontal: 3),
                  width: active
                      ? sizeService.scaleW(22)
                      : sizeService.scaleW(7),
                  height: sizeService.scaleH(7),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.white,
                    borderRadius: sizeService.scaleBorderRadiusAll(20),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
