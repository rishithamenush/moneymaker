import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class MockCategoryRepository implements CategoryRepository {
  final List<Category> _categories = [
    Category(
      id: 'food',
      name: 'Food & Dining',
      iconName: 'restaurant',
      colorValue: 0xFFE17055,
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Category(
      id: 'transport',
      name: 'Auto & Transport',
      iconName: 'directions_car',
      colorValue: 0xFFFF6B35,
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Category(
      id: 'bills',
      name: 'Bills & Utilities',
      iconName: 'receipt',
      colorValue: 0xFFFF8E53,
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      iconName: 'movie',
      colorValue: 0xFFFFA726,
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<List<Category>> getCategories() async {
    return _categories;
  }

  @override
  Future<Category> getCategoryById(String id) async {
    return _categories.firstWhere((c) => c.id == id);
  }

  @override
  Future<void> addCategory(Category category) async {
    _categories.add(category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
  }

  @override
  Future<List<Category>> getDefaultCategories() async {
    return _categories.where((c) => c.isDefault).toList();
  }
}
