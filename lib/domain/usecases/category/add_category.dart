import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(Category category) async {
    return await repository.addCategory(category);
  }
}
