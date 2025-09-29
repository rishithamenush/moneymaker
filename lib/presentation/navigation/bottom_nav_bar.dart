import 'package:flutter/material.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../app/routes.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        border: Border(
          top: BorderSide(
            color: ThemeColors.getSurfaceLight(context),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.bar_chart,
            label: AppStrings.overview,
            index: 0,
            context: context,
          ),
          _buildNavItem(
            icon: Icons.calendar_today,
            label: AppStrings.thisMonth,
            index: 1,
            context: context,
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: AppStrings.settings,
            index: 2,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (isSelected) return; // Avoid redundant navigation causing flicker
        _navigateToPage(context, index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : ThemeColors.getTextSecondary(context),
              size: AppDimensions.iconS,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : ThemeColors.getTextSecondary(context),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    // Remove any pending focus to avoid keyboard flicker
    FocusScope.of(context).unfocus();

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.overview,
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.settings,
        );
        break;
    }
  }
}
