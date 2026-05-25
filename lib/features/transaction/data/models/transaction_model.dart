import 'package:hive/hive.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/entities/transaction_status.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late double amount;
  @HiveField(3)
  late int typeIndex;
  @HiveField(4)
  late int statusIndex;
  @HiveField(5)
  late String categoryId;
  @HiveField(6)
  late DateTime date;
  @HiveField(7)
  String? description;
  @HiveField(8)
  late DateTime createdAt;
  @HiveField(9)
  DateTime? updatedAt;

  TransactionModel();

  factory TransactionModel.fromEntity(Transaction e) => TransactionModel()
    ..id = e.id
    ..title = e.title
    ..amount = e.amount
    ..typeIndex = e.type.index
    ..statusIndex = e.status.index
    ..categoryId = e.categoryId
    ..date = e.date
    ..description = e.description
    ..createdAt = e.createdAt
    ..updatedAt = e.updatedAt;

  Transaction toEntity() => Transaction(
        id: id,
        title: title,
        amount: amount,
        type: TransactionType.values[typeIndex],
        status: TransactionStatus.values[statusIndex],
        categoryId: categoryId,
        date: date,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
