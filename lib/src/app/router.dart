import 'package:flutter/material.dart';
import '../features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login'; // ileride eklenecek login için yer hazır

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        // geçici placeholder (login’i ekleyince burayı güncellersin)
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Login Screen (placeholder)')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404')),
          ),
        );
    }
  }
}
