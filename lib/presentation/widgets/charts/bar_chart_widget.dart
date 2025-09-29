import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/category.dart';
import '../../providers/theme_provider.dart';

class BarChartWidget extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;

  const BarChartWidget({
    super.key,
    required this.expenses,
    required this.categories,
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

    final categoryData = _getCategoryData();
    final maxAmount = categoryData.isNotEmpty 
        ? categoryData.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 100.0;

    return Column(
      children: [
        Text(
          'Monthly Spending by Category',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxAmount * 1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: ThemeColors.getSurfaceLight(context),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      'LKR ${rod.toY.toStringAsFixed(0)}',
                      TextStyle(
                        color: ThemeColors.getTextPrimary(context),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
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
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < categoryData.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            categoryData[value.toInt()].name,
                            style: TextStyle(
                              color: ThemeColors.getTextSecondary(context),
                              fontSize: 10,
                            ),
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
              borderData: FlBorderData(show: false),
              barGroups: categoryData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.amount,
                      color: data.color,
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<CategoryData> _getCategoryData() {
    final Map<String, double> categoryTotals = {};
    
    for (final expense in expenses) {
      categoryTotals[expense.categoryId] = 
          (categoryTotals[expense.categoryId] ?? 0) + expense.amount;
    }
    
    return categoryTotals.entries.map((entry) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(
          id: entry.key,
          name: 'Unknown',
          iconName: 'help',
          colorValue: AppColors.primary.value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      
      return CategoryData(
        name: category.name,
        amount: entry.value,
        color: Color(category.colorValue),
      );
    }).toList();
  }
}

class CategoryData {
  final String name;
  final double amount;
  final Color color;

  CategoryData({
    required this.name,
    required this.amount,
    required this.color,
  });
}
