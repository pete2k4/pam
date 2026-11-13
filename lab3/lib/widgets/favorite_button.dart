import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/catalog_cubit.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select(
      (CatalogCubit cubit) => cubit.state.favoriteIds.contains(productId),
    );

    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: const Color(0x22000000),
      child: SizedBox(
        width: 36,
        height: 36,
        child: IconButton(
          padding: EdgeInsets.zero,
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          iconSize: 20,
          color: isFavorite ? const Color(0xFFFF6B74) : const Color(0xFF1D1F22),
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          ),
          onPressed: () =>
              context.read<CatalogCubit>().toggleFavorite(productId),
        ),
      ),
    );
  }
}
