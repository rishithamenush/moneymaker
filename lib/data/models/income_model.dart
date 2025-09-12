import '../database/tables/incomes_table.dart';
import '../../domain/entities/income.dart';

class IncomeModel {
  final String id;
  final double amount;
  final String description;
  final String categoryId;
  final String categoryName;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IncomeModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json[IncomesTable.columnId] as String,
      amount: (json[IncomesTable.columnAmount] as num).toDouble(),
      description: json[IncomesTable.columnDescription] as String,
      categoryId: json[IncomesTable.columnCategoryId] as String,
      categoryName: json[IncomesTable.columnCategoryName] as String,
      date: DateTime.parse(json[IncomesTable.columnDate] as String),
      createdAt: DateTime.parse(json[IncomesTable.columnCreatedAt] as String),
      updatedAt: DateTime.parse(json[IncomesTable.columnUpdatedAt] as String),
    );
  }

  Income toEntity() {
    return Income(
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

  Map<String, dynamic> toJson() {
    return {
      IncomesTable.columnId: id,
      IncomesTable.columnAmount: amount,
      IncomesTable.columnDescription: description,
      IncomesTable.columnCategoryId: categoryId,
      IncomesTable.columnCategoryName: categoryName,
      IncomesTable.columnDate: date.toIso8601String(),
      IncomesTable.columnCreatedAt: createdAt.toIso8601String(),
      IncomesTable.columnUpdatedAt: updatedAt.toIso8601String(),
    };
  }
}
