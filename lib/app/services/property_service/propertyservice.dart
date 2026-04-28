import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/model/api_respond.dart';
import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/services/api_service/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyFilterModel {
  final String search;
  final String minPrice;
  final String maxPrice;
  final String bedrooms;
  final String bathrooms;
  final String locationCity;

  const PropertyFilterModel({
    this.search = '',
    this.minPrice = '',
    this.maxPrice = '',
    this.bedrooms = '',
    this.bathrooms = '',
    this.locationCity = '',
  });

  PropertyFilterModel copyWith({
    String? search,
    String? minPrice,
    String? maxPrice,
    String? bedrooms,
    String? bathrooms,
    String? locationCity,
  }) {
    return PropertyFilterModel(
      search: search ?? this.search,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      locationCity: locationCity ?? this.locationCity,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }

    if (minPrice.trim().isNotEmpty) {
      params['price[gte]'] = minPrice.trim();
    }

    if (maxPrice.trim().isNotEmpty) {
      params['price[lte]'] = maxPrice.trim();
    }

    if (bedrooms.trim().isNotEmpty) {
      params['bedrooms[gte]'] = bedrooms.trim();
    }

    if (bathrooms.trim().isNotEmpty) {
      params['bathrooms[gte]'] = bathrooms.trim();
    }

    if (locationCity.trim().isNotEmpty) {
      params['location.state'] = locationCity.trim();
    }

    params['limit'] = 20;

    return params;
  }

  bool get hasFilters {
    return search.trim().isNotEmpty ||
        minPrice.trim().isNotEmpty ||
        maxPrice.trim().isNotEmpty ||
        bedrooms.trim().isNotEmpty ||
        bathrooms.trim().isNotEmpty ||
        locationCity.trim().isNotEmpty;
  }
}

class PropertyService {
  PropertyService(this.ref);

  final Ref ref;

  final ApiService _apiService = ApiService(path: '/property');

  /// 🔍 SEARCH / FILTER PROPERTIES
  Future<ApiResponsModel<List<PropertyResponedModel>>> getProperties({
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiService.get(
      path: '/',
      queryParameters: queryParameters,
      requiresAuth: true,
    );

    log('Property response: $response');

    final model = ApiResponsModel<List<PropertyResponedModel>>.fromJson(
      response,
    );

    final List list = response['data'] ?? [];

    model.data = list.map((e) => PropertyResponedModel.fromJson(e)).toList();

    return model;
  }

  /// 📄 GET SINGLE PROPERTY (OPTIONAL)
  Future<ApiResponsModel<PropertyResponedModel>> getPropertyById({
    required String propertyId,
  }) async {
    final response = await _apiService.get(
      path: '/$propertyId',
      requiresAuth: true,
    );

    log('Single property response: $response');

    return ApiResponsModel<PropertyResponedModel>.fromJson(response)
      ..data = PropertyResponedModel.fromJson(response['data']);
  }

  Future<ApiResponsModel> addProperty({required FormData body}) async {
    final response = await _apiService.post(
      path: '/',
      body: body,
      requiresAuth: true,
    );

    log('Add property response: $response');

    return ApiResponsModel.fromJson(response);
  }
}

final propertyServiceProvider = Provider<PropertyService>((ref) {
  return PropertyService(ref);
});
