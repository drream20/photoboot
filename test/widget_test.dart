// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:photoboot/models/booth_layout.dart';

void main() {
  test('all planned layouts are registered', () {
    expect(photoBoothLayouts, hasLength(12));
    expect(
      photoBoothLayouts.map((layout) => layout.id),
      orderedEquals([
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
      ]),
    );
  });
}
