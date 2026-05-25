import 'package:expense_tracker/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/category_usecases.dart';
import 'package:expense_tracker/injection_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryStreamProvider = StreamProvider<List<Category>>((ref) {
  return sl<GetAllCategories>().watch();
});

// Map categoryId → Category untuk lookup cepat di UI
final categoryMapProvider = Provider<AsyncValue<Map<String, Category>>>((ref) {
  return ref.watch(categoryStreamProvider).whenData(
        (list) => {for (final c in list) c.id: c},
      );
});
