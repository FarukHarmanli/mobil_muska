import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/app/router.dart';
import 'src/app/theme.dart';
import 'src/providers/object_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Provider sistemini başlat
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ObjectProvider(
            repository: LocalJsonObjectRepository(),
          )..load(), // app başlarken objeleri yükle
        ),
      ],
      child: const MainApp(),
    ),
  );
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
