import 'package:hive/hive.dart';
import '../../domain/entities/archived_period.dart';

part 'archived_period_model.g.dart';

@HiveType(typeId: 2)
class ArchivedPeriodModel extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late DateTime periodStart;
  @HiveField(2)
  late DateTime periodEnd;
  @HiveField(3)
  late double totalIncome;
  @HiveField(4)
  late double totalExpense;
  @HiveField(5)
  late double totalSubscription;
  @HiveField(6)
  late int transactionCount;
  @HiveField(7)
  late DateTime archivedAt;

  ArchivedPeriodModel();

  factory ArchivedPeriodModel.fromEntity(ArchivedPeriod e) =>
      ArchivedPeriodModel()
        ..id = e.id
        ..periodStart = e.periodStart
        ..periodEnd = e.periodEnd
        ..totalIncome = e.totalIncome
        ..totalExpense = e.totalExpense
        ..totalSubscription = e.totalSubscription
        ..transactionCount = e.transactionCount
        ..archivedAt = e.archivedAt;

  ArchivedPeriod toEntity() => ArchivedPeriod(
        id: id,
        periodStart: periodStart,
        periodEnd: periodEnd,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        totalSubscription: totalSubscription,
        transactionCount: transactionCount,
        archivedAt: archivedAt,
      );
}
