import 'product.dart';

class StoreCategory {
  const StoreCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.selected,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      selected: json['selected'] as bool,
    );
  }

  final String id;
  final String name;
  final String icon;
  final bool selected;
}

class StorePromotion {
  const StorePromotion({
    required this.title,
    required this.image,
    required this.categoryId,
    this.label = '',
    this.action = '',
  });

  factory StorePromotion.fromJson(Map<String, dynamic> json) {
    return StorePromotion(
      title: json['title'] as String,
      image: StoreImageData.fromJson(json['image'] as Map<String, dynamic>),
      categoryId: json['categoryId'] as String,
      label: (json['label'] ?? json['category'] ?? '') as String,
      action: (json['action'] ?? '') as String,
    );
  }

  final String title;
  final StoreImageData image;
  final String categoryId;
  final String label;
  final String action;
}

class StoreData {
  const StoreData({
    required this.name,
    required this.categories,
    required this.hero,
    required this.newCollection,
    required this.topCollections,
    required this.categoryPromos,
    required this.featuredIds,
    required this.recommendedIds,
    required this.products,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) {
    final home = json['homePage'] as Map<String, dynamic>;
    return StoreData(
      name: home['storeName'] as String,
      categories: (home['categories'] as List)
          .map((item) => StoreCategory.fromJson(item as Map<String, dynamic>))
          .toList(),
      hero: StorePromotion.fromJson(home['heroBanner'] as Map<String, dynamic>),
      newCollection: StorePromotion.fromJson(
        home['newCollection'] as Map<String, dynamic>,
      ),
      topCollections: (home['topCollections'] as List)
          .map((item) => StorePromotion.fromJson(item as Map<String, dynamic>))
          .toList(),
      categoryPromos: (home['categoryPromos'] as List)
          .map((item) => StorePromotion.fromJson(item as Map<String, dynamic>))
          .toList(),
      featuredIds: List<String>.from(home['featureProducts'] as List),
      recommendedIds: List<String>.from(home['recommended'] as List),
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String name;
  final List<StoreCategory> categories;
  final StorePromotion hero;
  final StorePromotion newCollection;
  final List<StorePromotion> topCollections;
  final List<StorePromotion> categoryPromos;
  final List<String> featuredIds;
  final List<String> recommendedIds;
  final List<Product> products;
}
