import 'package:dreamhome/app/common/app_shimmer.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class PropertyDetailShimmer extends StatelessWidget {
  const PropertyDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    return AppShimmer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: sizeService.scaleH(350), color: AppColors.border),

            Padding(
              padding: sizeService.scalePaddingAll(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line(width: 120, height: 20),
                  SizedBox(height: sizeService.scaleH(12)),
                  _line(width: double.infinity, height: 16),
                  SizedBox(height: sizeService.scaleH(8)),
                  _line(width: 200, height: 14),

                  SizedBox(height: sizeService.scaleH(20)),

                  Row(
                    children: [
                      Expanded(child: _box()),
                      SizedBox(width: sizeService.scaleW(10)),
                      Expanded(child: _box()),
                    ],
                  ),

                  SizedBox(height: sizeService.scaleH(20)),

                  _line(width: double.infinity, height: 14),
                  SizedBox(height: sizeService.scaleH(6)),
                  _line(width: double.infinity, height: 14),
                  SizedBox(height: sizeService.scaleH(6)),
                  _line(width: 250, height: 14),

                  SizedBox(height: sizeService.scaleH(30)),

                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: sizeService.scaleW(10)),
                      Expanded(child: _line(width: 150, height: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(width: width, height: height, color: AppColors.border);
  }

  Widget _box() {
    return Container(height: sizeService.scaleH(50), color: AppColors.border);
  }
}
