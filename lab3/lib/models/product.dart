enum ProductGroup {
  all('All products'),
  featured('Feature Products'),
  recommended('Recommended'),
  similar('Similar Product');

  const ProductGroup(this.label);
  final String label;
}

class StoreImageData {
  const StoreImageData({required this.asset, required this.crop});

  factory StoreImageData.fromJson(Map<String, dynamic> json) {
    return StoreImageData(
      asset: json['asset'] as String,
      crop: (json['crop'] as List)
          .map((value) => (value as num).toDouble())
          .toList(),
    );
  }

  final String asset;
  final List<double> crop;
}

class ProductColor {
  const ProductColor({
    required this.id,
    required this.name,
    required this.value,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json['id'] as String,
      name: json['name'] as String,
      value: int.parse(
        (json['value'] as String).replaceFirst('#', 'FF'),
        radix: 16,
      ),
    );
  }

  final String id;
  final String name;
  final int value;
}

class ProductReview {
  const ProductReview({
    required this.author,
    required this.time,
    required this.text,
    required this.rating,
    required this.avatar,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      author: json['author'] as String,
      time: json['createdAtLabel'] as String,
      text: json['text'] as String,
      rating: (json['rating'] as num).toDouble(),
      avatar: StoreImageData.fromJson(json['avatar'] as Map<String, dynamic>),
    );
  }

  final String author;
  final String time;
  final String text;
  final double rating;
  final StoreImageData avatar;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.categoryId,
    required this.group,
    required this.image,
    required this.galleryImages,
    required this.description,
    required this.descriptionExpanded,
    required this.rating,
    required this.ratingCount,
    required this.reviewCount,
    required this.colors,
    required this.selectedColor,
    required this.sizes,
    required this.selectedSize,
    required this.sizeAvailability,
    required this.ratingBreakdown,
    required this.reviews,
    required this.similarProductIds,
    required this.isFavorite,
    required this.canAddToCart,
    required this.addToCartLabel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] as Map<String, dynamic>;
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      categoryId: json['categoryId'] as String,
      group: ProductGroup.values.byName(json['group'] as String),
      image: StoreImageData.fromJson(json['image'] as Map<String, dynamic>),
      galleryImages: (json['galleryImages'] as List)
          .map((item) => StoreImageData.fromJson(item as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
      descriptionExpanded: json['descriptionExpanded'] as bool,
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      reviewCount: json['reviewCount'] as int,
      colors: (json['availableColors'] as List)
          .map((item) => ProductColor.fromJson(item as Map<String, dynamic>))
          .toList(),
      selectedColor: json['selectedColor'] as String,
      sizes: List<String>.from(json['availableSizes'] as List),
      selectedSize: json['selectedSize'] as String,
      sizeAvailability: Map<String, bool>.from(json['sizeAvailability'] as Map),
      ratingBreakdown: [
        for (final row in json['ratingBreakdown'] as List)
          (
            stars: row['stars'] as int,
            percentage: (row['percentage'] as num).toDouble(),
          ),
      ],
      reviews: (json['reviews'] as List)
          .map((item) => ProductReview.fromJson(item as Map<String, dynamic>))
          .toList(),
      similarProductIds: List<String>.from(json['similarProductIds'] as List),
      isFavorite: actions['isFavorite'] as bool,
      canAddToCart: actions['canAddToCart'] as bool,
      addToCartLabel: actions['addToCartLabel'] as String,
    );
  }

  final String id;
  final String name;
  final double price;
  final String currency;
  final String categoryId;
  final ProductGroup group;
  final StoreImageData image;
  final List<StoreImageData> galleryImages;
  final String description;
  final bool descriptionExpanded;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final List<ProductColor> colors;
  final String selectedColor;
  final List<String> sizes;
  final String selectedSize;
  final Map<String, bool> sizeAvailability;
  final List<({int stars, double percentage})> ratingBreakdown;
  final List<ProductReview> reviews;
  final List<String> similarProductIds;
  final bool isFavorite;
  final bool canAddToCart;
  final String addToCartLabel;

  String get priceLabel {
    final symbol = currency == 'USD' ? '\$' : currency;
    return '$symbol ${price.toStringAsFixed(2)}';
  }
}
