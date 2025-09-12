import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../models/budget_model.dart';
import '../database/tables/budgets_table.dart';
import '../../services/database/database_helper.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  @override
  Future<List<Budget>> getBudgets() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      BudgetsTable.tableName,
      orderBy: '${BudgetsTable.month} DESC',
    );
    return maps.map((map) => BudgetModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Budget> getBudgetById(String id) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      BudgetsTable.tableName,
      where: '${BudgetsTable.id} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Budget not found');
    }
    return BudgetModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<List<Budget>> getBudgetsByMonth(DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      BudgetsTable.tableName,
      where: '${BudgetsTable.month} >= ? AND ${BudgetsTable.month} <= ?',
      whereArgs: [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
      orderBy: '${BudgetsTable.month} DESC',
    );
    return maps.map((map) => BudgetModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Budget> getBudgetByCategoryAndMonth(String categoryId, DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      BudgetsTable.tableName,
      where: '${BudgetsTable.categoryId} = ? AND ${BudgetsTable.month} >= ? AND ${BudgetsTable.month} <= ?',
      whereArgs: [categoryId, startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
    );
    if (maps.isEmpty) {
      throw Exception('Budget not found for category and month');
    }
    return BudgetModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<Budget> createBudget(Budget budget) async {
    final db = await DatabaseHelper.database;
    final budgetModel = BudgetModel.fromEntity(budget);
    await db.insert(BudgetsTable.tableName, budgetModel.toJson());
    return budget;
  }

  @override
  Future<Budget> updateBudget(Budget budget) async {
    final db = await DatabaseHelper.database;
    final budgetModel = BudgetModel.fromEntity(budget);
    await db.update(
      BudgetsTable.tableName,
      budgetModel.toJson(),
      where: '${BudgetsTable.id} = ?',
      whereArgs: [budget.id],
    );
    return budget;
  }

  @override
  Future<void> deleteBudget(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      BudgetsTable.tableName,
      where: '${BudgetsTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalBudgetAmount() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(${BudgetsTable.amount}) as total FROM ${BudgetsTable.tableName}',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalBudgetAmountByMonth(DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final result = await db.rawQuery(
      'SELECT SUM(${BudgetsTable.amount}) as total FROM ${BudgetsTable.tableName} WHERE ${BudgetsTable.month} >= ? AND ${BudgetsTable.month} <= ?',
      [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalSpentAmountByMonth(DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final result = await db.rawQuery(
      'SELECT SUM(${BudgetsTable.spentAmount}) as total FROM ${BudgetsTable.tableName} WHERE ${BudgetsTable.month} >= ? AND ${BudgetsTable.month} <= ?',
      [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
