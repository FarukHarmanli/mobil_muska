// lib/src/models/object_model.dart
import 'dart:ui';
import '../utils/json_converters.dart';

class AppObject {
  final String id;
  final String name;
  final String baseImagePath;
  final Size? canvasSize;

  // 🔹 Base (muska) için yeni alanlar
  final Size? baseSize;           // px
  final Offset? basePosition;     // canvas koordinatı (px)
  final Offset? baseAnchor;       // 0..1

  final List<Adornment> adornments;
  final bool unlocked;
  final int version;

  const AppObject({
    required this.id,
    required this.name,
    required this.baseImagePath,
    this.canvasSize,
    this.baseSize,
    this.basePosition,
    this.baseAnchor,
    this.adornments = const [],
    this.unlocked = false,
    this.version = 1,
  });

  AppObject copyWith({
    String? id,
    String? name,
    String? baseImagePath,
    Size? canvasSize,
    Size? baseSize,
    Offset? basePosition,
    Offset? baseAnchor,
    List<Adornment>? adornments,
    bool? unlocked,
    int? version,
  }) {
    return AppObject(
      id: id ?? this.id,
      name: name ?? this.name,
      baseImagePath: baseImagePath ?? this.baseImagePath,
      canvasSize: canvasSize ?? this.canvasSize,
      baseSize: baseSize ?? this.baseSize,
      basePosition: basePosition ?? this.basePosition,
      baseAnchor: baseAnchor ?? this.baseAnchor,
      adornments: adornments ?? this.adornments,
      unlocked: unlocked ?? this.unlocked,
      version: version ?? this.version,
    );
  }

  factory AppObject.fromJson(Map<String, dynamic> json) => AppObject(
        id: json['id'] as String,
        name: json['name'] as String,
        baseImagePath: json['baseImagePath'] as String,
        canvasSize: sizeFromJson(json['canvasSize']),
        baseSize: sizeFromJson(json['baseSize']),
        basePosition: offsetFromJson(json['basePosition']),
        baseAnchor: offsetFromJson(json['baseAnchor']),
        adornments: (json['adornments'] as List<dynamic>? ?? [])
            .map((e) => Adornment.fromJson(e as Map<String, dynamic>))
            .toList(),
        unlocked: json['unlocked'] as bool? ?? false,
        version: json['version'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'baseImagePath': baseImagePath,
        'canvasSize': sizeToJson(canvasSize),
        'baseSize': sizeToJson(baseSize),
        'basePosition': offsetToJson(basePosition),
        'baseAnchor': offsetToJson(baseAnchor),
        'adornments': adornments.map((e) => e.toJson()).toList(),
        'unlocked': unlocked,
        'version': version,
      };
}

class Adornment {
  final String id;
  final String name;
  final String imagePath;
  final Offset position;
  final Offset anchor;
  final Size? size;
  final double scale;
  final double rotationDeg;
  final double opacity;
  final int zIndex;
  final bool isVisible;

  const Adornment({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.position,
    this.anchor = const Offset(0.5, 0.5),
    this.size,
    this.scale = 1.0,
    this.rotationDeg = 0.0,
    this.opacity = 1.0,
    this.zIndex = 0,
    this.isVisible = true,
  });

  Adornment copyWith({
    String? id,
    String? name,
    String? imagePath,
    Offset? position,
    Offset? anchor,
    Size? size,
    double? scale,
    double? rotationDeg,
    double? opacity,
    int? zIndex,
    bool? isVisible,
  }) {
    return Adornment(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      position: position ?? this.position,
      anchor: anchor ?? this.anchor,
      size: size ?? this.size,
      scale: scale ?? this.scale,
      rotationDeg: rotationDeg ?? this.rotationDeg,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  factory Adornment.fromJson(Map<String, dynamic> json) => Adornment(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        imagePath: json['imagePath'] as String,
        position: offsetFromJson(json['position']) ?? Offset.zero,
        anchor: offsetFromJson(json['anchor']) ?? const Offset(0.5, 0.5),
        size: sizeFromJson(json['size']),
        scale: (json['scale'] as num?)?.toDouble() ?? 1.0,
        rotationDeg: (json['rotationDeg'] as num?)?.toDouble() ?? 0.0,
        opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
        zIndex: json['zIndex'] as int? ?? 0,
        isVisible: json['isVisible'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'position': offsetToJson(position),
        'anchor': offsetToJson(anchor),
        'size': sizeToJson(size),
        'scale': scale,
        'rotationDeg': rotationDeg,
        'opacity': opacity,
        'zIndex': zIndex,
        'isVisible': isVisible,
      };
}
