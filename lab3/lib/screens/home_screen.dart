import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../models/store_data.dart';
import '../state/catalog_cubit.dart';
import '../widgets/catalog_controls.dart';
import '../widgets/product_card.dart';
import '../widgets/promotion_card.dart';
import 'product_screen.dart';

const _muted = Color(0xFF9B9B9B);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showControls = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ProductScreen(product: product)),
    );
  }

  void _browse(ProductGroup group) {
    context.read<CatalogCubit>().filterByGroup(group);
    setState(() => _showControls = true);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _reset() {
    _searchController.clear();
    context.read<CatalogCubit>().resetFilters();
  }

  void _openPromotion(StorePromotion promotion) {
    _reset();
    context.read<CatalogCubit>().filterByCategory(promotion.categoryId);
    _browse(ProductGroup.all);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            if (state.status == CatalogStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == CatalogStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load the catalog.'),
                    TextButton(
                      onPressed: context.read<CatalogCubit>().retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final catalog = state.catalog!;
            final filtering =
                state.query.trim().isNotEmpty ||
                state.group != ProductGroup.all ||
                state.favoritesOnly ||
                state.sort != CatalogSort.defaultOrder;
            return CustomScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(child: _header(catalog.name)),
                SliverToBoxAdapter(
                  child: _categories(catalog, state.categoryId),
                ),
                if (_showControls)
                  SliverToBoxAdapter(
                    child: CatalogControls(
                      state: state,
                      searchController: _searchController,
                      onReset: _reset,
                    ),
                  ),
                if (state.status == CatalogStatus.empty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No products found.'),
                        TextButton(
                          onPressed: _reset,
                          child: const Text('All products'),
                        ),
                      ],
                    ),
                  )
                else if (filtering)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            mainAxisExtent: 240,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => _openProduct(product),
                        );
                      }, childCount: state.products.length),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: LayoutBuilder(
                        builder: (context, constraints) => PromotionCard(
                          promotion: catalog.hero,
                          height: constraints.maxWidth * 168 / 312,
                          hero: true,
                          onTap: () => _openPromotion(catalog.hero),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 38)),
                  SliverToBoxAdapter(
                    child: _sectionTitle(
                      'Feature Products',
                      ProductGroup.featured,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _productList(
                      state.products
                          .where(
                            (product) =>
                                catalog.featuredIds.contains(product.id),
                          )
                          .toList(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                  SliverToBoxAdapter(
                    child: PromotionCard(
                      promotion: catalog.newCollection,
                      height: 174,
                      onTap: () => _openPromotion(catalog.newCollection),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 35)),
                  SliverToBoxAdapter(
                    child: _sectionTitle(
                      'Recommended',
                      ProductGroup.recommended,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _productList(
                      state.products
                          .where(
                            (product) =>
                                catalog.recommendedIds.contains(product.id),
                          )
                          .toList(),
                      compact: true,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 36)),
                  SliverToBoxAdapter(
                    child: _sectionTitle('Top Collection', ProductGroup.all),
                  ),
                  SliverToBoxAdapter(child: _collections(catalog)),
                  const SliverToBoxAdapter(child: SizedBox(height: 28)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 22, 30, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: 'Search and filters',
            onPressed: () => setState(() => _showControls = !_showControls),
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.menu_rounded,
              size: 28,
              color: Color(0xFF33302E),
            ),
          ),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No new notifications')),
                ),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.notifications_none_rounded, size: 29),
              ),
              const Positioned(
                right: 8,
                top: 6,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xFFEF466F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categories(StoreData catalog, String selectedId) {
    const icons = {
      'female': Icons.female_rounded,
      'male': Icons.male_rounded,
      'glasses': Icons.remove_red_eye_outlined,
      'beauty': Icons.brush_outlined,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 26, 28),
      child: Row(
        children: [
          for (final category in catalog.categories)
            Expanded(
              child: Semantics(
                button: true,
                selected: selectedId == category.id,
                label: category.name,
                child: InkWell(
                  onTap: () => context.read<CatalogCubit>().filterByCategory(
                    category.id,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: selectedId == category.id
                              ? const Color(0xFF3A2C27)
                              : const Color(0xFFF3F3F3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[category.icon] ?? Icons.category_outlined,
                          size: 25,
                          color: selectedId == category.id
                              ? Colors.white
                              : const Color(0xFF9D9D9D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: selectedId == category.id
                              ? const Color(0xFF3A2C27)
                              : const Color(0xFF9D9D9D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ProductGroup group) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () => _browse(group),
            child: const Text(
              'Show all',
              style: TextStyle(fontSize: 14, color: _muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productList(List<Product> products, {bool compact = false}) {
    return SizedBox(
      height: compact ? 82 : 250,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          compact ? 32 : 35,
          compact ? 10 : 13,
          24,
          0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: compact ? 250 : 126,
            child: ProductCard(
              product: product,
              compact: compact,
              onTap: () => _openProduct(product),
            ),
          );
        },
      ),
    );
  }

  Widget _collections(StoreData catalog) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 13, 32, 0),
      child: Column(
        children: [
          for (final (index, promotion) in catalog.topCollections.indexed) ...[
            PromotionCard(
              promotion: promotion,
              height: index == 0 ? 148 : 210,
              onTap: () => _openPromotion(promotion),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 206,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: catalog.categoryPromos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 13),
              itemBuilder: (context, index) {
                final promotion = catalog.categoryPromos[index];
                return SizedBox(
                  width: 176,
                  child: PromotionCard(
                    promotion: promotion,
                    height: 206,
                    imageOnLeft: index.isEven,
                    onTap: () => _openPromotion(promotion),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
