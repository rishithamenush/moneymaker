import '../entities/income.dart';

abstract class IncomeRepository {
  Future<List<Income>> getIncomes();
  Future<Income> getIncomeById(String id);
  Future<List<Income>> getIncomesByCategory(String categoryId);
  Future<List<Income>> getIncomesByMonth(DateTime month);
  Future<List<Income>> getIncomesByDateRange(DateTime startDate, DateTime endDate);
  Future<double> getTotalIncomeByMonth(DateTime month);
  Future<Income> addIncome(Income income);
  Future<Income> updateIncome(Income income);
  Future<void> deleteIncome(String id);
}
