import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF4A9B8E), // Fallback yeşil renk
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF4A9B8E), // Fallback color
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'), // Doğru dosya ismi
              fit: BoxFit.cover, // ChatGPT tavsiyesi: cover mode
              alignment: Alignment.center, // ChatGPT tavsiyesi: center position
            ),
          ),
          child: const SafeArea(
            child: Center(
              child: Text(
                'Hello World!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
