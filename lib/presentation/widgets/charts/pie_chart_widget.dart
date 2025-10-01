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
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
          child: Text(
            'Spending Summary',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Chart
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: categoryData.map((data) {
                return PieChartSectionData(
                  color: data.color,
                  value: data.percentage,
                  title: '${(data.percentage * 100).toStringAsFixed(0)}%',
                  radius: 70,
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
        // Legend
        Padding(
          padding: const EdgeInsets.only(top: AppDimensions.paddingM),
          child: _buildLegend(categoryData, context),
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
      spacing: AppDimensions.paddingL,
      runSpacing: AppDimensions.paddingM,
      alignment: WrapAlignment.center,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeColors.getBorder(context).withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Text(
              item.name,
              style: TextStyle(
                color: ThemeColors.getTextSecondary(context),
                fontSize: 12,
                fontWeight: FontWeight.w500,
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
