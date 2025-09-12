import '../../domain/entities/category.dart';
import '../database/tables/categories_table.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.colorValue,
    required super.iconName,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[CategoriesTable.id] as String,
      name: json[CategoriesTable.name] as String,
      colorValue: json[CategoriesTable.colorValue] as int,
      iconName: json[CategoriesTable.iconName] as String,
      createdAt: DateTime.parse(json[CategoriesTable.createdAt] as String),
      updatedAt: DateTime.parse(json[CategoriesTable.updatedAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CategoriesTable.id: id,
      CategoriesTable.name: name,
      CategoriesTable.colorValue: colorValue,
      CategoriesTable.iconName: iconName,
      CategoriesTable.createdAt: createdAt.toIso8601String(),
      CategoriesTable.updatedAt: updatedAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      colorValue: category.colorValue,
      iconName: category.iconName,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      colorValue: colorValue,
      iconName: iconName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}