import 'dart:convert';
import 'dart:ui' show Offset;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import '../models/object_model.dart';

/// --- Repository Arayüzü ---
abstract class ObjectRepository {
  Future<List<AppObject>> fetchAll();
  Future<void> saveAll(List<AppObject> objects);
}

/// /assets/data/objects.json içinden okuyan basit repository
class LocalJsonObjectRepository implements ObjectRepository {
  final String assetPath;
  LocalJsonObjectRepository({this.assetPath = 'assets/data/objects.json'});

  @override
  Future<List<AppObject>> fetchAll() async {
    final raw = await rootBundle.loadString(assetPath);
    final List list = json.decode(raw) as List;
    return list.map((e) => AppObject.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveAll(List<AppObject> objects) async {
    // Asset'e yazılamaz; ileride SharedPreferences/DB gibi bir çözüm eklenecek.
    return;
  }
}

/// --- Provider ---
class ObjectProvider with ChangeNotifier {
  final ObjectRepository repository;

  ObjectProvider({required this.repository});

  final List<AppObject> _all = [];
  AppObject? _active;

  List<AppObject> get allObjects => List.unmodifiable(_all);
  AppObject? get activeObject => _active;

  /// Objeleri yükle
  Future<void> load() async {
    if (_all.isNotEmpty) return;

    final items = await repository.fetchAll();
    _all
      ..clear()
      ..addAll(items);

    // unlocked varsa onu, yoksa ilkini seç, hiç yoksa null
    final unlocked = _all.where((e) => e.unlocked);
    _active = unlocked.isNotEmpty
        ? unlocked.first
        : (_all.isNotEmpty ? _all.first : null);

    notifyListeners();
  }

  /// Aktif objeyi değiştir
  bool setActiveById(String id) {
    final found = _all.where((e) => e.id == id && e.unlocked).toList();
    if (found.isEmpty) return false;
    _active = found.first;
    notifyListeners();
    return true;
  }

  /// Objeyi satın al (unlock) ve aktif yap
  bool unlockAndActivate(String id) {
    final idx = _all.indexWhere((e) => e.id == id);
    if (idx == -1) return false;

    final updated = _all[idx].copyWith(unlocked: true);
    _all[idx] = updated;
    _active = updated;

    notifyListeners();
    return true;
  }

  /// Süs görünürlüğünü değiştir
  void toggleAdornment(String adornmentId, {bool? visible}) {
    if (_active == null) return;
    final list = _active!.adornments.map((a) {
      if (a.id == adornmentId) {
        return a.copyWith(isVisible: visible ?? !a.isVisible);
      }
      return a;
    }).toList();
    _replaceActive(_active!.copyWith(adornments: list));
  }

  /// Süs konum/ölçek/dönüş güncelle
  void updateAdornment(
    String adornmentId, {
    Offset? position,
    double? scale,
    double? rotationDeg,
    int? zIndex,
    double? opacity,
  }) {
    if (_active == null) return;
    final list = _active!.adornments.map((a) {
      if (a.id == adornmentId) {
        return a.copyWith(
          position: position ?? a.position,
          scale: scale ?? a.scale,
          rotationDeg: rotationDeg ?? a.rotationDeg,
          zIndex: zIndex ?? a.zIndex,
          opacity: opacity ?? a.opacity,
        );
      }
      return a;
    }).toList();
    _replaceActive(_active!.copyWith(adornments: list));
  }

  /// İç yardımcı: aktif objeyi listede de güncelle
  void _replaceActive(AppObject updated) {
    final i = _all.indexWhere((e) => e.id == updated.id);
    if (i != -1) _all[i] = updated;
    _active = updated;
    notifyListeners();
  }
}
