import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = 'Ahmet Yılmaz';
    const String userEmail = 'ahmet@example.com';

    return Drawer(
      backgroundColor: const Color(0xFFCFEAE5),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ÜST PROFİL ALANI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF00BFA5), Color(0xFF007C6E)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Tooltip(
                      message: 'Kapat',
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // MENÜ ÖĞELERİ
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF1A3A36)),
              title: const Text(
                'Ayarlar',
                style: TextStyle(
                  color: Color(0xFF1A3A36),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF1A3A36)),
              title: const Text(
                'Çıkış yap',
                style: TextStyle(
                  color: Color(0xFF1A3A36),
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
