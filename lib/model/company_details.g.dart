// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyDetailsModelAdapter extends TypeAdapter<CompanyDetailsModel> {
  @override
  final int typeId = 0;

  @override
  CompanyDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyDetailsModel(
      name: fields[0] as String,
      address: fields[1] as String,
      mobileNumber: fields[2] as String,
      gstNumber: fields[3] as String,
      bankName: fields[4] as String,
      ifsc: fields[5] as String,
      accountNo: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyDetailsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.mobileNumber)
      ..writeByte(3)
      ..write(obj.gstNumber)
      ..writeByte(4)
      ..write(obj.bankName)
      ..writeByte(5)
      ..write(obj.ifsc)
      ..writeByte(6)
      ..write(obj.accountNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
