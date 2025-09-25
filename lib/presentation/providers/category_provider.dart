import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/category/get_categories.dart';
import '../../domain/usecases/category/add_category.dart';
import '../../domain/usecases/category/delete_category.dart';

class CategoryProvider extends ChangeNotifier {
  final GetCategories _getCategories;
  final AddCategory _addCategory;
  final DeleteCategory? _deleteCategory;

  CategoryProvider({
    required GetCategories getCategories,
    required AddCategory addCategory,
    DeleteCategory? deleteCategory,
  })  : _getCategories = getCategories,
        _addCategory = addCategory,
        _deleteCategory = deleteCategory;

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _setLoading(true);
    _clearError();

    try {
      _categories = await _getCategories();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _addCategory(category);
      _categories.add(category);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      if (_deleteCategory != null) {
        await _deleteCategory!(id);
      }
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Category> getDefaultCategories() {
    return _categories.where((c) => c.isDefault).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
