// lib/main.dart
import 'package:flutter/material.dart';
import 'widgets/side_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mobil Muska',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Panel ölçüleri (istersen const yapabilirsin)
  static const double _topPanelHeight = 90;
  static const double _subPanelTop = 70;
  static const double _subPanelHeight = 80;

  @override
  Widget build(BuildContext context) {
    // Top panelin sub panel üzerine bindirme miktarı
    final double overlap = (_topPanelHeight - _subPanelTop).clamp(0, _subPanelHeight);
    // Görünen alanın ortasına denk getirmek için içerik üstten yarım overlap kaydırılıyor
    final double contentTopPadding = overlap / 2 + 10;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF4A9B8E),
      endDrawerEnableOpenDragGesture: true,
      endDrawer: const SideMenu(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF4A9B8E),
          image: DecorationImage(
            image: AssetImage('assets/images/app-background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Stack(
          children: [
            // --- Sub Panel
            Positioned(
              top: _subPanelTop,
              left: 0,
              right: 0,
              child: Container(
                height: _subPanelHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF08A892),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  // ikonları görünür alanın dikey ortasına taşır
                  padding: EdgeInsets.fromLTRB(24, contentTopPadding, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sol: ikon + sayı
                      Row(
                        children: [
                          Image.asset('assets/images/app-sub-panel-left.png', height: 38),
                          const SizedBox(width: 8),
                          const Text(
                            '12',
                            style: TextStyle(
                              color: Color(0xFFD8F8F1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Orta ikon (tek başına)
                      Image.asset('assets/images/app-sub-panel-mid.png', height: 45),

                      // Sağ: sayı + ikon
                      Row(
                        children: [
                          const Text(
                            '8',
                            style: TextStyle(
                              color: Color(0xFFD8F8F1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset('assets/images/app-sub-panel-right.png', height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Top Panel (en üstte)
            Container(
              width: double.infinity,
              height: _topPanelHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF00BFA5), Color(0xFF007C6E)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/app-logo.png', height: 70),
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                      child: Image.asset('assets/images/app-hamburger-menu.png', height: 50),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
