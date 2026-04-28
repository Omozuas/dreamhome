import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum InputVariant { outlined, filled }

class CustomInput extends StatefulWidget {
  const CustomInput({
    super.key,
    required this.placeholder,
    required this.controller,
    this.variant = InputVariant.outlined,
    this.radius = 8.0,
    this.errorText,
    this.label,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.iconPath,
    this.leftIconPath,
    this.onTap,
    this.inputFormatters,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  final String placeholder;
  final InputVariant variant;
  final double radius;
  final String? errorText;
  final TextEditingController controller;
  final String? label;
  final int maxLines;
  final int? minLines;
  final String? iconPath;
  final String? leftIconPath;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final FocusNode _focusNode;

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        sizeService.scaleRadius(widget.radius),
      ),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  OutlineInputBorder _noBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        sizeService.scaleRadius(widget.radius),
      ),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOutlined = widget.variant == InputVariant.outlined;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.trim().isNotEmpty) ...[
          Text(
            widget.label!,
            style: AppTextStyle.subtitle(color: AppColors.textSecondary),
          ),
          SizedBox(height: sizeService.scaleH(8)),
        ],
        TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          validator: widget.validator,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          obscureText: widget.obscureText,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          cursorColor: AppColors.primary,
          style: AppTextStyle.body(color: AppColors.textPrimary),
          decoration: InputDecoration(
            errorText: widget.errorText,
            filled: widget.variant == InputVariant.filled,
            fillColor: widget.variant == InputVariant.filled
                ? AppColors.background
                : AppColors.white,
            hintText: widget.placeholder,
            hintStyle: AppTextStyle.body(color: AppColors.textMuted),
            errorStyle: AppTextStyle.caption(color: AppColors.error),
            contentPadding: sizeService.scalePaddingSymmetric(
              vertical: 12,
              horizontal: 14,
            ),
            border: isOutlined
                ? _border(_hasError ? AppColors.error : AppColors.border, 1)
                : _noBorder(),
            enabledBorder: isOutlined
                ? _border(_hasError ? AppColors.error : AppColors.border, 1)
                : _noBorder(),
            focusedBorder: isOutlined
                ? _border(_hasError ? AppColors.error : AppColors.primary, 1.3)
                : _noBorder(),
            errorBorder: _border(AppColors.error, 1),
            focusedErrorBorder: _border(AppColors.error, 1.3),
            disabledBorder: isOutlined
                ? _border(AppColors.background, 1)
                : _noBorder(),
            prefixIcon: widget.leftIconPath != null
                ? Padding(
                    padding: sizeService.scalePaddingAll(12),
                    child: SvgPicture.asset(
                      widget.leftIconPath!,
                      width: sizeService.scaleW(20),
                      height: sizeService.scaleH(20),
                    ),
                  )
                : null,
            suffixIcon: widget.iconPath != null
                ? Padding(
                    padding: sizeService.scalePaddingAll(12),
                    child: SvgPicture.asset(
                      widget.iconPath!,
                      width: sizeService.scaleW(20),
                      height: sizeService.scaleH(20),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
