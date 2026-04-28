import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/views/home_screen/widgets/amount_box.dart';
import 'package:dreamhome/app/views/home_screen/widgets/info_chip.dart';
import 'package:dreamhome/app/views/home_screen/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({super.key, required this.property, required this.onTap});

  final PropertyResponedModel property;
  final VoidCallback onTap;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _imageIndex = 0;

  String get _location {
    final location = widget.property.location;
    final parts = [
      location?.address,
      location?.city,
      location?.state,
    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');

    return parts.isEmpty ? 'No location added' : parts;
  }

  String _money(num? value) {
    final amount = value ?? 0;
    return '₦${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final images = property.images
        .where((e) => e.url != null && e.url!.isNotEmpty)
        .toList();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: sizeService.scalePaddingOnly(bottom: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: sizeService.scaleBorderRadiusAll(22),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: AppColors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: sizeService.scaleRadiusCircular(22),
              ),
              child: SizedBox(
                height: sizeService.scaleH(210),
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: images.isEmpty ? 1 : images.length,
                      onPageChanged: (index) {
                        setState(() => _imageIndex = index);
                      },
                      itemBuilder: (context, index) {
                        if (images.isEmpty) {
                          return Container(
                            color: AppColors.border,
                            child: Icon(
                              Icons.home_rounded,
                              size: sizeService.scaleIcon(56),
                              color: AppColors.textMuted,
                            ),
                          );
                        }

                        return CachedNetworkImage(
                          imageUrl: images[index].url!,
                          cacheManager: cacheService.manager,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, _) {
                            return Container(
                              color: AppColors.border,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorWidget: (_, _, _) {
                            return Container(
                              color: AppColors.border,
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: AppColors.textMuted,
                                size: sizeService.scaleIcon(36),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    Positioned(
                      top: sizeService.scaleH(12),
                      left: sizeService.scaleW(12),
                      child: StatusBadge(text: property.status ?? 'Property'),
                    ),

                    Positioned(
                      top: sizeService.scaleH(12),
                      right: sizeService.scaleW(12),
                      child: Container(
                        padding: sizeService.scalePaddingSymmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: AppColors.black.withOpacity(0.55),
                          borderRadius: sizeService.scaleBorderRadiusAll(30),
                        ),
                        child: Text(
                          '${_imageIndex + 1}/${images.isEmpty ? 1 : images.length}',
                          style: AppTextStyle.caption(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: sizeService.scalePaddingAll(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title ?? 'Untitled Property',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.base(
                      size: 18,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: sizeService.scaleH(8)),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: sizeService.scaleIcon(17),
                        color: AppColors.primary,
                      ),
                      SizedBox(width: sizeService.scaleW(4)),
                      Expanded(
                        child: Text(
                          _location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.caption(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sizeService.scaleH(14)),

                  Row(
                    children: [
                      Expanded(
                        child: AmountBox(
                          title: 'Property Price',
                          value: _money(property.price),
                        ),
                      ),
                      SizedBox(width: sizeService.scaleW(10)),
                      Expanded(
                        child: AmountBox(
                          title: 'Agent Fee',
                          value: _money(property.agentFee),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sizeService.scaleH(12)),

                  Row(
                    children: [
                      InfoChip(
                        icon: Icons.bed_rounded,
                        text: '${property.bedrooms ?? 0} Beds',
                      ),
                      SizedBox(width: sizeService.scaleW(8)),
                      InfoChip(
                        icon: Icons.bathtub_rounded,
                        text: '${property.bathrooms ?? 0} Baths',
                      ),
                      SizedBox(width: sizeService.scaleW(8)),
                      InfoChip(
                        icon: Icons.square_foot_rounded,
                        text: '${property.size ?? 0} sqm',
                      ),
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
}
