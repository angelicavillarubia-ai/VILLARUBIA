import 'package:flutter_test/flutter_test.dart';

import 'package:semester_project/app.dart';

void main() {
  testWidgets('App starts on the Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // "Login" appears in the app bar and on the button.
    expect(find.text('Login'), findsWidgets);
  });
}
