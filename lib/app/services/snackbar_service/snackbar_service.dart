import 'dart:async';

import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PopupType { success, error, info, warning }

class SnackbarService {
  OverlayEntry? _currentOverlay;
  Timer? _timer;

  Future<void> showErrorPopup({String message = 'Something went wrong'}) {
    return _showPopup(message: message, type: PopupType.error);
  }

  Future<void> showSuccessPopup({String message = 'Success'}) {
    return _showPopup(message: message, type: PopupType.success);
  }

  Future<void> showInfoPopup({String message = 'Info'}) {
    return _showPopup(message: message, type: PopupType.info);
  }

  Future<void> showWarningPopup({String message = 'Warning'}) {
    return _showPopup(message: message, type: PopupType.warning);
  }

  Future<void> _showPopup({
    required String message,
    required PopupType type,
    Duration duration = const Duration(seconds: 3),
  }) async {
    final overlay = navigationService.navigatorKey.currentState?.overlay;

    if (overlay == null) return;

    _removeCurrent();

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return _PopupOverlay(message: message, type: type);
      },
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    _timer = Timer(duration, _removeCurrent);
  }

  void _removeCurrent() {
    _timer?.cancel();
    _timer = null;

    if (_currentOverlay?.mounted ?? false) {
      _currentOverlay?.remove();
    }

    _currentOverlay = null;
  }

  void dispose() {
    _removeCurrent();
  }
}

class _PopupOverlay extends StatelessWidget {
  const _PopupOverlay({required this.message, required this.type});

  final String message;
  final PopupType type;

  Color get _iconColor {
    switch (type) {
      case PopupType.success:
        return AppColors.success;
      case PopupType.error:
        return AppColors.error;
      case PopupType.warning:
        return Colors.orange;
      case PopupType.info:
        return Colors.blue;
    }
  }

  IconData get _icon {
    switch (type) {
      case PopupType.success:
        return CupertinoIcons.check_mark_circled_solid;
      case PopupType.error:
        return CupertinoIcons.xmark_circle_fill;
      case PopupType.warning:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case PopupType.info:
        return CupertinoIcons.info_circle_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -20, end: 0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(opacity: value == 0 ? 1 : 0.85, child: child),
              );
            },
            child: Container(
              margin: sizeService.scalePaddingSymmetric(horizontal: 27),
              padding: sizeService.scalePaddingSymmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  sizeService.scaleRadius(10),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _icon,
                    size: sizeService.scaleIcon(24),
                    color: _iconColor,
                  ),
                  SizedBox(width: sizeService.scaleW(10)),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.base(
                        size: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
