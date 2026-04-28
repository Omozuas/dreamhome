import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';

class ReadMoreText extends StatelessWidget {
  const ReadMoreText({
    super.key,
    required this.text,
    required this.expanded,
    required this.onTap,
  });

  final String text;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shouldShowButton = text.length > 140;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: expanded ? null : 4,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: AppTextStyle.body(
            color: AppColors.textSecondary,
          ).copyWith(height: 1.6),
        ),
        if (shouldShowButton) ...[
          SizedBox(height: sizeService.scaleH(8)),
          GestureDetector(
            onTap: onTap,
            child: Text(
              expanded ? 'Read less' : 'Read more',
              style: AppTextStyle.base(
                size: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
