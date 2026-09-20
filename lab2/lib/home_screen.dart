import 'package:flutter/material.dart';

import 'product_screen.dart';
import 'widgets/reference_crop.dart';

const _homeReference = 'assets/home_reference.png';
const _muted = Color(0xFF9B9B9B);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  void _openProduct() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const ProductScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _categories()),
            SliverToBoxAdapter(child: _hero()),
            const SliverToBoxAdapter(child: SizedBox(height: 38)),
            SliverToBoxAdapter(child: _sectionTitle('Feature Products')),
            SliverToBoxAdapter(child: _featuredProducts()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            SliverToBoxAdapter(child: _promoBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 35)),
            SliverToBoxAdapter(child: _sectionTitle('Recommended')),
            SliverToBoxAdapter(child: _recommended()),
            const SliverToBoxAdapter(child: SizedBox(height: 36)),
            SliverToBoxAdapter(child: _sectionTitle('Top Collection')),
            SliverToBoxAdapter(child: _topCollection()),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 22, 30, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.menu_rounded,
              size: 28,
              color: Color(0xFF33302E),
            ),
          ),
          const Text(
            'GemStore',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
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

  Widget _categories() {
    const categories = <(String, IconData)>[
      ('Women', Icons.female_rounded),
      ('Men', Icons.male_rounded),
      ('Accessories', Icons.remove_red_eye_outlined),
      ('Beauty', Icons.brush_outlined),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 26, 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(categories.length, (index) {
          final selected = _selectedCategory == index;
          return Semantics(
            button: true,
            selected: selected,
            label: categories[index].$1,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => setState(() => _selectedCategory = index),
              child: SizedBox(
                width: 68,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF3A2C27)
                            : const Color(0xFFF3F3F3),
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: const Color(0xFF3A2C27),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Icon(
                        categories[index].$2,
                        size: 25,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF9D9D9D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categories[index].$1,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        color: selected
                            ? const Color(0xFF3A2C27)
                            : const Color(0xFF9D9D9D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _hero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: AspectRatio(
        aspectRatio: 312 / 168,
        child: LayoutBuilder(
          builder: (context, constraints) => ReferenceCrop(
            asset: _homeReference,
            crop: const Rect.fromLTWH(32, 215, 312, 168),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            radius: 15,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Show all',
              style: TextStyle(fontSize: 14, color: _muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuredProducts() {
    final products = [
      const _ProductData(
        'Turtleneck Sweater',
        '\$ 39.99',
        Rect.fromLTWH(35, 464, 126, 172),
      ),
      const _ProductData(
        'Long Sleeve Dress',
        '\$ 45.00',
        Rect.fromLTWH(181, 464, 126, 172),
      ),
      const _ProductData(
        'Sportwear Set',
        '\$ 80.00',
        Rect.fromLTWH(35, 464, 126, 172),
      ),
    ];

    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(35, 13, 24, 0),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final item = products[index];
          return InkWell(
            onTap: _openProduct,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 126,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReferenceCrop(
                    asset: _homeReference,
                    crop: item.crop,
                    width: 126,
                    height: 172,
                    radius: 11,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _promoBanner() {
    return SizedBox(
      height: 174,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) => ReferenceCrop(
          asset: _homeReference,
          crop: const Rect.fromLTWH(0, 704, 375, 174),
          width: constraints.maxWidth,
          height: 174,
        ),
      ),
    );
  }

  Widget _recommended() {
    return SizedBox(
      height: 82,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 10, 20, 0),
        scrollDirection: Axis.horizontal,
        children: [
          _recommendationCard(
            'White fashion hoodie',
            '\$ 29.00',
            const Rect.fromLTWH(32, 962, 66, 66),
          ),
          const SizedBox(width: 16),
          _recommendationCard(
            'Cotton T-shirt',
            '\$ 30.00',
            const Rect.fromLTWH(260, 962, 66, 66),
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard(String name, String price, Rect crop) {
    return InkWell(
      onTap: _openProduct,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 213,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFF6F6F6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ReferenceCrop(
              asset: _homeReference,
              crop: crop,
              width: 66,
              height: 66,
              radius: 9,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topCollection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(38, 13, 0, 0),
      child: Column(
        children: [
          _collectionCrop(
            const Rect.fromLTWH(38, 1115, 337, 148),
            337,
            148,
            radius: 12,
          ),
          const SizedBox(height: 16),
          _collectionCrop(
            const Rect.fromLTWH(38, 1280, 337, 210),
            337,
            210,
            radius: 12,
          ),
          const SizedBox(height: 17),
          SizedBox(
            height: 206,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _collectionCrop(
                  const Rect.fromLTWH(38, 1508, 176, 206),
                  176,
                  206,
                  radius: 11,
                ),
                const SizedBox(width: 13),
                _collectionCrop(
                  const Rect.fromLTWH(227, 1508, 148, 206),
                  148,
                  206,
                  radius: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectionCrop(
    Rect crop,
    double width,
    double height, {
    double radius = 0,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ReferenceCrop(
        asset: _homeReference,
        crop: crop,
        width: width,
        height: height,
        radius: radius,
      ),
    );
  }
}

class _ProductData {
  const _ProductData(this.name, this.price, this.crop);

  final String name;
  final String price;
  final Rect crop;
}
