import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/budget.dart';
import '../../providers/theme_provider.dart';

class SpendingTrends extends StatelessWidget {
  final List<Expense> expenses;
  final List<Budget> budgets;

  const SpendingTrends({
    super.key,
    required this.expenses,
    required this.budgets,
  });

  @override
  Widget build(BuildContext context) {
    final weeklyData = _getWeeklyData();
    final monthlyComparison = _getMonthlyComparison();
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trends',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          
          // Weekly Breakdown
          _buildWeeklyBreakdown(weeklyData, context),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Monthly Comparison
          _buildMonthlyComparison(monthlyComparison, context),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Insights
          _buildInsights(context),
        ],
      ),
    );
  }

  Widget _buildWeeklyBreakdown(List<WeeklyData> weeklyData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        ...weeklyData.map<Widget>((data) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    data.day,
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: ThemeColors.getSurfaceLight(context),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: data.percentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Text(
                  Formatters.formatCurrency(data.amount, currencyCode: context.read<ThemeProvider>().currency),
                  style: TextStyle(
                    color: ThemeColors.getTextPrimary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMonthlyComparison(Map<String, double> comparison, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Comparison',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Row(
          children: [
            Expanded(
              child: _buildComparisonCard(
                title: 'This Month',
                amount: comparison['current'] ?? 0.0,
                color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                context: context,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: _buildComparisonCard(
                title: 'Last Month',
                amount: comparison['previous'] ?? 0.0,
                color: ThemeColors.getTextSecondary(context),
                context: context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required double amount,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: ThemeColors.getSurfaceLight(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: ThemeColors.getTextSecondary(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            Formatters.formatCurrency(amount, currencyCode: context.read<ThemeProvider>().currency),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(BuildContext context) {
    final totalSpent = expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
    final avgDaily = totalSpent / 30;
    final overBudgetCategories = budgets.where((b) => b.isOverBudget).length;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                size: 20,
              ),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'Insights',
                style: TextStyle(
                  color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            'Your average daily spending is ${Formatters.formatCurrency(avgDaily, currencyCode: context.read<ThemeProvider>().currency)}. ${overBudgetCategories > 0 ? 'You have $overBudgetCategories categories over budget.' : 'Great job staying within budget!'}',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(context),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<WeeklyData> _getWeeklyData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final Map<String, double> dailyTotals = {};
    
    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayName = _getDayName(day.weekday);
      dailyTotals[dayName] = 0.0;
    }
    
    for (final expense in expenses) {
      if (expense.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(weekStart.add(const Duration(days: 7)))) {
        final dayName = _getDayName(expense.date.weekday);
        dailyTotals[dayName] = (dailyTotals[dayName] ?? 0) + expense.amount;
      }
    }
    
    final maxAmount = dailyTotals.values.fold(0.0, (a, b) => a > b ? a : b);
    
    return dailyTotals.entries.map((entry) {
      return WeeklyData(
        day: entry.key,
        amount: entry.value,
        percentage: maxAmount > 0 ? entry.value / maxAmount : 0.0,
      );
    }).toList();
  }

  Map<String, double> _getMonthlyComparison() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final previousMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    final previousYear = currentMonth == 1 ? now.year - 1 : now.year;
    
    double currentTotal = 0.0;
    double previousTotal = 0.0;
    
    for (final expense in expenses) {
      if (expense.date.month == currentMonth && expense.date.year == now.year) {
        currentTotal += expense.amount;
      } else if (expense.date.month == previousMonth && expense.date.year == previousYear) {
        previousTotal += expense.amount;
      }
    }
    
    return {
      'current': currentTotal,
      'previous': previousTotal,
    };
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

class WeeklyData {
  final String day;
  final double amount;
  final double percentage;

  WeeklyData({
    required this.day,
    required this.amount,
    required this.percentage,
  });
}
