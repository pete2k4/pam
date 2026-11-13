import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({required this.rating, this.size = 20, super.key});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating.round()
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          size: size,
          color: const Color(0xFF508A7B),
        ),
      ),
    );
  }
}
