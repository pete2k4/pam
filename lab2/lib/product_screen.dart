import 'package:flutter/material.dart';

import 'widgets/reference_crop.dart';

const _productReference = 'assets/product_reference.png';
const _green = Color(0xFF508A7B);
const _ink = Color(0xFF1D1F22);

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _favorite = true;
  int _color = 0;
  int _size = 2;

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
            ReferenceCrop(
              asset: _productReference,
              crop: const Rect.fromLTWH(0, 44, 375, 362),
              width: MediaQuery.sizeOf(context).width,
              height: 380,
            ),
            Positioned(
              left: 28,
              top: 16,
              child: _roundButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              right: 28,
              top: 16,
              child: _roundButton(
                icon: _favorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: _favorite ? const Color(0xFFFF6B74) : _ink,
                onTap: () => setState(() => _favorite = !_favorite),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_Dot(selected: true), _Dot(), _Dot()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = const Color(0xFF25314C),
  }) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x22000000),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: color),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sportwear Set',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  '\$ 80.00',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ...List.generate(
                  5,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.star_rounded, size: 20, color: _green),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '(83)',
                  style: TextStyle(fontSize: 11, color: Color(0xFF777E91)),
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
            const Text(
              'Sportswear is no longer under culture, it is no longer indie '
              'or cobbled together as it once was. Sport is fashion today. '
              'The top is oversized in fit and style, may need to size down.',
              style: TextStyle(
                fontSize: 12,
                height: 1.65,
                color: Color(0xFF56575A),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(80, 30),
                ),
                child: const Text(
                  'Read more',
                  style: TextStyle(
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
            _ratings(),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '47 Reviews',
                  style: TextStyle(fontSize: 11, color: Color(0xFF8A8A8F)),
                ),
                Text(
                  'WRITE A REVIEW  ✎',
                  style: TextStyle(fontSize: 11, color: Color(0xFFB5B5BA)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _review(
              name: 'Jennifer Rose',
              time: '5m ago',
              crop: const Rect.fromLTWH(32, 1171, 38, 38),
              comment:
                  'I love it. Awesome customer service!! Helped me out with '
                  'adding an additional item to my order. Thanks again!',
            ),
            const SizedBox(height: 24),
            _review(
              name: 'Kelly Rihana',
              time: '9m ago',
              crop: const Rect.fromLTWH(32, 1296, 38, 38),
              comment:
                  "I'm very happy with order, It was delivered on and good "
                  'quality. Recommended!',
            ),
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
    const colors = [Color(0xFFE7C0A7), Color(0xFF050302), Color(0xFFEE6969)];
    const sizes = ['S', 'M', 'L'];

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
              Row(
                children: List.generate(colors.length, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _color = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(right: 8),
                      padding: EdgeInsets.all(_color == index ? 5 : 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: _color == index
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
                          color: colors[index],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
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
              Row(
                children: List.generate(sizes.length, (index) {
                  final selected = _size == index;
                  return GestureDetector(
                    onTap: () => setState(() => _size = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 33,
                      height: 33,
                      margin: EdgeInsets.only(
                        right: index == sizes.length - 1 ? 0 : 8,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF515151)
                            : const Color(0xFFFAFAFA),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        sizes[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? Colors.white
                              : const Color(0xFFC5C5C5),
                        ),
                      ),
                    ),
                  );
                }),
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
    const rows = [
      (5, .80, '80%'),
      (4, .18, '12%'),
      (3, .08, '5%'),
      (2, .06, '3%'),
      (1, 0.0, '0%'),
    ];
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '4.9',
              style: TextStyle(
                fontSize: 40,
                height: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12, left: 8),
              child: Text(
                'OUT OF 5',
                style: TextStyle(fontSize: 11, color: Color(0xFF8A8A8F)),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (_) =>
                        const Icon(Icons.star_rounded, size: 20, color: _green),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  '83 ratings',
                  style: TextStyle(fontSize: 10, color: Color(0xFF8A8A8F)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                  child: Text(
                    '${row.$1}',
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
                      value: row.$2,
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
                    row.$3,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _review({
    required String name,
    required String time,
    required Rect crop,
    required String comment,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReferenceCrop(
          asset: _productReference,
          crop: crop,
          width: 38,
          height: 38,
          radius: 19,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB8B8BB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: List.generate(
                  5,
                  (_) =>
                      const Icon(Icons.star_rounded, size: 14, color: _green),
                ),
              ),
              const SizedBox(height: 13),
              Text(
                comment,
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
    const items = [
      ('Rise Crop Hoodie', '\$ 43.00', Rect.fromLTWH(31, 1478, 126, 172)),
      ('Gym Crop Top', '\$ 39.99', Rect.fromLTWH(177, 1478, 126, 172)),
      ('Sport Sweatshirt', '\$ 47.99', Rect.fromLTWH(323, 1478, 52, 172)),
    ];
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 126,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReferenceCrop(
                  asset: _productReference,
                  crop: item.$3,
                  width: 126,
                  height: 172,
                  radius: 10,
                ),
                const SizedBox(height: 10),
                Text(
                  item.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cartBar() {
    return Container(
      height: 82,
      decoration: const BoxDecoration(
        color: Color(0xFF343434),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sportwear Set added to cart')),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_rounded, size: 23, color: Colors.white),
              SizedBox(width: 14),
              Text(
                'Add To Cart',
                style: TextStyle(
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
