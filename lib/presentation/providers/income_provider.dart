import 'package:flutter/foundation.dart';
import '../../domain/entities/income.dart';
import '../../domain/usecases/income/get_incomes.dart';
import '../../domain/usecases/income/add_income.dart';
import '../../domain/usecases/income/update_income.dart';
import '../../domain/usecases/income/delete_income.dart';

class IncomeProvider with ChangeNotifier {
  final GetIncomes _getIncomes;
  final AddIncome _addIncome;
  final UpdateIncome _updateIncome;
  final DeleteIncome _deleteIncome;

  IncomeProvider({
    required GetIncomes getIncomes,
    required AddIncome addIncome,
    required UpdateIncome updateIncome,
    required DeleteIncome deleteIncome,
  })  : _getIncomes = getIncomes,
        _addIncome = addIncome,
        _updateIncome = updateIncome,
        _deleteIncome = deleteIncome;

  List<Income> _incomes = [];
  bool _isLoading = false;
  String? _error;

  List<Income> get incomes => _incomes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadIncomes() async {
    _setLoading(true);
    try {
      _incomes = await _getIncomes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addIncome(Income income) async {
    try {
      final newIncome = await _addIncome(income);
      _incomes.insert(0, newIncome);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateIncome(Income income) async {
    try {
      final updatedIncome = await _updateIncome(income);
      final index = _incomes.indexWhere((i) => i.id == income.id);
      if (index != -1) {
        _incomes[index] = updatedIncome;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteIncome(String id) async {
    try {
      await _deleteIncome(id);
      _incomes.removeWhere((income) => income.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<Income> getIncomesByMonth(DateTime month) {
    return _incomes.where((income) {
      return income.date.year == month.year && income.date.month == month.month;
    }).toList();
  }

  double getTotalIncomeByMonth(DateTime month) {
    final monthlyIncomes = getIncomesByMonth(month);
    return monthlyIncomes.fold<double>(0.0, (sum, income) => sum + income.amount);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
