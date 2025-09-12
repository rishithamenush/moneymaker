import '../../domain/entities/expense.dart';
import '../database/tables/expenses_table.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.description,
    required super.categoryId,
    required super.categoryName,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json[ExpensesTable.id] as String,
      amount: (json[ExpensesTable.amount] as num).toDouble(),
      description: json[ExpensesTable.description] as String,
      categoryId: json[ExpensesTable.categoryId] as String,
      categoryName: json[ExpensesTable.categoryName] as String,
      date: DateTime.parse(json[ExpensesTable.date] as String),
      createdAt: DateTime.parse(json[ExpensesTable.createdAt] as String),
      updatedAt: DateTime.parse(json[ExpensesTable.updatedAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ExpensesTable.id: id,
      ExpensesTable.amount: amount,
      ExpensesTable.description: description,
      ExpensesTable.categoryId: categoryId,
      ExpensesTable.categoryName: categoryName,
      ExpensesTable.date: date.toIso8601String(),
      ExpensesTable.createdAt: createdAt.toIso8601String(),
      ExpensesTable.updatedAt: updatedAt.toIso8601String(),
    };
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      amount: expense.amount,
      description: expense.description,
      categoryId: expense.categoryId,
      categoryName: expense.categoryName,
      date: expense.date,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
  }

  Expense toEntity() {
    return Expense(
      id: id,
      amount: amount,
      description: description,
      categoryId: categoryId,
      categoryName: categoryName,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}