import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/theme_colors.dart';
import '../../providers/theme_provider.dart';

class SettingsPopup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final bool barrierDismissible;
  final bool showBackdrop;

  const SettingsPopup({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
    this.barrierDismissible = true,
    this.showBackdrop = true,
  });

  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? content,
    List<Widget>? actions,
    bool showCloseButton = true,
    VoidCallback? onClose,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    bool barrierDismissible = true,
    bool showBackdrop = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return SettingsPopup(
          title: title,
          subtitle: subtitle,
          content: content,
          actions: actions,
          showCloseButton: showCloseButton,
          onClose: onClose,
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          boxShadow: boxShadow,
          barrierDismissible: barrierDismissible,
          showBackdrop: showBackdrop,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    return Dialog(
      shape: borderRadius as ShapeBorder? ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.9,
        height: height,
        padding: padding ?? const EdgeInsets.all(24),
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? ThemeColors.getSurface(context),
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          border: Border.all(
            color: ThemeColors.getBorder(context).withOpacity(0.1),
            width: 1,
          ),
          boxShadow: boxShadow ?? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.getTextPrimary(context),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: ThemeColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showCloseButton)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ThemeColors.getSurfaceLight(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ThemeColors.getBorder(context).withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (onClose != null) {
                            onClose!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: ThemeColors.getTextSecondary(context),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            if (content != null) ...[
              const SizedBox(height: 20),
              Flexible(child: content!),
            ],
            
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Pre-built action buttons for common use cases
class SettingsPopupActions {
  static Widget cancelButton({
    required BuildContext context,
    VoidCallback? onPressed,
    String text = 'Cancel',
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.getBorder(context).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeColors.getTextSecondary(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget confirmButton({
    required BuildContext context,
    required VoidCallback onPressed,
    String text = 'Confirm',
    Color? backgroundColor,
    Color? textColor,
  }) {
    final themeProvider = context.read<ThemeProvider>();
    final accentColor = backgroundColor ?? ThemeColors.getAccentColor(context, themeProvider.accentColor);
    
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget destructiveButton({
    required BuildContext context,
    required VoidCallback onPressed,
    String text = 'Delete',
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Specialized popup for selection dialogs
class SettingsSelectionPopup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget options;
  final Widget? header;
  final Widget? footer;
  final double? maxHeight;
  final bool showSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;

  const SettingsSelectionPopup({
    super.key,
    required this.title,
    this.subtitle,
    required this.options,
    this.header,
    this.footer,
    this.maxHeight,
    this.showSearch = false,
    this.searchHint,
    this.onSearchChanged,
  });

  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget options,
    Widget? header,
    Widget? footer,
    double? maxHeight,
    bool showSearch = false,
    String? searchHint,
    ValueChanged<String>? onSearchChanged,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SettingsSelectionPopup(
          title: title,
          subtitle: subtitle,
          options: options,
          header: header,
          footer: footer,
          maxHeight: maxHeight,
          showSearch: showSearch,
          searchHint: searchHint,
          onSearchChanged: onSearchChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPopup(
      title: title,
      subtitle: subtitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) ...[
            header!,
            const SizedBox(height: 16),
          ],
          if (showSearch) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ThemeColors.getSurfaceLight(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeColors.getBorder(context).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: searchHint ?? 'Search...',
                  hintStyle: TextStyle(
                    color: ThemeColors.getTextSecondary(context),
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: ThemeColors.getTextSecondary(context),
                    size: 20,
                  ),
                ),
                style: TextStyle(
                  color: ThemeColors.getTextPrimary(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.4,
            ),
            child: options,
          ),
          if (footer != null) ...[
            const SizedBox(height: 16),
            footer!,
          ],
        ],
      ),
      actions: [
        SettingsPopupActions.cancelButton(context: context),
      ],
    );
  }
}
