import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:three_screen_store/l10n/app_localizations.dart';
import 'package:three_screen_store/main.dart';
import 'package:three_screen_store/screens/home_screen.dart';

// Helper: pump MyApp and fast-forward past the 2-second splash delay.
Future<void> pumpPastSplash(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pump();
  await tester.pump(const Duration(seconds: 2)); // fire Future.delayed
  await tester.pumpAndSettle();                  // finish pushReplacement anim
}

Widget localizedHome(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    home: HomeScreen(onLocaleChange: (_) {}),
  );
}

void main() {
  testWidgets('Home screen shows the product grid', (tester) async {
    await pumpPastSplash(tester);
    expect(find.text('Tech Store'), findsOneWidget);
    expect(find.text('Wireless Headphones'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Tapping a product opens its details screen', (tester) async {
    await pumpPastSplash(tester);
    await tester.tap(find.text('Wireless Headphones'));
    await tester.pumpAndSettle();
    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('Buy Now'), findsOneWidget);
  });

  testWidgets('Long-pressing a product shows delete dialog', (tester) async {
    await pumpPastSplash(tester);
    await tester.longPress(find.text('Gaming Mouse'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Product'), findsOneWidget);
    expect(find.text('Delete'), findsWidgets);
  });

  testWidgets('Confirming delete removes the product and shows SnackBar',
      (tester) async {
    await pumpPastSplash(tester);
    await tester.longPress(find.text('Gaming Mouse'));
    await tester.pumpAndSettle();

    // Tap the red Delete button in the dialog
    final deleteBtn = find.widgetWithText(ElevatedButton, 'Delete');
    await tester.tap(deleteBtn);
    await tester.pumpAndSettle();

    // Product is gone, SnackBar appears
    expect(find.text('Gaming Mouse'), findsNothing);
    expect(find.text('Product deleted'), findsOneWidget);
  });

  testWidgets('Product names are translated in Arabic', (tester) async {
    await tester.pumpWidget(localizedHome(const Locale('ar')));
    await tester.pump();
    expect(find.text('متجر التقنية'), findsOneWidget);
    expect(find.text('فأرة ألعاب'), findsOneWidget);
    expect(find.text('سماعات لاسلكية'), findsOneWidget);
    expect(find.text('Gaming Mouse'), findsNothing);
  });

  testWidgets('Arabic locale renders the app right-to-left', (tester) async {
    await tester.pumpWidget(localizedHome(const Locale('ar')));
    await tester.pump();
    expect(
      Directionality.of(tester.element(find.byType(GridView))),
      TextDirection.rtl,
    );
  });
}
