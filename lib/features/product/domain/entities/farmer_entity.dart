// lib/features/product/domain/entities/farmer_entity.dart
class FarmerEntity {
  final String id;
  final String? farmName;
  final String? farmLocation;
  final String? description;
  final String? phoneNumber;

  const FarmerEntity({
    required this.id,
    this.farmName,
    this.farmLocation,
    this.description,
    this.phoneNumber,
  });
}
