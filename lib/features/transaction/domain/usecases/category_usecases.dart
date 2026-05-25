import '../entities/category.dart';
import '../repositories/i_category_repository.dart';

class GetAllCategories {
  final ICategoryRepository _repo;
  GetAllCategories(this._repo);
  Future<List<Category>> call() => _repo.getAll();
  Stream<List<Category>> watch() => _repo.watchAll();
}

class AddCategory {
  final ICategoryRepository _repo;
  AddCategory(this._repo);
  Future<void> call(Category category) => _repo.add(category);
}

class UpdateCategory {
  final ICategoryRepository _repo;
  UpdateCategory(this._repo);
  Future<void> call(Category category) => _repo.update(category);
}

class DeleteCategory {
  final ICategoryRepository _repo;
  DeleteCategory(this._repo);
  Future<void> call(String id) => _repo.delete(id);
}
