import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ButtonVariant { primary, disabled, secondary, transparent }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.iconPath2,
    this.variant = ButtonVariant.primary,
    this.radius = 8,
    this.vertical = 12,
    this.horizontal = 16,
    this.height = 50,
    this.fontSize = 16,
    this.isLoading = false,
  });

  final String text;
  final String? iconPath;
  final String? iconPath2;
  final ButtonVariant variant;
  final double radius;
  final VoidCallback? onPressed;
  final double vertical;
  final double horizontal;
  final double height;
  final double fontSize;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = variant == ButtonVariant.disabled || onPressed == null;

    final Color backgroundColor = switch (variant) {
      ButtonVariant.primary => AppColors.primary,
      ButtonVariant.secondary => AppColors.background,
      ButtonVariant.transparent => Colors.transparent,
      ButtonVariant.disabled => AppColors.background,
    };

    final Color textColor = switch (variant) {
      ButtonVariant.primary => AppColors.white,
      ButtonVariant.secondary => AppColors.black,
      ButtonVariant.transparent => AppColors.primary,
      ButtonVariant.disabled => AppColors.border,
    };

    return GestureDetector(
      onTap: isLoading || isDisabled ? null : onPressed,
      child: Container(
        height: sizeService.scaleH(height),
        padding: sizeService.scalePaddingSymmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        decoration: BoxDecoration(
          color: isLoading ? AppColors.background : backgroundColor,
          borderRadius: BorderRadius.circular(sizeService.scaleRadius(radius)),
          border: variant == ButtonVariant.transparent
              ? Border.all(color: AppColors.primary)
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: sizeService.scaleW(22),
                  height: sizeService.scaleH(22),
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: sizeService.scaleW(3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconPath2 != null) ...[
                      SvgPicture.asset(
                        iconPath2!,
                        height: sizeService.scaleH(20),
                        width: sizeService.scaleW(20),
                      ),
                      SizedBox(width: sizeService.scaleW(6)),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.base(
                          size: fontSize,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (iconPath != null) ...[
                      SizedBox(width: sizeService.scaleW(6)),
                      SvgPicture.asset(
                        iconPath!,
                        height: sizeService.scaleH(20),
                        width: sizeService.scaleW(20),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
