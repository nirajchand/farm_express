import 'dart:io';

import 'package:farm_express/features/consumer_profile/data/models/profile_api_model.dart';

abstract interface class IConsumerProfileRemoteDatasource {
  Future<ProfileApiModel> getConsumerProfile();
  Future<ProfileApiModel> updateProfile(ProfileApiModel data,File? image);
}
