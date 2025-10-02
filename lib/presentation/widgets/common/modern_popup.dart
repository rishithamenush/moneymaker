import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/theme_provider.dart';

class ModernPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;
  final Color? buttonColor;
  final bool isDismissible;

  const ModernPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.buttonColor,
    this.isDismissible = true,
  });

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
    Color? buttonColor,
    bool isDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return ModernPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
          icon: icon,
          iconColor: iconColor,
          buttonColor: buttonColor,
          isDismissible: isDismissible,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    final finalIconColor = iconColor ?? accentColor;
    final finalButtonColor = buttonColor ?? accentColor;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ThemeColors.getBorder(context).withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: finalIconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: finalIconColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon ?? Icons.info_outline_rounded,
                color: finalIconColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: ThemeColors.getTextSecondary(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Container(
                decoration: BoxDecoration(
                  color: finalButtonColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: finalButtonColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPressed ?? () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        buttonText ?? 'OK',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const ErrorPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ModernPopup(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      buttonColor: AppColors.error,
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ErrorPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      },
    );
  }
}

class SuccessPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const SuccessPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ModernPopup(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.success,
      buttonColor: AppColors.success,
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SuccessPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      },
    );
  }
}

class InfoPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const InfoPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ModernPopup(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.info_outline_rounded,
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return InfoPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      },
    );
  }
}

class WarningPopup extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const WarningPopup({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ModernPopup(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.warning_outlined,
      iconColor: Colors.orange,
      buttonColor: Colors.orange,
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WarningPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      },
    );
  }
}

// Utility class to prevent multiple clicks
class PopupUtils {
  static bool _isShowing = false;

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    if (_isShowing) return;
    _isShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ErrorPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: () {
            _isShowing = false;
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed();
            }
          },
        );
      },
    ).then((_) {
      // Ensure _isShowing is reset when dialog is dismissed by any means
      _isShowing = false;
    });
  }

  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    if (_isShowing) return;
    _isShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SuccessPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: () {
            _isShowing = false;
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed();
            }
          },
        );
      },
    ).then((_) {
      // Ensure _isShowing is reset when dialog is dismissed by any means
      _isShowing = false;
    });
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    if (_isShowing) return;
    _isShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return InfoPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: () {
            _isShowing = false;
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed();
            }
          },
        );
      },
    ).then((_) {
      // Ensure _isShowing is reset when dialog is dismissed by any means
      _isShowing = false;
    });
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    if (_isShowing) return;
    _isShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WarningPopup(
          title: title,
          message: message,
          buttonText: buttonText,
          onPressed: () {
            _isShowing = false;
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed();
            }
          },
        );
      },
    ).then((_) {
      // Ensure _isShowing is reset when dialog is dismissed by any means
      _isShowing = false;
    });
  }

  static void reset() {
    _isShowing = false;
  }
}
