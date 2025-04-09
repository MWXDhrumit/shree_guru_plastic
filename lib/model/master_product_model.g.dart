// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MasterProductAdapter extends TypeAdapter<MasterProduct> {
  @override
  final int typeId = 4;

  @override
  MasterProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MasterProduct(
      master_product_Name: fields[0] as String,
      master_product_hsnCode: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MasterProduct obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.master_product_Name)
      ..writeByte(1)
      ..write(obj.master_product_hsnCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
