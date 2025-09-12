import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/budget.dart';
import '../../../domain/entities/category.dart';
import '../../providers/expense_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/monthly_selector.dart';
import '../../widgets/charts/pie_chart_widget.dart';
import '../../widgets/charts/bar_chart_widget.dart';
import '../../widgets/charts/line_chart_widget.dart';
import '../../widgets/common/monthly_summary.dart';
import '../../widgets/common/spending_trends.dart';
import '../../navigation/bottom_nav_bar.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().loadExpenses();
      context.read<BudgetProvider>().loadBudgets();
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: AppStrings.overview,
        showBackButton: false,
      ),
      body: Consumer3<ExpenseProvider, BudgetProvider, CategoryProvider>(
        builder: (context, expenseProvider, budgetProvider, categoryProvider, child) {
          if (expenseProvider.isLoading || budgetProvider.isLoading || categoryProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          final monthlyExpenses = expenseProvider.getExpensesByMonth(_selectedMonth);
          final monthlyBudgets = budgetProvider.getBudgetsByMonth(_selectedMonth);
          final totalSpent = expenseProvider.getTotalExpensesByMonth(_selectedMonth);
          final totalBudget = budgetProvider.getTotalBudgetAmountByMonth(_selectedMonth);
          final categories = categoryProvider.categories;

          return Column(
            children: [
              // Month Selector
              MonthlySelector(
                selectedMonth: _selectedMonth,
                onMonthChanged: (month) {
                  setState(() {
                    _selectedMonth = month;
                  });
                },
              ),
              
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'Summary'),
                    Tab(text: 'Charts'),
                    Tab(text: 'Trends'),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Summary Tab
                    _buildSummaryTab(
                      monthlyExpenses: monthlyExpenses,
                      monthlyBudgets: monthlyBudgets,
                      totalSpent: totalSpent,
                      totalBudget: totalBudget,
                      categories: categories,
                    ),
                    // Charts Tab
                    _buildChartsTab(
                      monthlyExpenses: monthlyExpenses,
                      categories: categories,
                    ),
                    // Trends Tab
                    _buildTrendsTab(
                      monthlyExpenses: monthlyExpenses,
                      monthlyBudgets: monthlyBudgets,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildSummaryTab({
    required List<Expense> monthlyExpenses,
    required List<Budget> monthlyBudgets,
    required double totalSpent,
    required double totalBudget,
    required List<Category> categories,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        children: [
          // Monthly Summary Card
          MonthlySummary(
            totalSpent: totalSpent,
            totalBudget: totalBudget,
            remainingAmount: totalBudget - totalSpent,
            spentPercentage: totalBudget > 0 ? totalSpent / totalBudget : 0.0,
          ),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Category Breakdown
          _buildCategoryBreakdown(monthlyExpenses, categories),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Quick Stats
          _buildQuickStats(monthlyExpenses, monthlyBudgets),
        ],
      ),
    );
  }

  Widget _buildChartsTab({
    required List<Expense> monthlyExpenses,
    required List<Category> categories,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        children: [
          // Pie Chart
          Container(
            height: 300,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: PieChartWidget(
              expenses: monthlyExpenses,
              categories: categories,
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Bar Chart
          Container(
            height: 300,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: BarChartWidget(
              expenses: monthlyExpenses,
              categories: categories,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab({
    required List<Expense> monthlyExpenses,
    required List<Budget> monthlyBudgets,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        children: [
          // Spending Trends
          SpendingTrends(
            expenses: monthlyExpenses,
            budgets: monthlyBudgets,
          ),
          
          const SizedBox(height: AppDimensions.paddingL),
          
          // Line Chart
          Container(
            height: 300,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: LineChartWidget(
              expenses: monthlyExpenses,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(List<Expense> expenses, List<Category> categories) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Breakdown',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          ...categories.map<Widget>((category) {
            final categoryExpenses = expenses.where((e) => e.categoryId == category.id).toList();
            final categoryTotal = categoryExpenses.fold<double>(0.0, (sum, e) => sum + e.amount);
            final percentage = expenses.isNotEmpty 
                ? categoryTotal / expenses.fold<double>(0.0, (sum, e) => sum + e.amount) 
                : 0.0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(category.colorValue),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '\$${categoryTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Text(
                    '${(percentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuickStats(List<Expense> expenses, List<Budget> budgets) {
    final avgDailySpending = expenses.isNotEmpty 
        ? expenses.fold<double>(0.0, (sum, e) => sum + e.amount) / 30 
        : 0.0;
    final totalTransactions = expenses.length;
    final overBudgetCategories = budgets.where((b) => b.isOverBudget).length;
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Daily Average',
            value: '\$${avgDailySpending.toStringAsFixed(0)}',
            icon: Icons.trending_up,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: _buildStatCard(
            title: 'Transactions',
            value: totalTransactions.toString(),
            icon: Icons.receipt,
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: _buildStatCard(
            title: 'Over Budget',
            value: overBudgetCategories.toString(),
            icon: Icons.warning,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimensions.iconL,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
