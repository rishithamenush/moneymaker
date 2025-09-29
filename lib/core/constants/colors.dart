import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Orange Theme (same for both themes)
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryLight = Color(0xFFFF8E53);
  
  // Secondary Colors - Complementary Orange (same for both themes)
  static const Color secondary = Color(0xFFFFA726);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFB74D);
  
  // Status Colors (same for both themes)
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFE17055);
  static const Color info = Color(0xFF74B9FF);
  
  // Category Colors - Orange Theme (same for both themes)
  static const Color autoTransport = Color(0xFFFF6B35);
  static const Color billsUtilities = Color(0xFFFF8E53);
  static const Color foodDining = Color(0xFFE55A2B);
  static const Color entertainment = Color(0xFFFFA726);
  static const Color shopping = Color(0xFFFFB74D);
  static const Color healthcare = Color(0xFF00B894);
  static const Color education = Color(0xFFFF7043);
  static const Color travel = Color(0xFFFFAB40);
}

class LightColors {
  // Light Theme Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class DarkColors {
  // Dark Theme Colors
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2D2D2D);
  static const Color surfaceLight = Color(0xFF3A3A3A);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  
  // Border Colors
  static const Color border = Color(0xFF404040);
  static const Color borderLight = Color(0xFF505050);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
