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
    this.minVisibleCount = 4,
    this.separator = 8.0,
    this.outerPadding = 2.0,
    this.innerPadding = 1.0,
    this.maxItemHeight = 180.0,
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
  final _controller = ScrollController();
  List<Size>? _naturalSizes;

  @override
  void initState() {
    super.initState();
    _loadNaturalSizes();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportW = constraints.maxWidth;

        final totalSep = widget.separator * (widget.minVisibleCount - 1);
        final usableW = viewportW - (widget.outerPadding * 2) - totalSep;
        final targetBoxW = usableW / widget.minVisibleCount;

        double tallestItemH = 0;
        final items = <_ItemGeometry>[];

        for (var i = 0; i < widget.imagePaths.length; i++) {
          final nat = (_naturalSizes != null && i < _naturalSizes!.length)
              ? _naturalSizes![i]
              : const Size(200, 200);

          final maxWForPng = targetBoxW - widget.innerPadding * 2;
          final scaleByW = maxWForPng / nat.width;
          final scaleByH = widget.maxItemHeight / nat.height;
          final scale = math.min(1.0, math.min(scaleByW, scaleByH));

          final dispW = nat.width * scale;
          final dispH = nat.height * scale;

          final boxW = dispW + widget.innerPadding * 2;
          final boxH = dispH + widget.innerPadding * 2;

          tallestItemH = math.max(tallestItemH, boxH);
          items.add(_ItemGeometry(dispW, dispH, boxW, boxH));
        }

        final panelHeight = tallestItemH + widget.outerPadding * 2;

        final singleItemW = (items.isNotEmpty ? items.first.boxW : targetBoxW);
        final contentW = (singleItemW * widget.imagePaths.length) +
            widget.separator * (widget.imagePaths.length - 1);

        final canScroll = contentW > (viewportW - widget.outerPadding * 2);
        final step = singleItemW + widget.separator;

        Future<void> goLeft() async {
          final newOffset = (_controller.offset - step).clamp(
            0.0,
            _controller.position.maxScrollExtent,
          );
          await _controller.animateTo(
            newOffset,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
          );
        }

        Future<void> goRight() async {
          final newOffset = (_controller.offset + step).clamp(
            0.0,
            _controller.position.maxScrollExtent,
          );
          await _controller.animateTo(
            newOffset,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
          );
        }

        final atStart = !_controller.hasClients || _controller.offset <= 0.0;
        final atEnd = !_controller.hasClients ||
            _controller.offset >= _controller.position.maxScrollExtent - 1;

        return Container(
          height: panelHeight,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
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
            child: Stack(
              children: [
                // LİSTE
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false, overscroll: false),
                  child: ListView.separated(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: widget.imagePaths.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: widget.separator),
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
                          color: Colors.white.withOpacity(0.12),
                          padding: EdgeInsets.all(widget.innerPadding),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: g.dispW,
                            height: g.dispH,
                            child: Image.asset(
                              widget.imagePaths[index],
                              fit: BoxFit.fill,
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.high,
                              cacheWidth: g.dispW.round(),
                              cacheHeight: g.dispH.round(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // SOL OK
                if (canScroll)
                  Positioned(
                    left: 2,
                    top: 0,
                    bottom: 0,
                    child: _ArrowButton(
                      enabled: !atStart,
                      onTap: goLeft,
                      isLeft: true,
                    ),
                  ),

                // SAĞ OK
                if (canScroll)
                  Positioned(
                    right: 2,
                    top: 0,
                    bottom: 0,
                    child: _ArrowButton(
                      enabled: !atEnd,
                      onTap: goRight,
                      isLeft: false,
                    ),
                  ),
              ],
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

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    super.key,
    required this.enabled,
    required this.onTap,
    required this.isLeft,
  });

  final bool enabled;
  final VoidCallback onTap;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1 : 0.25,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: 36,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(
              isLeft ? Icons.chevron_left : Icons.chevron_right,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
