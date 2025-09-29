import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';

class LineChartWidget extends StatelessWidget {
  final List<Expense> expenses;

  const LineChartWidget({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No data to display',
          style: TextStyle(
            color: ThemeColors.getTextSecondary(context),
            fontSize: 16,
          ),
        ),
      );
    }

    final dailyData = _getDailyData();
    final maxAmount = dailyData.isNotEmpty 
        ? dailyData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 100.0;

    return Column(
      children: [
        Text(
          'Daily Spending Trend',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: maxAmount / 5,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: ThemeColors.getSurfaceLight(context),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: ThemeColors.getSurfaceLight(context),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < dailyData.length) {
                        return Text(
                          '${value.toInt() + 1}',
                          style: TextStyle(
                            color: ThemeColors.getTextSecondary(context),
                            fontSize: 10,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: maxAmount / 5,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        'LKR ${value.toInt()}',
                        style: TextStyle(
                          color: ThemeColors.getTextSecondary(context),
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: ThemeColors.getSurfaceLight(context),
                  width: 1,
                ),
              ),
              minX: 0,
              maxX: dailyData.length.toDouble() - 1,
              minY: 0,
              maxY: maxAmount * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: dailyData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.amount);
                  }).toList(),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: ThemeColors.getBackground(context),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DailyData> _getDailyData() {
    final Map<int, double> dailyTotals = {};
    
    for (final expense in expenses) {
      final day = expense.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
    }
    
    return dailyTotals.entries
        .map((entry) => DailyData(day: entry.key, amount: entry.value))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));
  }
}

class DailyData {
  final int day;
  final double amount;

  DailyData({
    required this.day,
    required this.amount,
  });
}
