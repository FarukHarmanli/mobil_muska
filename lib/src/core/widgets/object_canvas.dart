import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/object_model.dart';
import '../../providers/object_provider.dart';

class ObjectCanvas extends StatelessWidget {
  const ObjectCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ObjectProvider>(
      builder: (context, provider, child) {
        final activeObject = provider.activeObject;
        
        if (activeObject == null) {
          return const Center(
            child: Text(
              'Hiç obje yüklenmedi',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          );
        }

        final canvasSize = activeObject.canvasSize ?? const Size(400, 400);
        
        return Center(
          child: Container(
            width: canvasSize.width,
            height: canvasSize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Ana obje görseli
                  Image.asset(
                    activeObject.baseImagePath,
                    width: canvasSize.width,
                    height: canvasSize.height,
                    fit: BoxFit.contain,
                  ),
                  
                  // Süslemeler
                  ...activeObject.adornments
                      .where((adornment) => adornment.isVisible)
                      .map((adornment) => _buildAdornment(adornment))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdornment(Adornment adornment) {
    final adornmentSize = adornment.size ?? const Size(64, 64);
    
    return Positioned(
      left: adornment.position.dx - (adornmentSize.width * adornment.anchor.dx),
      top: adornment.position.dy - (adornmentSize.height * adornment.anchor.dy),
      child: Transform.scale(
        scale: adornment.scale,
        child: Transform.rotate(
          angle: adornment.rotationDeg * (3.14159 / 180), // Convert to radians
          child: Opacity(
            opacity: adornment.opacity,
            child: SizedBox(
              width: adornmentSize.width,
              height: adornmentSize.height,
              child: Image.asset(
                adornment.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}