import '../../domain/entities/category.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../datasources/category_local_ds.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final CategoryLocalDataSource _ds;
  CategoryRepositoryImpl(this._ds);

  @override
  Future<List<Category>> getAll() async => _ds.getAll();

  @override
  Future<void> add(Category category) => _ds.add(category);

  @override
  Future<void> update(Category category) => _ds.update(category);

  @override
  Future<void> delete(String id) => _ds.delete(id);

  @override
  Future<void> seedDefaults() => _ds.seedDefaults();

  @override
  Stream<List<Category>> watchAll() => _ds.watchAll();
}
