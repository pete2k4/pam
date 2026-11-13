import 'package:flutter/material.dart';

/// Displays one photographic region from a supplied design screenshot.
/// Crop coordinates use the 375px-wide source canvas from the CSS export.
class ReferenceCrop extends StatelessWidget {
  const ReferenceCrop({
    required this.asset,
    required this.crop,
    required this.width,
    required this.height,
    this.radius = 0,
    super.key,
  });

  final String asset;
  final Rect crop;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scale = width / crop.width;
    final sourceWidth = 375 * scale;
    final sourceHeight = (asset.contains('home') ? 1714 : 1818) * scale;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: OverflowBox(
            minWidth: sourceWidth,
            maxWidth: sourceWidth,
            minHeight: sourceHeight,
            maxHeight: sourceHeight,
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(-crop.left * scale, -crop.top * scale),
              child: Image.asset(
                asset,
                width: sourceWidth,
                height: sourceHeight,
                fit: BoxFit.fill,
                alignment: Alignment.topLeft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
