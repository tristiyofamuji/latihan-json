import 'package:flutter/material.dart';
import 'barang_page.dart';
import 'pelanggan_page.dart';
import 'user_page.dart';
import 'transaksi_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;

  // List of pages corresponding to each drawer item
  final List<Widget> _pages = [
    BarangPage(),
    PelangganPage(),
    UserPage(), // Page for User or Admin
    TransaksiPage(), // Page for Transaksi
  ];

  // Titles for each page
  final List<String> _pageTitles = [
    'Data Barang',
    'Data Pelanggan',
    'Data User/Admin',
    'Data Transaksi',
  ];

  // Function to handle navigation
  void _navigateToPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer after navigation
  }

  // Helper function to create the drawer items
  ListTile _buildDrawerItem(String title, IconData icon, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _navigateToPage(index),
      selected: _selectedPageIndex == index, // Highlight selected item
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedPageIndex]), // Update title based on selected page
      ),
      body: _pages[_selectedPageIndex], // Display the current page
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
            // Add menu items for each page
            _buildDrawerItem('Data Barang', Icons.inventory, 0),
            _buildDrawerItem('Data Pelanggan', Icons.people, 1),
            _buildDrawerItem('Data User/Admin', Icons.admin_panel_settings, 2),
            _buildDrawerItem('Data Transaksi', Icons.receipt_long, 3),
          ],
        ),
      ),
    );
  }
}
