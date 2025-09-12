import 'package:equatable/equatable.dart';

class Income extends Equatable {
  final String id;
  final double amount;
  final String description;
  final String categoryId;
  final String categoryName;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Income({
    required this.id,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [
        id,
        amount,
        description,
        categoryId,
        categoryName,
        date,
        createdAt,
        updatedAt,
      ];

  Income copyWith({
    String? id,
    double? amount,
    String? description,
    String? categoryId,
    String? categoryName,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Income(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
