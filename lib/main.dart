import 'package:crud_flutter/providers/pelanggan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'providers/barang_provider.dart';
import 'providers/user_provider.dart';
import 'providers/login_provider.dart';
import 'pages/splash_screen_page.dart';
import 'pages/home_page.dart';
import 'pages/barang_page.dart';
import 'pages/pelanggan_page.dart';
import 'pages/customer_page.dart';
import 'pages/user_page.dart';
import 'pages/transaksi_page.dart';
import 'pages/login_page.dart';
import 'pages/maps_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Aktifkan Device Preview
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BarangProvider()),
          ChangeNotifierProvider(create: (_) => PelangganProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(
              create: (_) => LoginProvider()), // Tambahkan LoginProvider
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true, // Diperlukan untuk DevicePreview
      locale: DevicePreview.locale(
          context), // Mendukung locale berdasarkan DevicePreview
      builder: DevicePreview.appBuilder, // Builder untuk DevicePreview
      home: SplashScreenPage(), // Mulai dari SplashScreenPage
    );
  }
}

// Main Page dengan Navigation Drawer
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    BarangPage(),
    CustomerPage(),
    UserPage(), // Halaman untuk User/Admin
    TransaksiPage(), // Halaman untuk Transaksi
    MapsPage(),
  ];

  final List<String> _pageTitles = [
    'Home',
    'Data Barang',
    'Data Pelanggan',
    'Data User/Admin',
    'Data Transaksi',
    'Maps UHB',
  ];

  void _navigateToPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    Navigator.of(context).pop();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedPageIndex]),
      ),
      body: _pages[_selectedPageIndex],
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Menu Navigasi',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(_pageTitles[0]),
              onTap: () => _navigateToPage(0),
              selected: _selectedPageIndex == 0,
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: Text(_pageTitles[1]),
              onTap: () => _navigateToPage(1),
              selected: _selectedPageIndex == 1,
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(_pageTitles[2]),
              onTap: () => _navigateToPage(2),
              selected: _selectedPageIndex == 2,
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(_pageTitles[3]),
              onTap: () => _navigateToPage(3),
              selected: _selectedPageIndex == 3,
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: Text(_pageTitles[4]),
              onTap: () => _navigateToPage(4),
              selected: _selectedPageIndex == 4,
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: Text(_pageTitles[5]),
              onTap: () => _navigateToPage(5),
              selected: _selectedPageIndex == 5,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
