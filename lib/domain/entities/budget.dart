import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final double amount;
  final String categoryId;
  final String categoryName;
  final DateTime month;
  final double spentAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.month,
    required this.spentAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingAmount => amount - spentAmount;
  double get spentPercentage => amount > 0 ? spentAmount / amount : 0.0;
  bool get isOverBudget => spentAmount > amount;

  @override
  List<Object> get props => [
        id,
        amount,
        categoryId,
        categoryName,
        month,
        spentAmount,
        createdAt,
        updatedAt,
      ];

  Budget copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? categoryName,
    DateTime? month,
    double? spentAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      month: month ?? this.month,
      spentAmount: spentAmount ?? this.spentAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
