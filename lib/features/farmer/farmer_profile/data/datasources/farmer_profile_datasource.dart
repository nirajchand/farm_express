import 'dart:io';

import 'package:farm_express/features/farmer/farmer_profile/data/models/farmer_profile_api_model.dart';

abstract interface class IFarmerProfileRemoteDatasource {
  Future<FarmerProfileApiModel> getFarmerProfile();
  Future<FarmerProfileApiModel> updateProfile(FarmerProfileApiModel data,File? image);
}