import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.getBackground(context),
      elevation: 0,
      toolbarHeight: AppDimensions.appBarHeight,
      titleSpacing: 0,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: ThemeColors.getTextPrimary(context),
                size: AppDimensions.iconS, // Reduced from iconM to iconS
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              padding: const EdgeInsets.all(8), // Reduced padding
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: ThemeColors.getTextPrimary(context),
          fontSize: 18, // Reduced from 20 to 18
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: actions?.map((action) {
        if (action is IconButton) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4), // Reduced padding
            child: action,
          );
        }
        return action;
      }).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}
