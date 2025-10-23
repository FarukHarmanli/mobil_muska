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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF4A9B8E),
      endDrawerEnableOpenDragGesture: true,
      endDrawer: const SideMenu(), // <- ayrı dosyadaki menü
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

        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 90,
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
            
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
