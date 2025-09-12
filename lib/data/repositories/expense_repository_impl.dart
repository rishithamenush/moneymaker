import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_model.dart';
import '../database/tables/expenses_table.dart';
import '../../services/database/database_helper.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  @override
  Future<List<Expense>> getExpenses() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      ExpensesTable.tableName,
      orderBy: '${ExpensesTable.date} DESC',
    );
    return maps.map((map) => ExpenseModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Expense> getExpenseById(String id) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      ExpensesTable.tableName,
      where: '${ExpensesTable.id} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Expense not found');
    }
    return ExpenseModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String categoryId) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      ExpensesTable.tableName,
      where: '${ExpensesTable.categoryId} = ?',
      whereArgs: [categoryId],
      orderBy: '${ExpensesTable.date} DESC',
    );
    return maps.map((map) => ExpenseModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<List<Expense>> getExpensesByMonth(DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      ExpensesTable.tableName,
      where: '${ExpensesTable.date} >= ? AND ${ExpensesTable.date} <= ?',
      whereArgs: [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
      orderBy: '${ExpensesTable.date} DESC',
    );
    return maps.map((map) => ExpenseModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      ExpensesTable.tableName,
      where: '${ExpensesTable.date} >= ? AND ${ExpensesTable.date} <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: '${ExpensesTable.date} DESC',
    );
    return maps.map((map) => ExpenseModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    final db = await DatabaseHelper.database;
    final expenseModel = ExpenseModel.fromEntity(expense);
    await db.insert(ExpensesTable.tableName, expenseModel.toJson());
    return expense;
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final db = await DatabaseHelper.database;
    final expenseModel = ExpenseModel.fromEntity(expense);
    await db.update(
      ExpensesTable.tableName,
      expenseModel.toJson(),
      where: '${ExpensesTable.id} = ?',
      whereArgs: [expense.id],
    );
    return expense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      ExpensesTable.tableName,
      where: '${ExpensesTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalExpenses() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(${ExpensesTable.amount}) as total FROM ${ExpensesTable.tableName}',
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalExpensesByCategory(String categoryId) async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(${ExpensesTable.amount}) as total FROM ${ExpensesTable.tableName} WHERE ${ExpensesTable.categoryId} = ?',
      [categoryId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalExpensesByMonth(DateTime month) async {
    final db = await DatabaseHelper.database;
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final result = await db.rawQuery(
      'SELECT SUM(${ExpensesTable.amount}) as total FROM ${ExpensesTable.tableName} WHERE ${ExpensesTable.date} >= ? AND ${ExpensesTable.date} <= ?',
      [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
