import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/object_model.dart';
import '../../providers/object_provider.dart';

class ObjectCanvas extends StatelessWidget {
  const ObjectCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ObjectProvider>(
      builder: (context, provider, _) {
        final AppObject? obj = provider.activeObject;
        if (obj == null) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, c) {
            final baseW = obj.canvasSize?.width ?? c.maxWidth;
            final baseH = obj.canvasSize?.height ?? c.maxHeight;

            final sW = c.maxWidth / baseW;
            final sH = c.maxHeight / baseH;
            final s = math.min(sW, sH);

            final canvasW = baseW * s;
            final canvasH = baseH * s;

            final adorns = [...obj.adornments.where((a) => a.isVisible)]
              ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

            return Center(
              child: RepaintBoundary(
                child: SizedBox(
                  width: canvasW,
                  height: canvasH,
                  child: Stack(
                    clipBehavior: Clip.none, // overflow serbest
                    children: [
                      _buildBase(obj, s),
                      ...adorns.map((a) => _adornment(a, s)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBase(AppObject obj, double s) {
    // baseSize/basePosition/baseAnchor varsa piksel hassas yerleşim
    if (obj.baseSize != null && obj.basePosition != null && obj.baseAnchor != null) {
      final bw = obj.baseSize!.width * s;
      final bh = obj.baseSize!.height * s;

      final bx = obj.basePosition!.dx * s;
      final by = obj.basePosition!.dy * s;

      final bax = obj.baseAnchor!.dx;
      final bay = obj.baseAnchor!.dy;

      return Transform.translate(
        offset: Offset(bx - bw * bax, by - bh * bay),
        child: SizedBox(
          width: bw,
          height: bh,
          child: Image.asset(
            obj.baseImagePath,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // yoksa tüm alanı kapla
    return Positioned.fill(
      child: Image.asset(
        obj.baseImagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _adornment(Adornment a, double s) {
    final aw = (a.size?.width ?? 64) * s;
    final ah = (a.size?.height ?? 64) * s;

    final px = a.position.dx * s;
    final py = a.position.dy * s;

    final ax = a.anchor.dx;
    final ay = a.anchor.dy;

    Widget child = SizedBox(
      width: aw,
      height: ah,
      child: Image.asset(
        a.imagePath,
        fit: BoxFit.contain,
      ),
    );

    if (a.scale != 1.0) child = Transform.scale(scale: a.scale, child: child);
    if (a.rotationDeg != 0) {
      child = Transform.rotate(
        angle: a.rotationDeg * math.pi / 180,
        child: child,
      );
    }
    if (a.opacity != 1.0) child = Opacity(opacity: a.opacity, child: child);

    // Transform.translate ile clip’e takılmadan konumlandır
    return Transform.translate(
      offset: Offset(px - aw * ax, py - ah * ay),
      child: child,
    );
  }
}
