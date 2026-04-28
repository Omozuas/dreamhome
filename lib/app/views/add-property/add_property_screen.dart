import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dreamhome/app/apis/base_service/api_failure.dart';
import 'package:dreamhome/app/common/custom_button.dart';
import 'package:dreamhome/app/common/custom_input.dart';
import 'package:dreamhome/app/common/theme/globa_colors.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/services/provider_service/add_property_provider.dart';
import 'package:dreamhome/app/services/provider_service/property_repo.dart';
import 'package:dreamhome/app/views/add-property/widgets/amenities_selector.dart';
import 'package:dreamhome/app/views/add-property/widgets/dropdown_field.dart';
import 'package:dreamhome/app/views/add-property/widgets/header2.dart';
import 'package:dreamhome/app/views/add-property/widgets/image_picker_box.dart';
import 'package:dreamhome/app/views/add-property/widgets/section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyScreen extends ConsumerStatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  ConsumerState<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends ConsumerState<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _sizeController = TextEditingController();
  final _agentFeeController = TextEditingController();
  final _inspectionFeeController = TextEditingController();

  final _countryController = TextEditingController(text: 'Nigeria');
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  final _picker = ImagePicker();

  String _type = '';
  String _status = '';
  String _furnishingStatus = 'Unfurnished';
  String _paymentFrequency = '';

  final List<File> _images = [];
  final List<String> _amenities = [];

  static const List<String> _types = [
    'Apartment',
    'Bedsitter',
    'Land',
    'Commercial',
    'Duplex',
    'Self_contain',
    'Flat',
    'Boys_quarters',
    'Mansion',
  ];

  static const List<String> _statuses = ['For_Sale', 'For_Rent', 'Sold'];

  static const List<String> _furnishingStatuses = [
    'Furnished',
    'Unfurnished',
    'Semi_Furnished',
  ];

  static const List<String> _paymentFrequencies = [
    'per_year',
    'per_month',
    'per_week',
  ];

  static const List<String> _allAmenities = [
    'WiFi',
    'Cable_TV',
    'Electricity',
    'Water_Supply',
    'Solar_Power',
    'Generator',
    'Inverter',
    'Security',
    'CCTV',
    'Gated_Community',
    'Security_Guards',
    'Smart_Lock',
    'Fire_Alarm',
    'Smoke_Detector',
    'Air_Conditioning',
    'Heating',
    'Ceiling_Fans',
    'Refrigerator',
    'Microwave',
    'Dishwasher',
    'Washing_Machine',
    'Dryer',
    'Cooker_Oven',
    'Parking',
    'Garage',
    'EV_Charging',
    'Elevator',
    'Wheelchair_Access',
    'Storage_Room',
    'Balcony',
    'Garden',
    'Terrace',
    'Rooftop',
    'Playground',
    'Swimming_Pool',
    'Gym',
    'Spa',
    'Sauna',
    'Clubhouse',
    'Study_Room',
    'Office_Space',
    'Conference_Room',
    'Cinema_Room',
    'Game_Room',
    'Barbecue_Area',
    'Laundry_Room',
    'Cleaning_Service',
    'Pet_Friendly',
    'Guest_Room',
    'Servant_Quarters',
  ];

  bool get _isLand => _type == 'Land';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _sizeController.dispose();
    _agentFeeController.dispose();
    _inspectionFeeController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);

    if (picked.isEmpty) return;

    final remainingSlots = 6 - _images.length;

    if (remainingSlots <= 0) {
      snackbarService.showErrorPopup(message: 'Maximum of 6 images allowed');
      return;
    }

    final selected = picked.take(remainingSlots).map((x) => File(x.path));

    setState(() {
      _images.addAll(selected);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (_amenities.contains(amenity)) {
        _amenities.remove(amenity);
      } else {
        _amenities.add(amenity);
      }
    });
  }

  Future<void> _submit() async {
    log("tttttt");
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_type.isEmpty) {
      snackbarService.showErrorPopup(message: 'Select property type');
      return;
    }

    if (_status.isEmpty) {
      snackbarService.showErrorPopup(message: 'Select property status');
      return;
    }

    if (_images.isEmpty) {
      snackbarService.showErrorPopup(message: 'Upload at least one image');
      return;
    }

    final data = FormData();

    data.fields.addAll([
      MapEntry('title', _titleController.text.trim()),
      MapEntry('description', _descriptionController.text.trim()),
      MapEntry('type', _type),
      MapEntry('status', _status),
      MapEntry('price', _priceController.text.trim()),
      MapEntry('country', _countryController.text.trim()),
      MapEntry('state', _stateController.text.trim()),
      MapEntry('city', _cityController.text.trim()),
      MapEntry('address', _addressController.text.trim()),
    ]);

    if (!_isLand) {
      data.fields.add(MapEntry('bedrooms', _bedroomsController.text.trim()));
      data.fields.add(MapEntry('bathrooms', _bathroomsController.text.trim()));
      data.fields.add(MapEntry('furnishingStatus', _furnishingStatus));
    }

    if (_status == 'For_Rent' && _paymentFrequency.isNotEmpty) {
      data.fields.add(MapEntry('paymentFrequency', _paymentFrequency));
    }

    if (_sizeController.text.trim().isNotEmpty) {
      data.fields.add(MapEntry('size', _sizeController.text.trim()));
    }

    if (_agentFeeController.text.trim().isNotEmpty) {
      data.fields.add(MapEntry('agentFee', _agentFeeController.text.trim()));
    }

    if (_inspectionFeeController.text.trim().isNotEmpty) {
      data.fields.add(
        MapEntry('inspectionFee', _inspectionFeeController.text.trim()),
      );
    }

    if (_latController.text.trim().isNotEmpty) {
      data.fields.add(MapEntry('lat', _latController.text.trim()));
    }

    if (_lngController.text.trim().isNotEmpty) {
      data.fields.add(MapEntry('lng', _lngController.text.trim()));
    }

    for (final amenity in _amenities) {
      data.fields.add(MapEntry('amenities', amenity));
    }

    for (final image in _images) {
      data.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }

    final success = await ref
        .read(addPropertyProvider.notifier)
        .addProperty(body: data);

    if (!mounted) return;

    if (success) {
      snackbarService.showSuccessPopup(message: 'Property uploaded');

      ref.invalidate(propertyListProvider);
      navigationService.pop();
    } else {
      final error = ref.read(addPropertyProvider).error as ApiFailure;
      snackbarService.showErrorPopup(message: error.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeService.updateFromContext(context);

    final state = ref.watch(addPropertyProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Header2(isLoading: isLoading),
              Expanded(
                child: SingleChildScrollView(
                  padding: sizeService.scalePaddingSymmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Section(title: 'Basic Details'),
                      CustomInput(
                        label: 'Property title',
                        placeholder: 'E.g A luxury 2 bedroom flat',
                        controller: _titleController,
                        textCapitalization: TextCapitalization.words,
                        validator: _required,
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      CustomInput(
                        label: 'Description',
                        placeholder: 'Describe the property in full',
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        validator: _required,
                      ),

                      SizedBox(height: sizeService.scaleH(28)),
                      Section(title: 'Location'),
                      CustomInput(
                        label: 'Country',
                        placeholder: 'Country',
                        controller: _countryController,
                        validator: _required,
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      CustomInput(
                        label: 'State',
                        placeholder: 'State',
                        controller: _stateController,
                        validator: _required,
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      CustomInput(
                        label: 'City',
                        placeholder: 'City',
                        controller: _cityController,
                        validator: _required,
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      CustomInput(
                        label: 'Address',
                        placeholder: 'Enter full address',
                        controller: _addressController,
                        validator: _required,
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInput(
                              label: 'Latitude',
                              placeholder: 'Optional',
                              controller: _latController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                          SizedBox(width: sizeService.scaleW(12)),
                          Expanded(
                            child: CustomInput(
                              label: 'Longitude',
                              placeholder: 'Optional',
                              controller: _lngController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: sizeService.scaleH(28)),
                      Section(title: 'Property Specifications'),
                      DropdownField(
                        label: 'Type',
                        value: _type,
                        hint: 'Select property type',
                        items: _types,
                        onChanged: (value) {
                          setState(() {
                            _type = value ?? '';
                            if (_isLand) {
                              _bedroomsController.clear();
                              _bathroomsController.clear();
                              _amenities.clear();
                            }
                          });
                        },
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      DropdownField(
                        label: 'Status',
                        value: _status,
                        hint: 'Select property status',
                        items: _statuses,
                        onChanged: (value) {
                          setState(() {
                            _status = value ?? '';
                            if (_status != 'For_Rent') {
                              _paymentFrequency = '';
                            }
                          });
                        },
                      ),
                      if (!_isLand) ...[
                        SizedBox(height: sizeService.scaleH(16)),
                        DropdownField(
                          label: 'Furnishing Status',
                          value: _furnishingStatus,
                          hint: 'Select furnishing',
                          items: _furnishingStatuses,
                          onChanged: (value) {
                            setState(() {
                              _furnishingStatus = value ?? 'Unfurnished';
                            });
                          },
                        ),
                      ],
                      if (_status == 'For_Rent') ...[
                        SizedBox(height: sizeService.scaleH(16)),
                        DropdownField(
                          label: 'Payment Frequency',
                          value: _paymentFrequency,
                          hint: 'Select payment frequency',
                          items: _paymentFrequencies,
                          onChanged: (value) {
                            setState(() => _paymentFrequency = value ?? '');
                          },
                        ),
                      ],
                      if (!_isLand) ...[
                        SizedBox(height: sizeService.scaleH(16)),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInput(
                                label: 'Bedrooms',
                                placeholder: '0',
                                controller: _bedroomsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: _required,
                              ),
                            ),
                            SizedBox(width: sizeService.scaleW(12)),
                            Expanded(
                              child: CustomInput(
                                label: 'Bathrooms',
                                placeholder: '0',
                                controller: _bathroomsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: _required,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: sizeService.scaleH(16)),
                      CustomInput(
                        label: 'Price',
                        placeholder: 'Enter property price',
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _required,
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInput(
                              label: 'Agent Fee',
                              placeholder: 'Agent fee',
                              controller: _agentFeeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(width: sizeService.scaleW(12)),
                          Expanded(
                            child: CustomInput(
                              label: 'Inspection Fee',
                              placeholder: 'Inspection fee',
                              controller: _inspectionFeeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizeService.scaleH(16)),
                      CustomInput(
                        label: 'Property Size',
                        placeholder: 'Enter property size',
                        controller: _sizeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),

                      if (!_isLand) ...[
                        SizedBox(height: sizeService.scaleH(28)),
                        Section(title: 'Amenities'),
                        AmenitiesSelector(
                          amenities: _allAmenities,
                          selected: _amenities,
                          onToggle: _toggleAmenity,
                        ),
                      ],

                      SizedBox(height: sizeService.scaleH(28)),
                      Section(title: 'Media Uploads'),
                      ImagePickerBox(
                        images: _images,
                        onPick: _pickImages,
                        onRemove: _removeImage,
                      ),

                      SizedBox(height: sizeService.scaleH(32)),
                      AppButton(
                        text: 'Upload Property',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submit,
                        radius: 14,
                        vertical: 14,
                      ),
                      SizedBox(height: sizeService.scaleH(28)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }
}
