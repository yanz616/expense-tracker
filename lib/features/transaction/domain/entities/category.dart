import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int colorValue;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, icon, colorValue, isDefault];

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    int? colorValue,
    bool? isDefault,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        colorValue: colorValue ?? this.colorValue,
        isDefault: isDefault ?? this.isDefault,
      );
}
