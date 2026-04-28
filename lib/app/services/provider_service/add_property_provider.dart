import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/model/api_respond.dart';
import 'package:dreamhome/app/services/property_service/propertyservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final addPropertyProvider =
    StateNotifierProvider.autoDispose<
      AddPropertyNotifier,
      AsyncValue<ApiResponsModel?>
    >((ref) {
      return AddPropertyNotifier(ref);
    });

class AddPropertyNotifier extends StateNotifier<AsyncValue<ApiResponsModel?>> {
  AddPropertyNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<bool> addProperty({required FormData body}) async {
    state = const AsyncValue.loading();

    try {
      final response = await ref
          .read(propertyServiceProvider)
          .addProperty(body: body);

      state = AsyncValue.data(response);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}
