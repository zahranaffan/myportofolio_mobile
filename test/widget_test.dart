import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('MyPortfolio home screen renders', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });
}
