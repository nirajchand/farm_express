import 'package:equatable/equatable.dart';

class FarmerProfileEntity extends Equatable {
  final String? fullName;
  final String? email;
  final String? farmName;
  final String? description;
  final String? farmLocation;
  final String? phoneNumber;
  final String? profileImage;

  const FarmerProfileEntity({
    this.fullName,
    this.email,
    this.farmName,
    this.description,
    this.farmLocation,
    this.profileImage, this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [fullName,email,farmName,description,farmLocation,profileImage,phoneNumber];
}
