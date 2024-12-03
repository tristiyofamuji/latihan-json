import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _userList = [];
  bool _isLoading = false;

  List<User> get userList => _userList;
  bool get isLoading => _isLoading;

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    const url =
        'https://latihan-json.aksi-pintar.com/api/user'; // Sesuaikan URL API
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          _userList = data.map((item) => User.fromJson(item)).toList();
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUser({
    required String nama,
    required String alamat,
    required String no_hp,
    required String username,
    required String password,
    required int role,
  }) async {
    const url =
        'https://latihan-json.aksi-pintar.com/api/tambah-user'; // Sesuaikan URL API Anda
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
          'role': role
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201 && responseData['status'] == 'success') {
        // Refresh data user setelah berhasil menambah user
        await fetchUser();
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (error) {
      print('Error adding user: $error');
      return false;
    }
  }

  Future<bool> editUser({
    required String id,
    required String nama,
    required String alamat,
    required String no_hp,
    required String username,
    required String password,
    required int role,
  }) async {
    const url =
        'https://latihan-json.aksi-pintar.com/api/update-user'; // Sesuaikan URL API
    try {
      final response = await http.post(
        Uri.parse('https://latihan-json.aksi-pintar.com/api/update-user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'nama': nama,
          'alamat': alamat,
          'no_hp': no_hp,
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      print(role);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Refresh data user setelah berhasil mengedit
        await fetchUser();
        return true;
      } else {
        print('Error: ${responseData['message']}');
        return false;
      }
    } catch (error) {
      print('Error editing user: $error');
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    const urlBase =
        'https://latihan-json.aksi-pintar.com/api/hapus-user'; // Sesuaikan URL API
    try {
      final url = Uri.parse('$urlBase/$id'); // Kirim ID user di URL
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Refresh data user setelah berhasil menghapus
          await fetchUser();
          return true;
        } else {
          print('Error: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to delete user: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error deleting user: $error');
      return false;
    }
  }
}
