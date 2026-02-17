import 'dart:io';

import 'package:dio/dio.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/api/app_client.dart';
import 'package:farm_express/core/services/storage/token_service.dart';
import 'package:farm_express/features/farmer/farmer_profile/data/datasources/farmer_profile_datasource.dart';
import 'package:farm_express/features/farmer/farmer_profile/data/models/farmer_profile_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final farmerProfileRemoteDatasourceProvider =
    Provider<FarmerProfileRemoteDatasource>((ref) {
      return FarmerProfileRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class FarmerProfileRemoteDatasource
    implements IFarmerProfileRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  FarmerProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<FarmerProfileApiModel> updateProfile(
    FarmerProfileApiModel data,
    File? image,
  ) async {
    final fileName = image?.path.split("/").last;
    final token = await _tokenService.getToken();

    final formData = FormData.fromMap({
      if (data.fullName != null) "fullName": data.fullName,
      if (data.email != null) "email": data.email,
      if (data.farmName != null) "farmName": data.farmName,
      if (data.description != null) "description": data.description,
      if (data.farmLocation != null) "farmLocation": data.farmLocation,
      if (data.phoneNumber != null) "phoneNumber": data.phoneNumber,
      if (image != null)
        "profile_image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
    });

    final response = await _apiClient.updateFile(
      ApiEndpoints.updateFarmerProfile,
      formData: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final responseData = FarmerProfileApiModel.fromJson(response.data);

    return responseData;
  }

  @override
  Future<FarmerProfileApiModel> getFarmerProfile() async {
    final token = await _tokenService.getToken();
    final user = await _apiClient.get(
      ApiEndpoints.getFarmerProfile,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = user.data['data'];
    return FarmerProfileApiModel.fromJson(data);
  }
}
