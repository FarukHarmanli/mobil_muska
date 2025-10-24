import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  // Ana yeşil tonlarını baz alan sade bir tema
  const seed = Color(0xFF08A892);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    scaffoldBackgroundColor: const Color(0xFF4A9B8E),
  );
}
