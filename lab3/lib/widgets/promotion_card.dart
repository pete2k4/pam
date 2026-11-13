import 'package:flutter/material.dart';

import '../models/store_data.dart';
import 'store_image.dart';

class PromotionCard extends StatelessWidget {
  const PromotionCard({
    required this.promotion,
    required this.height,
    required this.onTap,
    this.hero = false,
    this.imageOnLeft = false,
    super.key,
  });

  final StorePromotion promotion;
  final double height;
  final VoidCallback onTap;
  final bool hero;
  final bool imageOnLeft;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: [promotion.label, promotion.title, promotion.action].join(' '),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Container(
                height: height,
                color: hero ? const Color(0xFF9E8468) : const Color(0xFFF7F7F9),
                child: Stack(
                  children: [
                    Positioned(
                      left: hero || imageOnLeft ? 0 : null,
                      right: hero || imageOnLeft ? null : 0,
                      child: StoreImage(
                        image: promotion.image,
                        width: width * (hero ? .65 : .48),
                        height: height,
                      ),
                    ),
                    Positioned(
                      left: hero
                          ? width * .56
                          : imageOnLeft
                          ? width * .52
                          : 22,
                      right: imageOnLeft
                          ? 8
                          : hero
                          ? 10
                          : width * .43,
                      top: hero ? 20 : 22,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: hero
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          if (promotion.label.isNotEmpty) ...[
                            Text(
                              promotion.label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF777E91),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                          Flexible(
                            child: Text(
                              promotion.title,
                              style: TextStyle(
                                fontSize: hero
                                    ? 25
                                    : width < 220
                                    ? 18
                                    : 22,
                                fontWeight: hero
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: hero
                                    ? Colors.white
                                    : const Color(0xFF353742),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
