import '../entities/category.dart';

abstract class ICategoryRepository {
  Future<List<Category>> getAll();
  Future<void> add(Category category);
  Future<void> update(Category category);
  Future<void> delete(String id); // hanya non-default
  Future<void> seedDefaults();    // dipanggil saat install pertama
  Stream<List<Category>> watchAll();
}
