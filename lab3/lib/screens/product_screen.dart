import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../state/catalog_cubit.dart';
import '../widgets/favorite_button.dart';
import '../widgets/product_card.dart';
import '../widgets/rating_stars.dart';
import '../widgets/store_image.dart';

const _green = Color(0xFF508A7B);

class ProductScreen extends StatefulWidget {
  const ProductScreen({required this.product, super.key});

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late String _color;
  late String _size;
  late bool _descriptionExpanded;
  int _galleryPage = 0;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();
    _color = product.selectedColor;
    _size = product.selectedSize;
    _descriptionExpanded = product.descriptionExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFAF8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _productHero()),
              SliverToBoxAdapter(child: _productSheet()),
              const SliverToBoxAdapter(child: SizedBox(height: 98)),
            ],
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _cartBar()),
        ],
      ),
    );
  }

  Widget _productHero() {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 380,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: product.galleryImages.length,
              onPageChanged: (page) => setState(() => _galleryPage = page),
              itemBuilder: (context, index) => StoreImage(
                image: product.galleryImages[index],
                width: MediaQuery.sizeOf(context).width,
                height: 380,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 28,
              top: 16,
              child: Material(
                color: Colors.white,
                elevation: 2,
                shadowColor: const Color(0x22000000),
                shape: const CircleBorder(),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: 'Back',
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 28,
              top: 16,
              child: FavoriteButton(productId: product.id),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (
                    var index = 0;
                    index < product.galleryImages.length;
                    index++
                  )
                    _Dot(selected: index == _galleryPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productSheet() {
    return Transform.translate(
      offset: const Offset(0, -1),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(31, 48, 31, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  product.priceLabel,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                RatingStars(rating: product.rating),
                const SizedBox(width: 9),
                Text(
                  '(${product.ratingCount})',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777E91),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 16),
            _options(),
            const SizedBox(height: 26),
            _sectionHeader('Description'),
            const SizedBox(height: 20),
            Text(
              product.description,
              maxLines: _descriptionExpanded ? null : 4,
              overflow: _descriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.65,
                color: Color(0xFF56575A),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(
                  () => _descriptionExpanded = !_descriptionExpanded,
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(80, 30),
                ),
                child: Text(
                  _descriptionExpanded ? 'Read less' : 'Read more',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _sectionHeader('Reviews'),
            const SizedBox(height: 24),
            if (product.ratingCount == 0)
              const Text(
                'No reviews yet.',
                style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8F)),
              )
            else ...[
              _ratings(),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.reviewCount} Reviews',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A8A8F),
                    ),
                  ),
                  const Text(
                    'WRITE A REVIEW  ✎',
                    style: TextStyle(fontSize: 11, color: Color(0xFFB5B5BA)),
                  ),
                ],
              ),
              for (final review in product.reviews) ...[
                const SizedBox(height: 24),
                _review(review),
              ],
            ],
            const SizedBox(height: 24),
            _sectionHeader('Similar Product'),
            const SizedBox(height: 25),
            _similarProducts(),
          ],
        ),
      ),
    );
  }

  Widget _options() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Color',
                style: TextStyle(fontSize: 14, color: Color(0xFF777E91)),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final color in product.colors)
                    Semantics(
                      button: true,
                      selected: _color == color.id,
                      label: color.name,
                      child: Tooltip(
                        message: color.name,
                        child: GestureDetector(
                          onTap: () => setState(() => _color = color.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 34,
                            height: 34,
                            padding: EdgeInsets.all(_color == color.id ? 5 : 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: _color == color.id
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x30000000),
                                        blurRadius: 7,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(color.value),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 116,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Size',
                style: TextStyle(fontSize: 14, color: Color(0xFF777E91)),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final size in product.sizes)
                    Semantics(
                      button: true,
                      enabled: product.sizeAvailability[size] == true,
                      selected: _size == size,
                      child: GestureDetector(
                        onTap: product.sizeAvailability[size] == true
                            ? () => setState(() => _size = size)
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 33,
                          height: 33,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _size == size
                                ? const Color(0xFF515151)
                                : const Color(0xFFFAFAFA),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 12,
                              color: _size == size
                                  ? Colors.white
                                  : product.sizeAvailability[size] == true
                                  ? const Color(0xFF515151)
                                  : const Color(0xFFC5C5C5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF33302E),
            ),
          ],
        ),
        const SizedBox(height: 11),
        const Divider(height: 1, color: Color(0xFFF0F0F3)),
      ],
    );
  }

  Widget _ratings() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 40,
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12, left: 8),
                      child: Text(
                        'OUT OF 5',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A8A8F),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RatingStars(rating: product.rating),
                const SizedBox(height: 3),
                Text(
                  '${product.ratingCount} ratings',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8A8A8F),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (final row in product.ratingBreakdown)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                  child: Text(
                    '${row.stars}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8A8A8F),
                    ),
                  ),
                ),
                const Icon(Icons.star_rounded, size: 14, color: _green),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: row.percentage / 100,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFEFEFF1),
                      valueColor: const AlwaysStoppedAnimation<Color>(_green),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 28,
                  child: Text(
                    '${row.percentage.toStringAsFixed(0)}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _review(ProductReview review) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoreImage(image: review.avatar, width: 38, height: 38, radius: 19),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.author,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    review.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB8B8BB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              RatingStars(rating: review.rating, size: 14),
              const SizedBox(height: 13),
              Text(
                review.text,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.55,
                  color: Color(0xFF56575A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _similarProducts() {
    final products = context.read<CatalogCubit>().state.catalog!.products;
    final similar = [
      for (final id in product.similarProductIds)
        products.firstWhere((item) => item.id == id),
    ];
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: similar.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final item = similar[index];
          return SizedBox(
            width: 126,
            child: ProductCard(
              product: item,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProductScreen(product: item),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cartBar() {
    final enabled =
        product.canAddToCart && product.sizeAvailability[_size] == true;
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF343434) : Colors.grey,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          onTap: enabled
              ? () {
                  final color = product.colors.firstWhere(
                    (color) => color.id == _color,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.name} added to cart (${color.name}, $_size)',
                      ),
                    ),
                  );
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_rounded,
                size: 23,
                color: Colors.white,
              ),
              const SizedBox(width: 14),
              Text(
                product.addToCartLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: selected ? 10 : 5,
      height: selected ? 10 : 5,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.white : const Color(0xFF565656),
        border: selected ? Border.all(color: const Color(0xFF565656)) : null,
      ),
    );
  }
}
