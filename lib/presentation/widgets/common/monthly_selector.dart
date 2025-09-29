import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../core/utils/formatters.dart';

class MonthlySelector extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const MonthlySelector({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Formatters.formatMonthYear(selectedMonth),
            style: TextStyle(
              color: ThemeColors.getTextPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  final previousMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month - 1,
                  );
                  onMonthChanged(previousMonth);
                },
                icon: Icon(
                  Icons.chevron_left,
                  color: ThemeColors.getTextSecondary(context),
                ),
              ),
              IconButton(
                onPressed: () {
                  final nextMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month + 1,
                  );
                  onMonthChanged(nextMonth);
                },
                icon: Icon(
                  Icons.chevron_right,
                  color: ThemeColors.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
