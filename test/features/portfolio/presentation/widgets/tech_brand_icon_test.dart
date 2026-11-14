import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';
import 'package:portfolio/features/portfolio/presentation/widgets/common/tech_brand_icon.dart';

void main() {
  testWidgets('TechBrandIcon paints all 10 vector brands without errors',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            spacing: 8.0,
            children: [
              for (final brand in TechBrand.values)
                TechBrandIcon(
                  brand: brand,
                  size: 18.0,
                ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(TechBrandIcon), findsNWidgets(TechBrand.values.length));
  });
}
