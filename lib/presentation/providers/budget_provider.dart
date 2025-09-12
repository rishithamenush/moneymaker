import 'package:flutter/material.dart';
import '../../domain/entities/budget.dart';
import '../../domain/usecases/budget/get_budget.dart';
import '../../domain/usecases/budget/create_budget.dart';
import '../../domain/usecases/budget/update_budget.dart';

class BudgetProvider extends ChangeNotifier {
  final GetBudget _getBudget;
  final CreateBudget _createBudget;
  final UpdateBudget _updateBudget;

  BudgetProvider({
    required GetBudget getBudget,
    required CreateBudget createBudget,
    required UpdateBudget updateBudget,
  })  : _getBudget = getBudget,
        _createBudget = createBudget,
        _updateBudget = updateBudget;

  List<Budget> _budgets = [];
  bool _isLoading = false;
  String? _error;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBudgets() async {
    _setLoading(true);
    _clearError();

    try {
      _budgets = await _getBudget();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createBudget(Budget budget) async {
    try {
      await _createBudget(budget);
      _budgets.add(budget);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _updateBudget(budget);
      final index = _budgets.indexWhere((b) => b.id == budget.id);
      if (index != -1) {
        _budgets[index] = budget;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  List<Budget> getBudgetsByMonth(DateTime month) {
    return _budgets.where((b) =>
        b.month.year == month.year && b.month.month == month.month).toList();
  }

  Budget? getBudgetByCategoryAndMonth(String categoryId, DateTime month) {
    try {
      return _budgets.firstWhere((b) =>
          b.categoryId == categoryId &&
          b.month.year == month.year &&
          b.month.month == month.month);
    } catch (e) {
      return null;
    }
  }

  double getTotalBudgetAmount() {
    return _budgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double getTotalBudgetAmountByMonth(DateTime month) {
    return getBudgetsByMonth(month)
        .fold(0.0, (sum, budget) => sum + budget.amount);
  }

  double getTotalSpentAmountByMonth(DateTime month) {
    return getBudgetsByMonth(month)
        .fold(0.0, (sum, budget) => sum + budget.spentAmount);
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
