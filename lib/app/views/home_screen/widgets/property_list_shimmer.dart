import 'package:dreamhome/app/common/app_shimmer.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class PropertyListShimmer extends StatelessWidget {
  const PropertyListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, _) {
        return AppShimmer(
          child: Container(
            margin: sizeService.scalePaddingOnly(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: sizeService.scaleBorderRadiusAll(20),
            ),
            child: Column(
              children: [
                Container(
                  height: sizeService.scaleH(200),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.vertical(
                      top: sizeService.scaleRadiusCircular(20),
                    ),
                  ),
                ),

                Padding(
                  padding: sizeService.scalePaddingAll(16),
                  child: Column(
                    children: [
                      _line(width: double.infinity, height: 14),
                      SizedBox(height: sizeService.scaleH(10)),
                      _line(width: 150, height: 12),
                      SizedBox(height: sizeService.scaleH(14)),
                      Row(
                        children: [
                          Expanded(child: _box()),
                          SizedBox(width: sizeService.scaleW(10)),
                          Expanded(child: _box()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(width: width, height: height, color: AppColors.border);
  }

  Widget _box() {
    return Container(height: sizeService.scaleH(40), color: AppColors.border);
  }
}
