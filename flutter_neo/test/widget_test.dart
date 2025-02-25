// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_neo/sign_up.dart';
import 'package:flutter_neo/login_page.dart';
import 'package:flutter_neo/main.dart';

void main() {
  testWidgets('Kullanıcı kayıt olup giriş yapabiliyor mu?',
      (WidgetTester tester) async {
    await tester.pumpWidget(LoginScreen());

    // "Kayıt Ol" butonunu bulup tıklıyoruz
    await tester.tap(find.text('Kayıt Ol'));
    await tester.pumpAndSettle(); // Sayfa geçişini bekle

    // Kayıt ekranında kullanıcı adı ve şifre giriyoruz
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'testpassword');

    // "Kayıt Ol" butonuna basıyoruz
    await tester.tap(find.text('Kayıt Ol'));
    await tester.pumpAndSettle(); // Kayıt işleminin tamamlanmasını bekle

    // Kayıt başarılı mesajı gelip gelmediğini kontrol edelim
    expect(find.text('Kayıt başarılı! Şimdi giriş yapabilirsiniz.'),
        findsOneWidget);

    // Kapat düğmesine basıp giriş ekranına dönelim
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();

    // Giriş ekranında kullanıcı adı ve şifre giriyoruz
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'testpassword');

    // "Giriş" butonuna basıyoruz
    await tester.tap(find.text('Giriş'));
    await tester.pumpAndSettle(); // Giriş işleminin tamamlanmasını bekle

    // ToDoListScreen'e yönlendirilip yönlendirilmediğini kontrol edelim
    expect(find.byType(TodoListScreen), findsOneWidget);
  });
}
