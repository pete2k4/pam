import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/catalog_repository.dart';
import '../models/product.dart';
import '../models/store_data.dart';

enum CatalogStatus { loading, success, empty, error }

enum CatalogSort {
  defaultOrder('Default order'),
  priceAscending('Price: low to high'),
  priceDescending('Price: high to low');

  const CatalogSort(this.label);

  final String label;
}

class CatalogState {
  const CatalogState({
    required this.status,
    this.products = const [],
    this.catalog,
    this.categoryId = '',
    this.query = '',
    this.group = ProductGroup.all,
    this.sort = CatalogSort.defaultOrder,
    this.favoritesOnly = false,
    this.favoriteIds = const {},
  });

  final CatalogStatus status;
  final StoreData? catalog;
  final String categoryId;
  final List<Product> products;
  final String query;
  final ProductGroup group;
  final CatalogSort sort;
  final bool favoritesOnly;
  final Set<String> favoriteIds;
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repository)
    : super(const CatalogState(status: CatalogStatus.loading)) {
    _load();
  }

  final CatalogRepository _repository;
  StoreData? _catalog;

  Future<void> _load() async {
    emit(const CatalogState(status: CatalogStatus.loading));
    try {
      final catalog = await _repository.load();
      if (isClosed) return;
      _catalog = catalog;
      final selected = catalog.categories.where(
        (category) => category.selected,
      );
      _update(
        categoryId: selected.isEmpty ? '' : selected.first.id,
        favoriteIds: {
          for (final product in catalog.products)
            if (product.isFavorite) product.id,
        },
      );
    } on Object {
      if (isClosed) return;
      emit(const CatalogState(status: CatalogStatus.error));
    }
  }

  void retry() {
    if (state.status == CatalogStatus.error) _load();
  }

  void filterByCategory(String categoryId) => _update(categoryId: categoryId);

  void resetFilters() => _update(
    query: '',
    group: ProductGroup.all,
    categoryId: '',
    sort: CatalogSort.defaultOrder,
    favoritesOnly: false,
  );

  void search(String query) => _update(query: query);

  void filterByGroup(ProductGroup group) => _update(group: group);

  void sortBy(CatalogSort sort) => _update(sort: sort);

  void showFavorites(bool value) => _update(favoritesOnly: value);

  void toggleFavorite(String id) {
    final favoriteIds = {...state.favoriteIds};
    if (!favoriteIds.remove(id)) favoriteIds.add(id);
    _update(favoriteIds: favoriteIds);
  }

  void _update({
    String? query,
    String? categoryId,
    ProductGroup? group,
    CatalogSort? sort,
    bool? favoritesOnly,
    Set<String>? favoriteIds,
  }) {
    final selectedQuery = query ?? state.query;
    final selectedCategory = categoryId ?? state.categoryId;
    final selectedGroup = group ?? state.group;
    final selectedSort = sort ?? state.sort;
    final onlyFavorites = favoritesOnly ?? state.favoritesOnly;
    final selectedFavorites = favoriteIds ?? state.favoriteIds;
    final searchText = selectedQuery.trim().toLowerCase();

    final products = _catalog!.products.where((product) {
      return (selectedCategory.isEmpty ||
              product.categoryId == selectedCategory) &&
          product.name.toLowerCase().contains(searchText) &&
          (selectedGroup == ProductGroup.all ||
              product.group == selectedGroup) &&
          (!onlyFavorites || selectedFavorites.contains(product.id));
    }).toList();

    switch (selectedSort) {
      case CatalogSort.defaultOrder:
        break;
      case CatalogSort.priceAscending:
        products.sort((a, b) => a.price.compareTo(b.price));
      case CatalogSort.priceDescending:
        products.sort((a, b) => b.price.compareTo(a.price));
    }

    emit(
      CatalogState(
        status: products.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
        products: List.unmodifiable(products),
        catalog: _catalog,
        categoryId: selectedCategory,
        query: selectedQuery,
        group: selectedGroup,
        sort: selectedSort,
        favoritesOnly: onlyFavorites,
        favoriteIds: Set.unmodifiable(selectedFavorites),
      ),
    );
  }
}
