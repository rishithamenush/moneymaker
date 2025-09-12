import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../providers/expense_provider.dart';
import '../../providers/budget_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/budget_summary_card.dart';
import '../../widgets/common/expense_list_item.dart';
import '../../widgets/common/monthly_selector.dart';
import '../../navigation/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().loadExpenses();
      context.read<BudgetProvider>().loadBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: AppStrings.thisMonth,
        showBackButton: false,
        actions: [
          Icon(
            Icons.add,
            color: AppColors.textPrimary,
            size: AppDimensions.iconM,
          ),
        ],
      ),
      body: Consumer2<ExpenseProvider, BudgetProvider>(
        builder: (context, expenseProvider, budgetProvider, child) {
          if (expenseProvider.isLoading || budgetProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          final monthlyExpenses = expenseProvider.getExpensesByMonth(_selectedMonth);
          final totalSpent = expenseProvider.getTotalExpensesByMonth(_selectedMonth);
          final totalBudget = budgetProvider.getTotalBudgetAmountByMonth(_selectedMonth);

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
              
              // Total Expenses
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Text(
                  'LKR ${totalSpent.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              // Budget Summary Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                child: BudgetSummaryCard(
                  totalBudget: totalBudget,
                  totalSpent: totalSpent,
                  remainingAmount: totalBudget - totalSpent,
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              // Expenses List
              Expanded(
                child: monthlyExpenses.isEmpty
                    ? const Center(
                        child: Text(
                          'No expenses this month',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                        itemCount: monthlyExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = monthlyExpenses[index];
                          return ExpenseListItem(
                            expense: expense,
                            onTap: () {
                              // Navigate to expense details
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
