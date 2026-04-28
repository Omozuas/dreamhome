import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class OwnerCard extends StatelessWidget {
  const OwnerCard({super.key, required this.property});

  final PropertyResponedModel property;

  @override
  Widget build(BuildContext context) {
    final owner = property.owner;
    final user = owner?.user;

    final profileImage = user?.profileImage?.url ?? owner?.selfieUrl?.url;
    final name =
        user?.fullName ??
        '${owner?.firstName ?? ''} ${owner?.lastName ?? ''}'.trim();

    return Container(
      padding: sizeService.scalePaddingAll(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: sizeService.scaleBorderRadiusAll(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: sizeService.scaleRadius(30),
            // ignore: deprecated_member_use
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: profileImage != null && profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : null,
            child: profileImage == null || profileImage.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: sizeService.scaleIcon(30),
                  )
                : null,
          ),

          SizedBox(width: sizeService.scaleW(14)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Unknown Agent' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.base(
                    size: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: sizeService.scaleH(4)),

                Text(
                  owner?.companyName ?? 'Independent Agent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.caption(color: AppColors.textMuted),
                ),

                SizedBox(height: sizeService.scaleH(6)),

                Text(
                  user?.phoneNumber ?? 'No phone number',
                  style: AppTextStyle.base(
                    size: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
