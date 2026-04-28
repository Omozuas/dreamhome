import 'package:dreamhome/app/apis/model/property_model.dart';
import 'package:dreamhome/app/services/locators/locator_services.dart';
import 'package:dreamhome/app/views/property-detail/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({super.key, required this.property});

  final PropertyResponedModel property;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatusBadge(text: property.status ?? 'Property'),
        SizedBox(width: sizeService.scaleW(8)),
        StatusBadge(
          text: property.isAvailable == true ? 'Available' : 'Unavailable',
          light: true,
        ),
      ],
    );
  }
}
