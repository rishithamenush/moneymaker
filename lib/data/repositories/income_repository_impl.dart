import '../../domain/entities/income.dart';
import '../../domain/repositories/income_repository.dart';
import '../database/tables/incomes_table.dart';
import '../models/income_model.dart';
import '../../services/database/database_helper.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  @override
  Future<List<Income>> getIncomes() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      IncomesTable.tableName,
      orderBy: '${IncomesTable.columnDate} DESC',
    );
    return maps.map((map) => IncomeModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Income> getIncomeById(String id) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      IncomesTable.tableName,
      where: '${IncomesTable.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Income not found');
    }
    return IncomeModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<List<Income>> getIncomesByCategory(String categoryId) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      IncomesTable.tableName,
      where: '${IncomesTable.columnCategoryId} = ?',
      whereArgs: [categoryId],
      orderBy: '${IncomesTable.columnDate} DESC',
    );
    return maps.map((map) => IncomeModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<List<Income>> getIncomesByMonth(DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      IncomesTable.tableName,
      where: '${IncomesTable.columnDate} >= ? AND ${IncomesTable.columnDate} <= ?',
      whereArgs: [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
      orderBy: '${IncomesTable.columnDate} DESC',
    );
    return maps.map((map) => IncomeModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<List<Income>> getIncomesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      IncomesTable.tableName,
      where: '${IncomesTable.columnDate} >= ? AND ${IncomesTable.columnDate} <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: '${IncomesTable.columnDate} DESC',
    );
    return maps.map((map) => IncomeModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<double> getTotalIncomeByMonth(DateTime month) async {
    final incomes = await getIncomesByMonth(month);
    return incomes.fold<double>(0.0, (sum, income) => sum + income.amount);
  }

  @override
  Future<Income> addIncome(Income income) async {
    final db = await DatabaseHelper.database;
    final incomeModel = IncomeModel(
      id: income.id,
      amount: income.amount,
      description: income.description,
      categoryId: income.categoryId,
      categoryName: income.categoryName,
      date: income.date,
      createdAt: income.createdAt,
      updatedAt: income.updatedAt,
    );

    await db.insert(IncomesTable.tableName, incomeModel.toJson());
    return income;
  }

  @override
  Future<Income> updateIncome(Income income) async {
    final db = await DatabaseHelper.database;
    final updatedIncome = income.copyWith(updatedAt: DateTime.now());
    final incomeModel = IncomeModel(
      id: updatedIncome.id,
      amount: updatedIncome.amount,
      description: updatedIncome.description,
      categoryId: updatedIncome.categoryId,
      categoryName: updatedIncome.categoryName,
      date: updatedIncome.date,
      createdAt: updatedIncome.createdAt,
      updatedAt: updatedIncome.updatedAt,
    );

    await db.update(
      IncomesTable.tableName,
      incomeModel.toJson(),
      where: '${IncomesTable.columnId} = ?',
      whereArgs: [updatedIncome.id],
    );
    return updatedIncome;
  }

  @override
  Future<void> deleteIncome(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      IncomesTable.tableName,
      where: '${IncomesTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
