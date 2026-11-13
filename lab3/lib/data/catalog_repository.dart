import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/store_data.dart';

class CatalogRepository {
  const CatalogRepository();

  Future<StoreData> load() async {
    final source = await rootBundle.loadString(
      'assets/gemstore.json',
      cache: false,
    );
    return StoreData.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }
}
