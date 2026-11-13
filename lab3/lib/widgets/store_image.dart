import 'package:flutter/material.dart';

import '../models/product.dart';
import 'reference_crop.dart';

class StoreImage extends StatelessWidget {
  const StoreImage({
    required this.image,
    required this.width,
    required this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
    super.key,
  });

  final StoreImageData image;
  final double width;
  final double height;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final crop = image.crop;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: FittedBox(
          fit: fit,
          clipBehavior: Clip.hardEdge,
          child: ReferenceCrop(
            asset: image.asset,
            crop: Rect.fromLTWH(crop[0], crop[1], crop[2], crop[3]),
            width: crop[2],
            height: crop[3],
          ),
        ),
      ),
    );
  }
}
