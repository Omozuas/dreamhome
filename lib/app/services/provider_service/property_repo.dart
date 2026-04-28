import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/services/property_service/propertyservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final propertyFilterProvider = StateProvider.autoDispose<PropertyFilterModel>((
  ref,
) {
  return const PropertyFilterModel();
});

final propertyListProvider =
    FutureProvider.autoDispose<List<PropertyResponedModel>>((ref) async {
      final filter = ref.watch(propertyFilterProvider);

      final response = await ref
          .read(propertyServiceProvider)
          .getProperties(queryParameters: filter.toQueryParameters());

      return response.data ?? [];
    });

final propertyDetailProvider = FutureProvider.autoDispose
    .family<PropertyResponedModel, String>((ref, propertyId) async {
      final response = await ref
          .read(propertyServiceProvider)
          .getPropertyById(propertyId: propertyId);

      final property = response.data;

      if (property == null) {
        throw Exception('Property not found');
      }

      return property;
    });
