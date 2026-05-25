// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
part of 'archived_period_model.dart';

class ArchivedPeriodModelAdapter extends TypeAdapter<ArchivedPeriodModel> {
  @override
  final int typeId = 2;

  @override
  ArchivedPeriodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArchivedPeriodModel()
      ..id = fields[0] as String
      ..periodStart = fields[1] as DateTime
      ..periodEnd = fields[2] as DateTime
      ..totalIncome = fields[3] as double
      ..totalExpense = fields[4] as double
      ..totalSubscription = fields[5] as double
      ..transactionCount = fields[6] as int
      ..archivedAt = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ArchivedPeriodModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.periodStart)
      ..writeByte(2)
      ..write(obj.periodEnd)
      ..writeByte(3)
      ..write(obj.totalIncome)
      ..writeByte(4)
      ..write(obj.totalExpense)
      ..writeByte(5)
      ..write(obj.totalSubscription)
      ..writeByte(6)
      ..write(obj.transactionCount)
      ..writeByte(7)
      ..write(obj.archivedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchivedPeriodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
