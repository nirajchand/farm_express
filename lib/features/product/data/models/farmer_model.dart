// lib/features/product/data/models/farmer_model.dart
import '../../domain/entities/farmer_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farmer_model.g.dart';

@JsonSerializable()
class FarmerModel {
  @JsonKey(name: '_id')
  final String id;
  final String? farmName;
  final String? farmLocation;
  final String? description;
  final String? phoneNumber;

  FarmerModel({
    required this.id,
    this.farmName,
    this.farmLocation,
    this.description,
    this.phoneNumber,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerModelToJson(this);

  FarmerEntity toEntity() {
    return FarmerEntity(
      id: id,
      farmName: farmName,
      farmLocation: farmLocation,
      description: description,
      phoneNumber: phoneNumber,
    );
  }
}
