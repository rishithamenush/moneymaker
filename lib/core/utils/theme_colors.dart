import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ThemeColors {
  static Color getBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.background 
        : DarkColors.background;
  }

  static Color getSurface(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.surface 
        : DarkColors.surface;
  }

  static Color getSurfaceLight(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.surfaceLight 
        : DarkColors.surfaceLight;
  }

  static Color getTextPrimary(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.textPrimary 
        : DarkColors.textPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.textSecondary 
        : DarkColors.textSecondary;
  }

  static Color getTextTertiary(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.textTertiary 
        : DarkColors.textTertiary;
  }

  static Color getBorder(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.border 
        : DarkColors.border;
  }

  static Color getBorderLight(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.borderLight 
        : DarkColors.borderLight;
  }

  static LinearGradient getPrimaryGradient(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.primaryGradient 
        : DarkColors.primaryGradient;
  }

  static LinearGradient getBackgroundGradient(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.backgroundGradient 
        : DarkColors.backgroundGradient;
  }

  // Accent Color Methods
  static Color getAccentColor(BuildContext context, String accentName) {
    return AccentColors.getAccentColor(accentName);
  }

  static Color getAccentColorDark(BuildContext context, String accentName) {
    return AccentColors.getAccentColorDark(accentName);
  }

  static Color getAccentColorLight(BuildContext context, String accentName) {
    return AccentColors.getAccentColorLight(accentName);
  }

  static LinearGradient getAccentGradient(BuildContext context, String accentName) {
    final color = getAccentColor(context, accentName);
    final lightColor = getAccentColorLight(context, accentName);
    return LinearGradient(
      colors: [color, lightColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Color getCardBackground(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.surface 
        : DarkColors.surface;
  }

  static Color getBorderColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light 
        ? LightColors.border 
        : DarkColors.border;
  }
}
