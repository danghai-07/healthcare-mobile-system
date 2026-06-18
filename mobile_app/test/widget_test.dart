import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app.dart';
import 'package:mobile_app/app/di/app_dependency_scope.dart';
import 'package:mobile_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Healthcare app renders login screen', (tester) async {
    final authPreferences = await SharedPrefsAuthPreferences.create();
    final app = HealthcareApp(
      dependencyScope: AppDependencyScope(
        authLocalDataSource: AuthLocalDataSource(authPreferences),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Chào mừng trở lại'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });
}
