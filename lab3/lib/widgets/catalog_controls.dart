import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../state/catalog_cubit.dart';

class CatalogControls extends StatelessWidget {
  const CatalogControls({
    required this.state,
    required this.searchController,
    required this.onReset,
    super.key,
  });

  final CatalogState state;
  final TextEditingController searchController;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search products',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: cubit.search,
          ),
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<String>(
                style: const TextStyle(fontSize: 12, color: Color(0xFF1D1F22)),
                value: state.categoryId,
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('All categories'),
                  ),
                  for (final category in state.catalog!.categories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                ],
                onChanged: (category) => cubit.filterByCategory(category!),
              ),
              DropdownButton<ProductGroup>(
                style: const TextStyle(fontSize: 12, color: Color(0xFF1D1F22)),
                value: state.group,
                items: [
                  for (final group in ProductGroup.values)
                    DropdownMenuItem(value: group, child: Text(group.label)),
                ],
                onChanged: (group) => cubit.filterByGroup(group!),
              ),
              DropdownButton<CatalogSort>(
                style: const TextStyle(fontSize: 12, color: Color(0xFF1D1F22)),
                value: state.sort,
                items: [
                  for (final sort in CatalogSort.values)
                    DropdownMenuItem(value: sort, child: Text(sort.label)),
                ],
                onChanged: (sort) => cubit.sortBy(sort!),
              ),
              FilterChip(
                label: const Text('Favorites'),
                selected: state.favoritesOnly,
                onSelected: cubit.showFavorites,
              ),
              TextButton(onPressed: onReset, child: const Text('Reset')),
            ],
          ),
        ],
      ),
    );
  }
}
