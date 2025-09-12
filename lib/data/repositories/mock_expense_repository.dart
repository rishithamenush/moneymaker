import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

class MockExpenseRepository implements ExpenseRepository {
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      amount: 500.0,
      description: 'Coffee',
      categoryId: 'food',
      categoryName: 'Food & Dining',
      date: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '2',
      amount: 2500.0,
      description: 'Petrol',
      categoryId: 'transport',
      categoryName: 'Auto & Transport',
      date: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Expense(
      id: '3',
      amount: 1500.0,
      description: 'Lunch',
      categoryId: 'food',
      categoryName: 'Food & Dining',
      date: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Expense(
      id: '4',
      amount: 8000.0,
      description: 'Electricity Bill',
      categoryId: 'bills',
      categoryName: 'Bills & Utilities',
      date: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Future<List<Expense>> getExpenses() async {
    return _expenses;
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async {
    return _expenses.where((e) => e.categoryId == categoryId).toList();
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    return _expenses.where((e) => 
        e.date.isAfter(startDate) && e.date.isBefore(endDate)).toList();
  }

  @override
  Future<List<Expense>> getExpensesByMonth(DateTime month) async {
    return _expenses.where((e) =>
        e.date.year == month.year && e.date.month == month.month).toList();
  }

  @override
  Future<Expense> getExpenseById(String id) async {
    return _expenses.firstWhere((e) => e.id == id);
  }

  @override
  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
  }

  @override
  Future<double> getTotalExpenses() async {
    return _expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  Future<double> getTotalExpensesByCategory(String categoryId) async {
    final expenses = await getExpensesByCategory(categoryId);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  Future<double> getTotalExpensesByMonth(DateTime month) async {
    final expenses = await getExpensesByMonth(month);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }
}
