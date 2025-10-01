import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../app/routes.dart';
import '../providers/theme_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        border: Border(
          top: BorderSide(
            color: ThemeColors.getBorder(context).withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        minimum: EdgeInsets.zero,
        child: Container(
          height: 70.0, // WhatsApp-style height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: AppStrings.overview,
                index: 0,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: AppStrings.thisMonth,
                index: 1,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: AppStrings.settings,
                index: 2,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = currentIndex == index;
    final accentColor = ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isSelected) return;
          _navigateToPage(context, index);
        },
        child: Container(
          height: 70.0,
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isSelected ? 6.0 : 4.0),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? accentColor 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey(isSelected ? 'active_$index' : 'inactive_$index'),
                    color: isSelected 
                        ? Colors.white 
                        : ThemeColors.getTextSecondary(context),
                    size: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected 
                      ? accentColor 
                      : ThemeColors.getTextSecondary(context),
                  fontSize: 11.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
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
