import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class ContactAgentField extends StatelessWidget {
  const ContactAgentField({super.key, required this.property});

  final PropertyResponedModel property;

  @override
  Widget build(BuildContext context) {
    final phone = property.owner?.user?.phoneNumber ?? 'Not available';
    final company = property.owner?.companyName ?? 'Independent Agent';

    return Container(
      padding: sizeService.scalePaddingAll(16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: sizeService.scaleBorderRadiusAll(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.phone_in_talk_rounded,
            color: AppColors.primary,
            size: sizeService.scaleIcon(28),
          ),
          SizedBox(width: sizeService.scaleW(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.base(
                    size: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: sizeService.scaleH(4)),
                Text(
                  phone,
                  style: AppTextStyle.caption(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
