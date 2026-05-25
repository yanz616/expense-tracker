import 'package:hive/hive.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String icon;
  @HiveField(3)
  late int colorValue;
  @HiveField(4)
  late bool isDefault;

  CategoryModel();

  factory CategoryModel.fromEntity(Category e) => CategoryModel()
    ..id = e.id
    ..name = e.name
    ..icon = e.icon
    ..colorValue = e.colorValue
    ..isDefault = e.isDefault;

  Category toEntity() => Category(
        id: id,
        name: name,
        icon: icon,
        colorValue: colorValue,
        isDefault: isDefault,
      );
}
