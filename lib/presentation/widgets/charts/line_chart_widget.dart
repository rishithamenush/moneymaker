import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';
import '../../providers/theme_provider.dart';
import '../../../l10n/app_localizations.dart';

class LineChartWidget extends StatefulWidget {
  final List<Expense> expenses;

  const LineChartWidget({
    super.key,
    required this.expenses,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  bool isWeeklyView = false;

  @override
  Widget build(BuildContext context) {
    if (widget.expenses.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noData,
          style: TextStyle(
            color: ThemeColors.getTextSecondary(context),
            fontSize: 16,
          ),
        ),
      );
    }

    final chartData = isWeeklyView ? _getWeeklyData() : _getDailyData();
    final maxAmount = chartData.isNotEmpty 
        ? chartData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 100.0;
    
    // Calculate better intervals for Y-axis
    final yInterval = _calculateYInterval(maxAmount);
    final yMax = (maxAmount / yInterval).ceil() * yInterval;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left-aligned header layout
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isWeeklyView ? AppLocalizations.of(context)!.weeklySpendingTrend : AppLocalizations.of(context)!.dailySpendingTrend,
                style: TextStyle(
                  color: ThemeColors.getTextPrimary(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggleButton(
                    context,
                    AppLocalizations.of(context)!.daily,
                    !isWeeklyView,
                    () => setState(() => isWeeklyView = false),
                  ),
                  const SizedBox(width: 8),
                  _buildToggleButton(
                    context,
                    AppLocalizations.of(context)!.weekly,
                    isWeeklyView,
                    () => setState(() => isWeeklyView = true),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: yInterval,
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
                      if (value.toInt() < chartData.length) {
                        final data = chartData[value.toInt()];
                        return Text(
                          isWeeklyView ? '${AppLocalizations.of(context)!.week} ${data.week}' : '${AppLocalizations.of(context)!.day} ${data.day}',
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
                    reservedSize: 60,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        _formatCurrency(value),
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
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: ThemeColors.getSurface(context),
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final index = touchedSpot.x.toInt();
                      if (index < chartData.length) {
                        final data = chartData[index];
                        final label = isWeeklyView ? '${AppLocalizations.of(context)!.week} ${data.week}' : '${AppLocalizations.of(context)!.day} ${data.day}';
                        return LineTooltipItem(
                          '$label\n${_formatCurrency(data.amount)}',
                          TextStyle(
                            color: ThemeColors.getTextPrimary(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return null;
                    }).toList();
                  },
                ),
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                        strokeWidth: 2,
                      ),
                      FlDotData(
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                            strokeWidth: 3,
                            strokeColor: ThemeColors.getBackground(context),
                          );
                        },
                      ),
                    );
                  }).toList();
                },
              ),
              minX: 0,
              maxX: chartData.length.toDouble() - 1,
              minY: 0,
              maxY: yMax,
              lineBarsData: [
                LineChartBarData(
                  spots: chartData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.amount);
                  }).toList(),
                  isCurved: true,
                  color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                        strokeWidth: 2,
                        strokeColor: ThemeColors.getBackground(context),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor)
              : ThemeColors.getSurfaceLight(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : ThemeColors.getTextSecondary(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  List<ChartData> _getDailyData() {
    final Map<int, double> dailyTotals = {};
    
    for (final expense in widget.expenses) {
      final day = expense.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
    }
    
    return dailyTotals.entries
        .map((entry) => ChartData(day: entry.key, week: 0, amount: entry.value))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));
  }

  List<ChartData> _getWeeklyData() {
    final Map<int, double> weeklyTotals = {};
    
    for (final expense in widget.expenses) {
      // Calculate week number based on the month
      final weekNumber = ((expense.date.day - 1) / 7).floor() + 1;
      weeklyTotals[weekNumber] = (weeklyTotals[weekNumber] ?? 0) + expense.amount;
    }
    
    return weeklyTotals.entries
        .map((entry) => ChartData(day: 0, week: entry.key, amount: entry.value))
        .toList()
      ..sort((a, b) => a.week.compareTo(b.week));
  }

  double _calculateYInterval(double maxAmount) {
    if (maxAmount <= 0) return 1000;
    
    // Calculate appropriate interval based on max amount
    final magnitude = (maxAmount / 5).floor().toString().length;
    final baseInterval = maxAmount / 5;
    
    if (baseInterval <= 100) {
      return 100;
    } else if (baseInterval <= 500) {
      return 500;
    } else if (baseInterval <= 1000) {
      return 1000;
    } else if (baseInterval <= 2500) {
      return 2500;
    } else if (baseInterval <= 5000) {
      return 5000;
    } else if (baseInterval <= 10000) {
      return 10000;
    } else {
      return (baseInterval / 10000).ceil() * 10000;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return 'LKR ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'LKR ${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return 'LKR ${value.toInt()}';
    }
  }
}

class ChartData {
  final int day;
  final int week;
  final double amount;

  ChartData({
    required this.day,
    required this.week,
    required this.amount,
  });
}
