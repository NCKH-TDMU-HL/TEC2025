import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';

void main() {
  testWidgets('App can be created', (WidgetTester tester) async {
    // Chỉ test xem app có chạy được không
    await tester.pumpWidget(MyApp());
    
    // Test xem có widget nào hiển thị không
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}