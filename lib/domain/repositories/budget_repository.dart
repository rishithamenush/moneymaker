import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets();
  Future<List<Budget>> getBudgetsByMonth(DateTime month);
  Future<Budget> getBudgetByCategoryAndMonth(String categoryId, DateTime month);
  Future<Budget> getBudgetById(String id);
  Future<void> createBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);
  Future<double> getTotalBudgetAmount();
  Future<double> getTotalBudgetAmountByMonth(DateTime month);
  Future<double> getTotalSpentAmountByMonth(DateTime month);
}
