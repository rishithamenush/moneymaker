import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';

class MockBudgetRepository implements BudgetRepository {
  final List<Budget> _budgets = [
    Budget(
      id: '1',
      amount: 15000.0,
      categoryId: 'food',
      categoryName: 'Food & Dining',
      month: DateTime.now(),
      spentAmount: 2000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Budget(
      id: '2',
      amount: 10000.0,
      categoryId: 'transport',
      categoryName: 'Auto & Transport',
      month: DateTime.now(),
      spentAmount: 2500.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Budget(
      id: '3',
      amount: 25000.0,
      categoryId: 'bills',
      categoryName: 'Bills & Utilities',
      month: DateTime.now(),
      spentAmount: 8000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<List<Budget>> getBudgets() async {
    return _budgets;
  }

  @override
  Future<List<Budget>> getBudgetsByMonth(DateTime month) async {
    return _budgets.where((b) =>
        b.month.year == month.year && b.month.month == month.month).toList();
  }

  @override
  Future<Budget> getBudgetByCategoryAndMonth(String categoryId, DateTime month) async {
    return _budgets.firstWhere((b) =>
        b.categoryId == categoryId &&
        b.month.year == month.year &&
        b.month.month == month.month);
  }

  @override
  Future<Budget> getBudgetById(String id) async {
    return _budgets.firstWhere((b) => b.id == id);
  }

  @override
  Future<void> createBudget(Budget budget) async {
    _budgets.add(budget);
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    _budgets.removeWhere((b) => b.id == id);
  }

  @override
  Future<double> getTotalBudgetAmount() async {
    return _budgets.fold<double>(0.0, (sum, budget) => sum + budget.amount);
  }

  @override
  Future<double> getTotalBudgetAmountByMonth(DateTime month) async {
    final budgets = await getBudgetsByMonth(month);
    return budgets.fold<double>(0.0, (sum, budget) => sum + budget.amount);
  }

  @override
  Future<double> getTotalSpentAmountByMonth(DateTime month) async {
    final budgets = await getBudgetsByMonth(month);
    return budgets.fold<double>(0.0, (sum, budget) => sum + budget.spentAmount);
  }
}
