import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/features/transaction/data/models/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/default_categories.dart';

class CategoryLocalDataSource {
  Box<CategoryModel> get _box =>
      Hive.box<CategoryModel>(AppConstants.boxCategories);

  List<Category> getAll() => _box.values.map((m) => m.toEntity()).toList();

  Future<void> add(Category category) =>
      _box.put(category.id, CategoryModel.fromEntity(category));

  Future<void> update(Category category) =>
      _box.put(category.id, CategoryModel.fromEntity(category));

  Future<void> delete(String id) => _box.delete(id);

  /// Seed kategori default saat install pertama
  Future<void> seedDefaults() async {
    if (_box.isNotEmpty) return;
    for (final cat in DefaultCategories.all) {
      await _box.put(cat.id, CategoryModel.fromEntity(cat));
    }
  }

  Stream<List<Category>> watchAll() => _box.watch().map((_) => getAll());
}
