import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<List<Expense>> getExpensesByCategory(String categoryId);
  Future<List<Expense>> getExpensesByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Expense>> getExpensesByMonth(DateTime month);
  Future<Expense> getExpenseById(String id);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<double> getTotalExpenses();
  Future<double> getTotalExpensesByCategory(String categoryId);
  Future<double> getTotalExpensesByMonth(DateTime month);
}
