// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MasterCustomerAdapter extends TypeAdapter<MasterCustomer> {
  @override
  final int typeId = 3;

  @override
  MasterCustomer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MasterCustomer(
      master_customer_Name: fields[0] as String,
      master_customer_address: fields[1] as String,
      master_customer_phone: fields[2] as String,
      master_customer_gst: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MasterCustomer obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.master_customer_Name)
      ..writeByte(1)
      ..write(obj.master_customer_address)
      ..writeByte(2)
      ..write(obj.master_customer_phone)
      ..writeByte(3)
      ..write(obj.master_customer_gst);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterCustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
