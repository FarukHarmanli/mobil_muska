import 'package:flutter/material.dart';
import 'src/app/router.dart';
import 'src/app/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobil Muska',
      theme: buildAppTheme(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.login,
    );
  }
}
