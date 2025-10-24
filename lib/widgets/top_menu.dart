// lib/widgets/top_menu.dart
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TopMenu extends StatefulWidget {
  const TopMenu({
    super.key,
    this.imagePaths = const [
      'assets/images/app-sub-panel-extend.png',
      // diğer png'ler...
    ],
    this.minVisibleCount = 4,    // aynı anda en az kaç item görünsün?
    this.separator = 8.0,        // itemler arası boşluk
    this.outerPadding = 2.0,     // panel iç kenar (1–2 px)
    this.innerPadding = 1.0,     // png ile iç kutu arası (1–2 px)
    this.maxItemHeight = 180.0,  // güvenlik üst sınırı (çok uzun ekranlarda)
  });

  final List<String> imagePaths;
  final int minVisibleCount;
  final double separator;
  final double outerPadding;
  final double innerPadding;
  final double maxItemHeight;

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  List<Size>? _naturalSizes;

  @override
  void initState() {
    super.initState();
    _loadNaturalSizes();
  }

  Future<void> _loadNaturalSizes() async {
    final futures = widget.imagePaths.map((p) async {
      final data = await rootBundle.load(p);
      final bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final img = frame.image;
      return Size(img.width.toDouble(), img.height.toDouble());
    });
    final sizes = await Future.wait(futures);
    if (mounted) setState(() => _naturalSizes = sizes);
  }

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğine göre hedef KUTU genişliği (4 item sığdır)
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final totalSep = widget.separator * (widget.minVisibleCount - 1);
        final usableW = maxW - (widget.outerPadding * 2) - totalSep;
        final targetBoxW = usableW / widget.minVisibleCount; // her kartın genişliği

        // Yükseklikleri hesapla (png’yi yalnızca küçült)
        double tallestItemH = 0;

        List<_ItemGeometry> items = [];
        for (var i = 0; i < widget.imagePaths.length; i++) {
          final nat = (_naturalSizes != null && i < _naturalSizes!.length)
              ? _naturalSizes![i]
              : const Size(200, 200); // placeholder oran

          // PNG’yi büyütme, sadece küçült: hedef genişlik = targetBoxW - iç boşluklar
          final maxWForPng = targetBoxW - widget.innerPadding * 2;
          final scaleByW = maxWForPng / nat.width;
          // ayrıca aşırı uzun resimler için üst sınır
          final scaleByH = widget.maxItemHeight / nat.height;

          final scale = math.min(1.0, math.min(scaleByW, scaleByH));

          final dispW = nat.width * scale;
          final dispH = nat.height * scale;

          final boxW = dispW + widget.innerPadding * 2;
          final boxH = dispH + widget.innerPadding * 2;

          tallestItemH = math.max(tallestItemH, boxH);
          items.add(_ItemGeometry(dispW, dispH, boxW, boxH));
        }

        // Panel yüksekliği = en uzun kart + panel iç kenar boşlukları
        final panelHeight =
            tallestItemH + widget.outerPadding * 2;

        return Container(
          height: panelHeight, // ListView için bounded height
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25), // dış yarı saydam panel
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.outerPadding),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagePaths.length,
              separatorBuilder: (_, __) => SizedBox(width: widget.separator),
              itemBuilder: (context, index) {
                final g = (index < items.length)
                    ? items[index]
                    : _ItemGeometry(
                        targetBoxW - widget.innerPadding * 2,
                        targetBoxW - widget.innerPadding * 2,
                        targetBoxW,
                        targetBoxW,
                      );

                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: g.boxW,
                    height: g.boxH,
                    color: Colors.white.withOpacity(0.12), // iç yarı saydam kutu
                    padding: EdgeInsets.all(widget.innerPadding), // 1–2 px boşluk
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: g.dispW,
                      height: g.dispH,
                      child: Image.asset(
                        widget.imagePaths[index],
                        fit: BoxFit.fill,       // biz zaten piksel-boyutu verdik
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ItemGeometry {
  final double dispW, dispH; // PNG’nin çizileceği boyut
  final double boxW, boxH;   // iç yarı saydam kutunun boyutu
  _ItemGeometry(this.dispW, this.dispH, this.boxW, this.boxH);
}
