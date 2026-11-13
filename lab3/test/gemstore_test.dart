import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laborator_3/data/catalog_repository.dart';
import 'package:laborator_3/main.dart';
import 'package:laborator_3/models/store_data.dart';
import 'package:laborator_3/screens/home_screen.dart';
import 'package:laborator_3/screens/product_screen.dart';
import 'package:laborator_3/state/catalog_cubit.dart';

class RetryRepository extends CatalogRepository {
  int requests = 0;

  @override
  Future<StoreData> load() async {
    if (++requests == 1) throw const FormatException('Bad JSON');
    return super.load();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void mockJson(WidgetTester tester, [Map<String, dynamic>? json]) {
    final bytes = json == null
        ? File('assets/gemstore.json').readAsBytesSync()
        : Uint8List.fromList(utf8.encode(jsonEncode(json)));
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) {
        final key = utf8.decode(Uint8List.sublistView(message!));
        return key == 'assets/gemstore.json'
            ? Future<ByteData?>.value(ByteData.sublistView(bytes))
            : tester.binding.defaultBinaryMessenger.delegate.send(
                'flutter/assets',
                message,
              )!;
      },
    );
  }

  testWidgets('all screens use JSON data and maintain favorites', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 850);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Load and parse the real packaged asset before exercising the UI.
    final catalog = await tester.runAsync(
      () => const CatalogRepository().load(),
    );
    expect(catalog!.products, hasLength(8));
    expect(
      catalog.products.firstWhere((p) => p.id == 'p003').reviews,
      hasLength(2),
    );
    for (final product in catalog.products) {
      expect(
        catalog.categories.any((category) => category.id == product.categoryId),
        isTrue,
      );
      expect(File(product.image.asset).existsSync(), isTrue);
      expect(product.sizeAvailability[product.selectedSize], isTrue);
      for (final id in product.similarProductIds) {
        expect(catalog.products.any((product) => product.id == id), isTrue);
      }
    }

    mockJson(tester);
    await tester.pumpWidget(const GemStoreApp());
    await tester.pumpAndSettle();
    expect(find.text('GemStore'), findsOneWidget);
    expect(find.text('Autumn Collection 2021'), findsOneWidget);
    expect(find.text('Turtleneck Sweater'), findsOneWidget);

    await tester.tap(find.byTooltip('Search and filters'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'sportwear');
    await tester.pumpAndSettle();
    expect(find.text('Sportwear Set'), findsOneWidget);
    await tester.tap(find.text('Sportwear Set'));
    await tester.pumpAndSettle();

    expect(find.text('\$ 80.00'), findsOneWidget);
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove from favorites'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Coral'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add To Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Sportwear Set added to cart (Coral, L)'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('No products found.'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Default order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high').last);
    await tester.pumpAndSettle();
    final cubit = tester.element(find.byType(HomeScreen)).read<CatalogCubit>();
    expect(cubit.state.products.first.id, 'p004');
    await tester.tap(find.text('Men').first);
    await tester.pumpAndSettle();
    expect(find.text('No products found.'), findsOneWidget);
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'turtleneck');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Turtleneck Sweater'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ProductScreen>(find.byType(ProductScreen)).product.id,
      'p001',
    );
    expect(find.text('\$ 39.99'), findsOneWidget);
    expect(find.text('No reviews yet.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders changed JSON and restores the catalog on Retry', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 850);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final json = jsonDecode(
      File('assets/gemstore.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    json['homePage']['storeName'] = 'Changed Store';
    json['homePage']['heroBanner']['title'] = 'Changed collection';
    json['products'][0]['name'] = 'Changed product';
    json['products'][0]['price'] = 12.34;
    mockJson(tester, json);
    final repository = RetryRepository();
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => CatalogCubit(repository),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Could not load the catalog.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Changed Store'), findsOneWidget);
    expect(find.text('Changed collection'), findsOneWidget);
    expect(find.text('Changed product'), findsOneWidget);
    expect(find.text('\$ 12.34'), findsOneWidget);
    await tester.tap(find.text('Changed product'));
    await tester.pumpAndSettle();
    expect(find.text('Changed product'), findsOneWidget);
    expect(find.text('\$ 12.34'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
