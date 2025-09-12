import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/expense/get_expenses.dart';
import '../../domain/usecases/expense/add_expense.dart';
import '../../domain/usecases/expense/update_expense.dart';
import '../../domain/usecases/expense/delete_expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final GetExpenses _getExpenses;
  final AddExpense _addExpense;
  final UpdateExpense _updateExpense;
  final DeleteExpense _deleteExpense;

  ExpenseProvider({
    required GetExpenses getExpenses,
    required AddExpense addExpense,
    required UpdateExpense updateExpense,
    required DeleteExpense deleteExpense,
  })  : _getExpenses = getExpenses,
        _addExpense = addExpense,
        _updateExpense = updateExpense,
        _deleteExpense = deleteExpense;

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExpenses() async {
    _setLoading(true);
    _clearError();

    try {
      _expenses = await _getExpenses();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _addExpense(expense);
      _expenses.add(expense);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  List<Expense> getExpensesByCategory(String categoryId) {
    return _expenses.where((e) => e.categoryId == categoryId).toList();
  }

  List<Expense> getExpensesByMonth(DateTime month) {
    return _expenses.where((e) =>
        e.date.year == month.year && e.date.month == month.month).toList();
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpensesByCategory(String categoryId) {
    return getExpensesByCategory(categoryId)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpensesByMonth(DateTime month) {
    return getExpensesByMonth(month)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
