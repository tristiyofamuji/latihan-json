import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pelanggan.dart';

class PelangganProvider with ChangeNotifier {
  List<Pelanggan> _pelangganList = [];
  bool _isLoading = false;

  List<Pelanggan> get pelangganList => _pelangganList;
  bool get isLoading => _isLoading;

  Future<void> fetchPelanggan() async {
    _isLoading = true;
    notifyListeners();

    const url =
        'https://latihan-json.aksi-pintar.com/api/pelanggan'; // Sesuaikan URL API
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          _pelangganList =
              data.map((item) => Pelanggan.fromJson(item)).toList();
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching pelanggan: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPelanggan({
    required String nama,
    required String alamat,
    required String no_hp,
    required String username,
    required String password,
  }) async {
    const url =
        'https://latihan-json.aksi-pintar.com/api/tambah-pelanggan'; // Sesuaikan URL API Anda
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': nama,
          'alamat': alamat,
          'no_hp': no_hp,
          'username': username,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201 && responseData['status'] == 'success') {
        // Refresh data pelanggan setelah berhasil menambah pelanggan
        await fetchPelanggan();
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (error) {
      print('Error adding pelanggan: $error');
      return false;
    }
  }

  Future<bool> editPelanggan({
    required String id,
    required String nama,
    required String alamat,
    required String no_hp,
    required String username,
    required String password,
  }) async {
    const url =
        'https://latihan-json.aksi-pintar.com/api/update-pelanggan'; // Sesuaikan URL API
    try {
      final response = await http.post(
        Uri.parse('https://latihan-json.aksi-pintar.com/api/update-pelanggan'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'nama': nama,
          'alamat': alamat,
          'no_hp': no_hp,
          'username': username,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Refresh data pelanggan setelah berhasil mengedit
        await fetchPelanggan();
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (error) {
      print('Error editing pelanggan: $error');
      return false;
    }
  }

  Future<bool> deletePelanggan(String id) async {
    const urlBase =
        'https://latihan-json.aksi-pintar.com/api/hapus-pelanggan'; // Sesuaikan URL API
    try {
      final url = Uri.parse('$urlBase/$id'); // Kirim ID pelanggan di URL
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Refresh data pelanggan setelah berhasil menghapus
          await fetchPelanggan();
          return true;
        } else {
          print('Error: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to delete pelanggan: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error deleting pelanggan: $error');
      return false;
    }
  }
}
