import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    // Memastikan user data dimuat saat widget pertama kali ditampilkan
    Provider.of<UserProvider>(context, listen: false).fetchUser();
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final noHPController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
                TextField(
                  controller: noHPController,
                  decoration: const InputDecoration(labelText: 'No. HP'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Kata Sandi'),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await userProvider.addUser(
                  nama: namaController.text,
                  alamat: alamatController.text,
                  no_hp: noHPController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                  role: 3,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('User berhasil ditambahkan')),
                    );
                    // Refresh list after adding
                    userProvider.fetchUser();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal menambahkan user')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditUserDialog(BuildContext context, var user) async {
    final namaController = TextEditingController(text: user.nama);
    final alamatController = TextEditingController(text: user.alamat);
    final noHPController = TextEditingController(text: user.alamat);
    final userNameController = TextEditingController(text: user.username);
    final passwordController = TextEditingController(text: null);
    final roleController = TextEditingController(text: user.role);

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
                TextField(
                  controller: noHPController,
                  decoration: const InputDecoration(labelText: 'No. HP'),
                ),
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Kata Sandi'),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await userProvider.editUser(
                    id: user.id,
                    nama: namaController.text,
                    alamat: alamatController.text,
                    no_hp: noHPController.text,
                    username: userNameController.text,
                    password: passwordController.text,
                    role: int.tryParse(roleController.text) ?? 3,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User berhasil diperbarui')),
                    );
                    userProvider.fetchUser(); // Refresh list after editing
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memperbarui user')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final confirm = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin akan menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final success = await userProvider.deleteUser(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User berhasil dihapus')),
        );
        userProvider.fetchUser(); // Refresh list after deleting
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus user')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.userList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tidak ada data user.'),
                      ElevatedButton(
                        onPressed: () {
                          userProvider.fetchUser();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: userProvider.userList.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.userList[index];
                    return GestureDetector(
                      onTap: () {
                        _showEditUserDialog(context, user);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading:
                              const Icon(Icons.image_not_supported, size: 50),
                          title: Text(user.nama),
                          subtitle: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Removed these references
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, user.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
