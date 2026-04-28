import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/common/app_text_style.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/services/provider_service/property_repo.dart';
import 'package:dreamhome/app/views/property-detail/widgets/amenities_list.dart';
import 'package:dreamhome/app/views/property-detail/widgets/contact_agent_field.dart';
import 'package:dreamhome/app/views/property-detail/widgets/contact_button.dart';
import 'package:dreamhome/app/views/property-detail/widgets/feature_chip.dart';
import 'package:dreamhome/app/views/property-detail/widgets/image_gallerys.dart';
import 'package:dreamhome/app/views/property-detail/widgets/owner_card.dart';
import 'package:dreamhome/app/views/property-detail/widgets/price_box.dart';
import 'package:dreamhome/app/views/property-detail/widgets/property_detail_shimmer.dart';
import 'package:dreamhome/app/views/property-detail/widgets/read_more_text.dart';
import 'package:dreamhome/app/views/property-detail/widgets/section_title.dart';
import 'package:dreamhome/app/views/property-detail/widgets/status_row.dart';
import 'package:dreamhome/app/views/property-detail/widgets/top_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  int _imageIndex = 0;
  bool _readMore = false;

  String _money(num? value) {
    return '₦${(value ?? 0).toStringAsFixed(0)}';
  }

  String _location(PropertyResponedModel property) {
    final location = property.location;

    final parts = [
      location?.address,
      location?.city,
      location?.state,
      location?.country,
    ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

    return parts.isEmpty ? 'No location provided' : parts;
  }

  Future<void> _contactAgent(PropertyResponedModel property) async {
    final phone = property.owner?.user?.phoneNumber;

    if (phone == null || phone.trim().isEmpty) {
      snackbarService.showErrorPopup(
        message: 'Agent phone number not available',
      );
      return;
    }

    final uri = Uri.parse('tel:$phone');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      snackbarService.showErrorPopup(message: 'Unable to open phone dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    final propertyState = ref.watch(propertyDetailProvider(widget.propertyId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: propertyState.when(
        loading: () => const PropertyDetailShimmer(),
        error: (error, _) {
          return SafeArea(
            child: Column(
              children: [
                TopBackButton(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: sizeService.scalePaddingAll(24),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.body(color: AppColors.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        data: (property) {
          final images = property.images
              .where((image) => image.url != null && image.url!.isNotEmpty)
              .toList();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: sizeService.scalePaddingOnly(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageGallerys(
                      images: images,
                      imageIndex: _imageIndex,
                      onChanged: (index) {
                        setState(() => _imageIndex = index);
                      },
                    ),

                    Padding(
                      padding: sizeService.scalePaddingSymmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusRow(property: property),

                          SizedBox(height: sizeService.scaleH(14)),

                          Text(
                            property.title ?? 'Untitled Property',
                            style: AppTextStyle.base(
                              size: 24,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: sizeService.scaleH(8)),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: AppColors.primary,
                                size: sizeService.scaleIcon(18),
                              ),
                              SizedBox(width: sizeService.scaleW(5)),
                              Expanded(
                                child: Text(
                                  _location(property),
                                  style: AppTextStyle.body(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: sizeService.scaleH(18)),

                          Row(
                            children: [
                              Expanded(
                                child: PriceBox(
                                  title: 'Property Price',
                                  value: _money(property.price),
                                ),
                              ),
                              SizedBox(width: sizeService.scaleW(12)),
                              Expanded(
                                child: PriceBox(
                                  title: 'Agent Fee',
                                  value: _money(property.agentFee),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: sizeService.scaleH(16)),

                          Row(
                            children: [
                              FeatureChip(
                                icon: Icons.bed_rounded,
                                text: '${property.bedrooms ?? 0} Beds',
                              ),
                              SizedBox(width: sizeService.scaleW(8)),
                              FeatureChip(
                                icon: Icons.bathtub_rounded,
                                text: '${property.bathrooms ?? 0} Baths',
                              ),
                              SizedBox(width: sizeService.scaleW(8)),
                              FeatureChip(
                                icon: Icons.square_foot_rounded,
                                text: '${property.size ?? 0} sqm',
                              ),
                            ],
                          ),

                          SizedBox(height: sizeService.scaleH(26)),

                          SectionTitle(title: 'Description'),

                          SizedBox(height: sizeService.scaleH(8)),

                          ReadMoreText(
                            text:
                                property.description ??
                                'No description available.',
                            expanded: _readMore,
                            onTap: () {
                              setState(() => _readMore = !_readMore);
                            },
                          ),

                          if (property.amenities.isNotEmpty) ...[
                            SizedBox(height: sizeService.scaleH(26)),

                            SectionTitle(title: 'Amenities'),

                            SizedBox(height: sizeService.scaleH(12)),

                            AmenitiesList(amenities: property.amenities),
                          ],
                          SizedBox(height: sizeService.scaleH(26)),
                          SectionTitle(title: 'Owner / Agent'),

                          SizedBox(height: sizeService.scaleH(12)),

                          OwnerCard(property: property),

                          SizedBox(height: sizeService.scaleH(28)),

                          SectionTitle(title: 'Contact Agent'),

                          SizedBox(height: sizeService.scaleH(12)),

                          ContactAgentField(property: property),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(child: TopBackButton()),
              ),

              Positioned(
                left: sizeService.scaleW(20),
                right: sizeService.scaleW(20),
                bottom: sizeService.scaleH(22),
                child: ContactButton(onTap: () => _contactAgent(property)),
              ),
            ],
          );
        },
      ),
    );
  }
}
