import 'dart:math' as math;

import 'package:flutter/material.dart';

enum DeviceScreen { mobileLayout, tabletLayout, desktopLayout }

class ScreenSizeService {
  double screenWidth = 0;
  double screenHeight = 0;
  double pixelRatio = 1;

  final double figmaWidth;
  final double figmaHeight;

  ScreenSizeService({this.figmaWidth = 440.0, this.figmaHeight = 956.0});

  void updateFromContext(BuildContext context) {
    final mq = MediaQuery.of(context);

    screenWidth = mq.size.width;
    screenHeight = mq.size.height;
    pixelRatio = mq.devicePixelRatio;
  }

  bool get isInitialized => screenWidth > 0 && screenHeight > 0;

  double get widthScale => isInitialized ? screenWidth / figmaWidth : 1;
  double get heightScale => isInitialized ? screenHeight / figmaHeight : 1;

  double get averageScale => (widthScale + heightScale) / 2;

  double scaleW(double value) {
    if (value.isInfinite) return value;
    return value * widthScale;
  }

  double scaleH(double value) {
    if (value.isInfinite) return value;
    return value * heightScale;
  }

  double scaleText(double value) {
    final scaled = value * averageScale;
    return scaled.clamp(value * 0.85, value * 1.25);
  }

  double scaleRadius(double value) {
    final scaled = value * averageScale;
    return scaled.clamp(value * 0.85, value * 1.25);
  }

  double scaleIcon(double value) {
    final scaled = value * averageScale;
    return scaled.clamp(value * 0.85, value * 1.25);
  }

  double scaleSpace(double value) => value * averageScale;

  EdgeInsets scalePaddingAll(double value) {
    return EdgeInsets.all(scaleSpace(value));
  }

  EdgeInsets scalePaddingSymmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: scaleW(horizontal),
      vertical: scaleH(vertical),
    );
  }

  EdgeInsets scalePaddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsets.only(
      left: scaleW(left),
      top: scaleH(top),
      right: scaleW(right),
      bottom: scaleH(bottom),
    );
  }

  BorderRadius scaleBorderRadiusAll(double value) {
    return BorderRadius.circular(scaleRadius(value));
  }

  Radius scaleRadiusCircular(double value) {
    return Radius.circular(scaleRadius(value));
  }

  BoxConstraints scaleBoxConstraints({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) {
    return BoxConstraints(
      minWidth: scaleW(minWidth),
      maxWidth: maxWidth.isInfinite ? maxWidth : scaleW(maxWidth),
      minHeight: scaleH(minHeight),
      maxHeight: maxHeight.isInfinite ? maxHeight : scaleH(maxHeight),
    );
  }

  double scalePx(double logicalPixels) {
    return logicalPixels * pixelRatio;
  }

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = screenWidth;

    if (width >= 1024) return desktop ?? tablet ?? mobile;
    if (width >= 600) return tablet ?? mobile;
    return mobile;
  }

  double clampWidth({
    required double percent,
    double min = 0,
    double max = double.infinity,
  }) {
    final value = screenWidth * percent;
    return math.min(math.max(value, min), max);
  }

  static DeviceScreen getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1024) return DeviceScreen.desktopLayout;
    if (width >= 600) return DeviceScreen.tabletLayout;
    return DeviceScreen.mobileLayout;
  }

  static ScreenInfo getScreenInfo(BuildContext context, BoxConstraints c) {
    final mq = MediaQuery.of(context);

    return ScreenInfo(
      orientation: mq.orientation,
      deviceScreen: getDeviceType(context),
      screenSize: mq.size,
      localWidgetSize: Size(c.maxWidth, c.maxHeight),
    );
  }
}

class ScreenInfo {
  final Orientation orientation;
  final DeviceScreen deviceScreen;
  final Size screenSize;
  final Size localWidgetSize;

  const ScreenInfo({
    required this.orientation,
    required this.deviceScreen,
    required this.screenSize,
    required this.localWidgetSize,
  });

  bool get isMobile => deviceScreen == DeviceScreen.mobileLayout;
  bool get isTablet => deviceScreen == DeviceScreen.tabletLayout;
  bool get isDesktop => deviceScreen == DeviceScreen.desktopLayout;
}
