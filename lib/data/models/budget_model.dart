import '../../domain/entities/budget.dart';
import '../database/tables/budgets_table.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.amount,
    required super.categoryId,
    required super.categoryName,
    required super.month,
    required super.spentAmount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json[BudgetsTable.id] as String,
      amount: (json[BudgetsTable.amount] as num).toDouble(),
      categoryId: json[BudgetsTable.categoryId] as String,
      categoryName: json[BudgetsTable.categoryName] as String,
      month: DateTime.parse(json[BudgetsTable.month] as String),
      spentAmount: (json[BudgetsTable.spentAmount] as num).toDouble(),
      createdAt: DateTime.parse(json[BudgetsTable.createdAt] as String),
      updatedAt: DateTime.parse(json[BudgetsTable.updatedAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      BudgetsTable.id: id,
      BudgetsTable.amount: amount,
      BudgetsTable.categoryId: categoryId,
      BudgetsTable.categoryName: categoryName,
      BudgetsTable.month: month.toIso8601String(),
      BudgetsTable.spentAmount: spentAmount,
      BudgetsTable.createdAt: createdAt.toIso8601String(),
      BudgetsTable.updatedAt: updatedAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      amount: budget.amount,
      categoryId: budget.categoryId,
      categoryName: budget.categoryName,
      month: budget.month,
      spentAmount: budget.spentAmount,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  Budget toEntity() {
    return Budget(
      id: id,
      amount: amount,
      categoryId: categoryId,
      categoryName: categoryName,
      month: month,
      spentAmount: spentAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}