import 'category.dart';

class DefaultCategories {
  DefaultCategories._();

  static const List<Category> all = [
    Category(id: 'cat_makanan',   name: 'Makanan',   icon: 'restaurant',       colorValue: 0xFFFF9E64, isDefault: true),
    Category(id: 'cat_transport', name: 'Transport',  icon: 'commute',          colorValue: 0xFF7DCFFF, isDefault: true),
    Category(id: 'cat_belanja',   name: 'Belanja',    icon: 'shopping_bag',     colorValue: 0xFFE0AF68, isDefault: true),
    Category(id: 'cat_hiburan',   name: 'Hiburan',    icon: 'gamepad',          colorValue: 0xFFBB9AF7, isDefault: true),
    Category(id: 'cat_tagihan',   name: 'Tagihan',    icon: 'receipt_long',     colorValue: 0xFFF7768E, isDefault: true),
    Category(id: 'cat_kesehatan', name: 'Kesehatan',  icon: 'medical_services', colorValue: 0xFF9ECE6A, isDefault: true),
    Category(id: 'cat_sains',     name: 'Sains',      icon: 'science',          colorValue: 0xFF2AC3DE, isDefault: true),
    Category(id: 'cat_lainnya',   name: 'Lainnya',    icon: 'grid_view',        colorValue: 0xFF7AA2F7, isDefault: true),
  ];
}
