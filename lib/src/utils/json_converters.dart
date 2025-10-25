// lib/src/utils/json_converters.dart
import 'dart:ui';

/// ---- Offset ----
Map<String, dynamic>? offsetToJson(Offset? o) =>
    o == null ? null : {'x': o.dx, 'y': o.dy};

Offset? offsetFromJson(dynamic v) {
  if (v is Map) {
    final x = (v['x'] as num?)?.toDouble();
    final y = (v['y'] as num?)?.toDouble();
    if (x != null && y != null) return Offset(x, y);
  }
  return null;
}

/// ---- Size ----
Map<String, dynamic>? sizeToJson(Size? s) =>
    s == null ? null : {'w': s.width, 'h': s.height};

Size? sizeFromJson(dynamic v) {
  if (v is Map) {
    final w = (v['w'] as num?)?.toDouble();
    final h = (v['h'] as num?)?.toDouble();
    if (w != null && h != null) return Size(w, h);
  }
  return null;
}

/// (İsteğe bağlı) Color için basit ARGB çeviriciler
int? colorToJson(Color? c) => c?.value;
Color? colorFromJson(dynamic v) {
  if (v is int) return Color(v);
  return null;
}
