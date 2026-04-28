import 'dart:async';

import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/services/navigation_services/navigator_services.dart';
import 'package:dreamhome/app/services/property_service/propertyservice.dart';
import 'package:dreamhome/app/services/provider_service/property_repo.dart';
import 'package:dreamhome/app/views/add-property/add_property_screen.dart';
import 'package:dreamhome/app/views/home_screen/widgets/header_top.dart';
import 'package:dreamhome/app/views/home_screen/widgets/search_input.dart';
import 'package:dreamhome/app/views/home_screen/widgets/small_filter_input.dart';
import 'package:dreamhome/app/views/home_screen/widgets/property_card.dart';
import 'package:dreamhome/app/views/home_screen/widgets/property_list_shimmer.dart';
import 'package:dreamhome/app/views/property-detail/property_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final _searchController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _locationController = TextEditingController();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(propertyFilterProvider.notifier).state = PropertyFilterModel(
        search: _searchController.text,
        minPrice: _minPriceController.text,
        maxPrice: _maxPriceController.text,
        bedrooms: _bedroomsController.text,
        bathrooms: _bathroomsController.text,
        locationCity: _locationController.text,
      );
    });
  }

  void _clearFilters() {
    _searchController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _bedroomsController.clear();
    _bathroomsController.clear();
    _locationController.clear();

    ref.read(propertyFilterProvider.notifier).state =
        const PropertyFilterModel();
  }

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    final properties = ref.watch(propertyListProvider);
    final filter = ref.watch(propertyFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        onPressed: () {
          navigationService.push(
            const AddPropertyScreen(),
            transition: AppRouteTransition.slideFromBottom,
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: sizeService.scalePaddingSymmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTop(onClear: _clearFilters, showClear: filter.hasFilters),

              SizedBox(height: sizeService.scaleH(18)),

              SearchInput(
                controller: _searchController,
                onChanged: (_) => _onFilterChanged(),
              ),

              SizedBox(height: sizeService.scaleH(12)),

              Row(
                children: [
                  Expanded(
                    child: SmallFilterInput(
                      controller: _minPriceController,
                      label: 'Min Price',
                      icon: Icons.payments_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _onFilterChanged(),
                    ),
                  ),
                  SizedBox(width: sizeService.scaleW(10)),
                  Expanded(
                    child: SmallFilterInput(
                      controller: _maxPriceController,
                      label: 'Max Price',
                      icon: Icons.price_change_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _onFilterChanged(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: sizeService.scaleH(10)),

              Row(
                children: [
                  Expanded(
                    child: SmallFilterInput(
                      controller: _bedroomsController,
                      label: 'Beds',
                      icon: Icons.bed_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _onFilterChanged(),
                    ),
                  ),
                  SizedBox(width: sizeService.scaleW(10)),
                  Expanded(
                    child: SmallFilterInput(
                      controller: _bathroomsController,
                      label: 'Baths',
                      icon: Icons.bathtub_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _onFilterChanged(),
                    ),
                  ),
                  SizedBox(width: sizeService.scaleW(10)),
                  Expanded(
                    flex: 2,
                    child: SmallFilterInput(
                      controller: _locationController,
                      label: 'State',
                      icon: Icons.location_city_rounded,
                      keyboardType: TextInputType.text,
                      onChanged: (_) => _onFilterChanged(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: sizeService.scaleH(18)),

              Expanded(
                child: properties.when(
                  loading: () => const PropertyListShimmer(),
                  error: (error, _) {
                    return Center(
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.body(color: AppColors.error),
                      ),
                    );
                  },
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No properties found',
                          style: AppTextStyle.body(color: AppColors.textMuted),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        ref.invalidate(propertyListProvider);
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final property = items[index];

                          return PropertyCard(
                            property: property,
                            onTap: () {
                              // log("tapppp");
                              navigationService.push(
                                PropertyDetailScreen(
                                  propertyId: property.id ?? '',
                                ),
                                transition: AppRouteTransition.slideFromRight,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
