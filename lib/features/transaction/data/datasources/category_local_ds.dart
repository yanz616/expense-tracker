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

  Future<void> seedDefaults() async {
    if (_box.isNotEmpty) return;
    for (final cat in DefaultCategories.all) {
      await _box.put(cat.id, CategoryModel.fromEntity(cat));
    }
  }

  /// FIX: yield nilai awal dulu sebelum listen perubahan
  Stream<List<Category>> watchAll() async* {
    yield getAll(); // emit langsung nilai saat ini
    await for (final _ in _box.watch()) {
      yield getAll();
    }
  }
}
