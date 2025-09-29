import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/category.dart';
import '../../providers/theme_provider.dart';

class PieChartWidget extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;

  const PieChartWidget({
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
    
    return Column(
      children: [
        Text(
          'Spending by Category',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: categoryData.map((data) {
                return PieChartSectionData(
                  color: data.color,
                  value: data.percentage,
                  title: '${(data.percentage * 100).toStringAsFixed(0)}%',
                  radius: 80,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.getTextPrimary(context),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        _buildLegend(categoryData, context),
      ],
    );
  }

  List<CategoryData> _getCategoryData() {
    final Map<String, double> categoryTotals = {};
    
    for (final expense in expenses) {
      categoryTotals[expense.categoryId] = 
          (categoryTotals[expense.categoryId] ?? 0) + expense.amount;
    }
    
    final totalAmount = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);
    
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
        percentage: totalAmount > 0 ? entry.value / totalAmount : 0.0,
        color: Color(category.colorValue),
      );
    }).toList();
  }

  Widget _buildLegend(List<CategoryData> data, BuildContext context) {
    return Wrap(
      spacing: AppDimensions.paddingM,
      runSpacing: AppDimensions.paddingS,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Text(
              item.name,
              style: TextStyle(
                color: ThemeColors.getTextSecondary(context),
                fontSize: 12,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class CategoryData {
  final String name;
  final double amount;
  final double percentage;
  final Color color;

  CategoryData({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}
