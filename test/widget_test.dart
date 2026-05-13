import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clearview_hub/main.dart';
import 'package:clearview_hub/core/services/theme_service.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final themeService = ThemeService(prefs);

    await tester.pumpWidget(ClearViewApp(themeService: themeService));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
