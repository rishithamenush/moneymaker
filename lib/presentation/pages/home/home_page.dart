import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/theme_colors.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../providers/expense_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/income_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/transaction_list_item.dart';
import '../../widgets/common/monthly_selector.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../../app/routes.dart';

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
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      context.read<ExpenseProvider>().loadExpenses(),
      context.read<BudgetProvider>().loadBudgets(),
      context.read<IncomeProvider>().loadIncomes(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: CustomAppBar(
        title: AppStrings.thisMonth,
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: Icon(
              Icons.refresh,
              color: ThemeColors.getTextPrimary(context),
              size: AppDimensions.iconM,
            ),
          ),
        ],
      ),
      body: Consumer3<ExpenseProvider, BudgetProvider, IncomeProvider>(
        builder: (context, expenseProvider, budgetProvider, incomeProvider, child) {
          if (expenseProvider.isLoading || budgetProvider.isLoading || incomeProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
              ),
            );
          }

          final monthlyExpenses = expenseProvider.getExpensesByMonth(_selectedMonth);
          final monthlyIncomes = incomeProvider.getIncomesByMonth(_selectedMonth);
          final totalSpent = expenseProvider.getTotalExpensesByMonth(_selectedMonth);
          final totalIncome = incomeProvider.getTotalIncomeByMonth(_selectedMonth);

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
              
              // Financial Summary - Compact Row Layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                child: Row(
                  children: [
                    // Total Income
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingS),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Income',
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.getTextSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'LKR ${totalIncome.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    // Total Expenses
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingS),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Expenses',
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.getTextSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'LKR ${totalSpent.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    // Net Amount
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingS),
                        decoration: BoxDecoration(
                          color: (totalIncome - totalSpent >= 0 ? AppColors.success : AppColors.error).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(color: (totalIncome - totalSpent >= 0 ? AppColors.success : AppColors.error).withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Net',
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.getTextSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'LKR ${(totalIncome - totalSpent).toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: totalIncome - totalSpent >= 0 ? AppColors.success : AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingM),
              
              // Transactions List (Expenses + Income)
              Expanded(
                child: _buildTransactionsList(monthlyExpenses, monthlyIncomes),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addTransaction);
        },
        backgroundColor: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildTransactionsList(List<Expense> expenses, List<Income> incomes) {
    // Combine and sort transactions by date (newest first)
    final allTransactions = <dynamic>[];
    allTransactions.addAll(expenses);
    allTransactions.addAll(incomes);
    
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    if (allTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 64,
              color: ThemeColors.getTextSecondary(context).withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              'No transactions yet',
              style: TextStyle(
                color: ThemeColors.getTextSecondary(context),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              'Tap the + button to add your first transaction',
              style: TextStyle(
                color: ThemeColors.getTextSecondary(context),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    final Map<String, List<dynamic>> groupedTransactions = {};
    for (final transaction in allTransactions) {
      final dateKey = Formatters.formatDate(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final dayTransactions = groupedTransactions[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
              child: Text(
                dateKey,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.getTextPrimary(context),
                ),
              ),
            ),
            // Transactions for this date
            ...dayTransactions.map((transaction) => TransactionListItem(
              transaction: transaction,
              onTap: () {
                // Navigate to transaction details
              },
              onDelete: () => _showDeleteConfirmation(context, transaction),
            )),
            const SizedBox(height: AppDimensions.paddingM),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic transaction) {
    final isIncome = transaction is Income;
    final transactionType = isIncome ? 'Income' : 'Expense';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $transactionType?'),
          content: Text(
            'Are you sure you want to delete this $transactionType transaction?\n\n'
            '${transaction.description}\n'
            'LKR ${transaction.amount.toStringAsFixed(0)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: ThemeColors.getTextSecondary(context)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTransaction(transaction);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTransaction(dynamic transaction) async {
    try {
      if (transaction is Income) {
        await context.read<IncomeProvider>().deleteIncome(transaction.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Income deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (transaction is Expense) {
        await context.read<ExpenseProvider>().deleteExpense(transaction.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete transaction: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
