import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
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
import '../../providers/category_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/transaction_list_item.dart';
import '../../widgets/common/monthly_selector.dart';
import '../../widgets/common/delete_confirmation_dialog.dart';
import '../../widgets/common/modern_popup.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../../app/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SortOption { dateNewest, dateOldest, amountHighest, amountLowest, category }

class _HomePageState extends State<HomePage> {
  DateTime _selectedMonth = DateTime.now();
  String? _selectedCategoryFilter; // null means "All Categories"
  SortOption _selectedSort = SortOption.dateNewest;
  bool _showFilters = false;

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
      context.read<CategoryProvider>().loadCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ThemeColors.getBackground(context),
      appBar: CustomAppBar(
        title: l10n.thisMonth,
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
              color: ThemeColors.getTextPrimary(context),
              size: AppDimensions.iconS, // Reduced from iconM to iconS
            ),
            padding: const EdgeInsets.all(8), // Reduced padding
          ),
          IconButton(
            onPressed: _loadData,
            icon: Icon(
              Icons.refresh,
              color: ThemeColors.getTextPrimary(context),
              size: AppDimensions.iconS, // Reduced from iconM to iconS
            ),
            padding: const EdgeInsets.all(8), // Reduced padding
          ),
        ],
      ),
      body: Consumer4<ExpenseProvider, BudgetProvider, IncomeProvider, CategoryProvider>(
        builder: (context, expenseProvider, budgetProvider, incomeProvider, categoryProvider, child) {
          if (expenseProvider.isLoading || budgetProvider.isLoading || incomeProvider.isLoading || categoryProvider.isLoading) {
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
              
              // Filter and Sort Section
              if (_showFilters) _buildFilterSection(categoryProvider.categories),
              
              // Financial Summary - Compact Row Layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM,vertical: AppDimensions.paddingM),
                child: Row(
                  children: [
                    // Total Income
                    Expanded(
                      child: Container(
                        height: 75, // Optimized height to reduce empty space
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.income,
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.getTextSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                Formatters.formatCurrency(totalIncome, currencyCode: context.read<ThemeProvider>().currency),
                                style: const TextStyle(
                                  fontSize: 14, // Smaller font to fit more text
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2, // Allow 2 lines for larger numbers
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    // Total Expenses
                    Expanded(
                      child: Container(
                        height: 75, // Optimized height to reduce empty space
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.expense,
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.getTextSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                Formatters.formatCurrency(totalSpent, currencyCode: context.read<ThemeProvider>().currency),
                                style: const TextStyle(
                                  fontSize: 14, // Smaller font to fit more text
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2, // Allow 2 lines for larger numbers
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    // Net Amount
                    Expanded(
                      child: Container(
                        height: 75, // Optimized height to reduce empty space
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS, vertical: 8),
                        decoration: BoxDecoration(
                          color: (totalIncome - totalSpent >= 0 ? Colors.blue : AppColors.error).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          border: Border.all(color: (totalIncome - totalSpent >= 0 ? Colors.blue : AppColors.error).withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.netAmount,
                              style: TextStyle(
                                fontSize: 12,
                                color: ThemeColors.getTextSecondary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Flexible(
                              child: Text(
                                Formatters.formatCurrency(totalIncome - totalSpent, currencyCode: context.read<ThemeProvider>().currency),
                                style: TextStyle(
                                  fontSize: 14, // Smaller font to fit more text
                                  fontWeight: FontWeight.bold,
                                  color: totalIncome - totalSpent >= 0 ? Colors.blue : AppColors.error,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2, // Allow 2 lines for larger numbers
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.paddingS),
              
              // Add extra vertical padding after the cards
              const SizedBox(height: AppDimensions.paddingS),
              
              // Transactions List (Expenses + Income)
              Expanded(
                child: _buildTransactionsList(
                  _filterAndSortTransactions(monthlyExpenses, monthlyIncomes),
                ),
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
         child: const Icon(Icons.account_balance_wallet_outlined),
       ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildFilterSection(List<dynamic> categories) {
    return Container(
      height: 50, // Fixed compact height
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: ThemeColors.getBorder(context).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Category Dropdown
          Expanded(
            flex: 2,
            child: _buildCategoryDropdown(categories),
          ),
          const SizedBox(width: 8),
          // Sort Dropdown
          Expanded(
            flex: 2,
            child: _buildSortDropdown(),
          ),
          const SizedBox(width: 4),
          // Clear Filters Button
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedCategoryFilter = null;
                  _selectedSort = SortOption.dateNewest;
                });
              },
              icon: Icon(
                Icons.clear_all,
                color: ThemeColors.getTextSecondary(context),
                size: 18,
              ),
              tooltip: 'Clear Filters',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(List<dynamic> categories) {
    String displayText = 'All Categories';
    if (_selectedCategoryFilter != null) {
      try {
        final selectedCategory = categories.firstWhere((cat) => cat.id == _selectedCategoryFilter);
        displayText = selectedCategory.name;
      } catch (e) {
        displayText = 'All Categories';
        // Reset filter if category not found
        _selectedCategoryFilter = null;
      }
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return PopupMenuButton<String?>(
      initialValue: _selectedCategoryFilter,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          border: Border.all(color: ThemeColors.getBorder(context).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 13,
                  color: ThemeColors.getTextPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: ThemeColors.getTextSecondary(context),
              size: 20,
            ),
          ],
        ),
      ),
      offset: const Offset(0, 42),
      elevation: 8,
      color: ThemeColors.getSurface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(
        maxHeight: 300,
        minWidth: constraints.maxWidth, // Exact field width
        maxWidth: constraints.maxWidth, // Exact field width
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String?>(
          value: null,
          child: Row(
            children: [
              Icon(
                Icons.all_inclusive,
                size: 16,
                color: ThemeColors.getTextSecondary(context),
              ),
              const SizedBox(width: 8),
              Text(
                'All Categories',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ThemeColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
        ),
        ...categories.map((category) => PopupMenuItem<String?>(
          value: category.id,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.category,
                  size: 12,
                  color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.getTextPrimary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )),
      ],
      onSelected: (value) {
        setState(() {
          _selectedCategoryFilter = value;
        });
      },
    );
      },
    );
  }

  Widget _buildSortDropdown() {
    final sortOptions = {
      SortOption.dateNewest: {'label': 'Date (Newest)', 'icon': Icons.arrow_downward, 'desc': 'Recent first'},
      SortOption.dateOldest: {'label': 'Date (Oldest)', 'icon': Icons.arrow_upward, 'desc': 'Oldest first'},
      SortOption.amountHighest: {'label': 'Amount (High)', 'icon': Icons.trending_up, 'desc': 'Highest first'},
      SortOption.amountLowest: {'label': 'Amount (Low)', 'icon': Icons.trending_down, 'desc': 'Lowest first'},
      SortOption.category: {'label': 'Category', 'icon': Icons.sort_by_alpha, 'desc': 'A to Z'},
    };

    String displayText = sortOptions[_selectedSort]?['label'] as String? ?? 'Date (Newest)';

    return LayoutBuilder(
      builder: (context, constraints) {
        return PopupMenuButton<SortOption>(
      initialValue: _selectedSort,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          border: Border.all(color: ThemeColors.getBorder(context).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 13,
                  color: ThemeColors.getTextPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: ThemeColors.getTextSecondary(context),
              size: 20,
            ),
          ],
        ),
      ),
      offset: const Offset(0, 42),
      elevation: 8,
      color: ThemeColors.getSurface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(
        maxHeight: 300,
        minWidth: constraints.maxWidth, // Exact field width
        maxWidth: constraints.maxWidth, // Exact field width
      ),
      itemBuilder: (context) => sortOptions.entries.map((entry) => PopupMenuItem<SortOption>(
        value: entry.key,
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                entry.value['icon'] as IconData,
                size: 14,
                color: ThemeColors.getAccentColor(context, context.read<ThemeProvider>().accentColor),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.value['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ThemeColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    entry.value['desc'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: ThemeColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
      onSelected: (value) {
        setState(() {
          _selectedSort = value;
        });
      },
    );
      },
    );
  }


  List<dynamic> _filterAndSortTransactions(List<Expense> expenses, List<Income> incomes) {
    // Combine all transactions
    List<dynamic> allTransactions = [...expenses, ...incomes];
    
    // Apply category filter
    if (_selectedCategoryFilter != null) {
      allTransactions = allTransactions.where((transaction) {
        return transaction.categoryId == _selectedCategoryFilter;
      }).toList();
    }
    
    // Apply sorting
    switch (_selectedSort) {
      case SortOption.dateNewest:
        allTransactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.dateOldest:
        allTransactions.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.amountHighest:
        allTransactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.amountLowest:
        allTransactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case SortOption.category:
        allTransactions.sort((a, b) => a.categoryName.compareTo(b.categoryName));
        break;
    }
    
    return allTransactions;
  }

  Widget _buildTransactionsList(List<dynamic> transactions) {
    final l10n = AppLocalizations.of(context)!;

    if (transactions.isEmpty) {
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
              l10n.noTransactions,
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
    for (final transaction in transactions) {
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
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
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
              onDelete: () => DeleteConfirmationDialog.show(
                context,
                transaction: transaction,
                onConfirm: () => _deleteTransaction(transaction),
              ),
            )),
            const SizedBox(height: AppDimensions.paddingM),
          ],
        );
      },
    );
  }


  Future<void> _deleteTransaction(dynamic transaction) async {
    try {
      if (transaction is Income) {
        await context.read<IncomeProvider>().deleteIncome(transaction.id);
        PopupUtils.showSuccess(
          context: context,
          title: 'Success',
          message: 'Income deleted successfully',
        );
      } else if (transaction is Expense) {
        await context.read<ExpenseProvider>().deleteExpense(transaction.id);
        PopupUtils.showSuccess(
          context: context,
          title: 'Success',
          message: 'Expense deleted successfully',
        );
      }
    } catch (e) {
      PopupUtils.showError(
        context: context,
        title: 'Error',
        message: 'Failed to delete transaction: $e',
      );
    }
  }
}
