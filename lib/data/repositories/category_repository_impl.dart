import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';
import '../database/tables/categories_table.dart';
import '../../services/database/database_helper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<List<Category>> getCategories() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      CategoriesTable.tableName,
      orderBy: CategoriesTable.name,
    );
    return maps.map((map) => CategoryModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Category> getCategoryById(String id) async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      CategoriesTable.tableName,
      where: '${CategoriesTable.id} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Category not found');
    }
    return CategoryModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<Category> addCategory(Category category) async {
    final db = await DatabaseHelper.database;
    final categoryModel = CategoryModel.fromEntity(category);
    await db.insert(CategoriesTable.tableName, categoryModel.toJson());
    return category;
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final db = await DatabaseHelper.database;
    final categoryModel = CategoryModel.fromEntity(category);
    await db.update(
      CategoriesTable.tableName,
      categoryModel.toJson(),
      where: '${CategoriesTable.id} = ?',
      whereArgs: [category.id],
    );
    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      CategoriesTable.tableName,
      where: '${CategoriesTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Category>> getDefaultCategories() async {
    // Return the first 8 categories as default categories
    final allCategories = await getCategories();
    return allCategories.take(8).toList();
  }
}
