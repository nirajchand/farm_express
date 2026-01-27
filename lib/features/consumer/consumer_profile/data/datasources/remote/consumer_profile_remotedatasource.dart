import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/api/app_client.dart';
import 'package:farm_express/core/services/storage/token_service.dart';
import 'package:farm_express/features/consumer/consumer_profile/data/datasources/consumer_profile_datasource.dart';
import 'package:farm_express/features/consumer/consumer_profile/data/models/profile_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumerProfileRemoteDatasourceProvider =
    Provider<ConsumerProfileRemotedatasource>((ref) {
      return ConsumerProfileRemotedatasource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class ConsumerProfileRemotedatasource
    implements IConsumerProfileRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ConsumerProfileRemotedatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<ProfileApiModel> updateProfile(
    ProfileApiModel data,
    File? image,
  ) async {
    final fileName = image?.path.split("/").last;
    final token = await _tokenService.getToken();

    // final formData = FormData.fromMap({
    //   "fullName": data.fullName,
    //   "email": data.email,
    //   "phoneNumber": data.phoneNumber,
    //   "userLocation": data.location,
    //   if (image != null)
    //     "profile_image": await MultipartFile.fromFile(
    //       image.path,
    //       filename: fileName,
    //     ),
    // });

    final formData = FormData.fromMap({
      if (data.fullName != null) "fullName": data.fullName,
      if (data.email != null) "email": data.email,
      if (data.phoneNumber != null) "phoneNumber": data.phoneNumber,
      if (data.location != null) "userLocation": data.location,
      if (image != null)
        "profile_image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
    });

    final response = await _apiClient.updateFile(
      ApiEndpoints.updateProfile,
      formData: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final responseData = ProfileApiModel.fromJson(response.data);

    return responseData;
  }

  @override
  Future<ProfileApiModel> getConsumerProfile() async {
    final token = await _tokenService.getToken();
    final user = await _apiClient.get(
      ApiEndpoints.getProfile,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = user.data['data'];
    return ProfileApiModel.fromJson(data);
  }
}
