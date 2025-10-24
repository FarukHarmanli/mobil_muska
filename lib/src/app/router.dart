import 'package:flutter/material.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Sayfa bulunamadı')),
          ),
        );
    }
  }
}
