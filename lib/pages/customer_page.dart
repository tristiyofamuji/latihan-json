import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pelanggan_provider.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  void initState() {
    super.initState();
    // Memastikan pelanggan data dimuat saat widget pertama kali ditampilkan
    Provider.of<PelangganProvider>(context, listen: false).fetchPelanggan();
  }

  Future<void> _showAddPelangganDialog(BuildContext context) async {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final noHPController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    final pelangganProvider =
        Provider.of<PelangganProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Pelanggan'),
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
                final success = await pelangganProvider.addPelanggan(
                  nama: namaController.text,
                  alamat: alamatController.text,
                  no_hp: noHPController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pelanggan berhasil ditambahkan')),
                    );
                    // Refresh list after adding
                    pelangganProvider.fetchPelanggan();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal menambahkan pelanggan')),
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

  Future<void> _showEditPelangganDialog(
      BuildContext context, var pelanggan) async {
    final namaController = TextEditingController(text: pelanggan.nama);
    final alamatController = TextEditingController(text: pelanggan.alamat);
    final noHPController = TextEditingController(text: pelanggan.alamat);
    final userNameController = TextEditingController(text: pelanggan.username);
    final passwordController = TextEditingController(text: null);

    final pelangganProvider =
        Provider.of<PelangganProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Pelanggan'),
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
                ),TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Kata Sandi'),
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
                final success = await pelangganProvider.editPelanggan(
                  id: pelanggan.id,
                  nama: namaController.text,
                  alamat: alamatController.text,
                  no_hp: noHPController.text,
                  username: userNameController.text,
                  password: passwordController.text,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pelanggan berhasil diperbarui')),
                    );
                    pelangganProvider
                        .fetchPelanggan(); // Refresh list after editing
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memperbarui pelanggan')),
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
    final pelangganProvider =
        Provider.of<PelangganProvider>(context, listen: false);

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
      final success = await pelangganProvider.deletePelanggan(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pelanggan berhasil dihapus')),
        );
        pelangganProvider.fetchPelanggan(); // Refresh list after deleting
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus pelanggan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pelangganProvider = Provider.of<PelangganProvider>(context);

    return Scaffold(
      body: pelangganProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : pelangganProvider.pelangganList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tidak ada data pelanggan.'),
                      ElevatedButton(
                        onPressed: () {
                          pelangganProvider.fetchPelanggan();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: pelangganProvider.pelangganList.length,
                  itemBuilder: (context, index) {
                    final pelanggan = pelangganProvider.pelangganList[index];
                    return GestureDetector(
                      onTap: () {
                        _showEditPelangganDialog(context, pelanggan);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.image_not_supported, size: 50),
                          title: Text(pelanggan.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Removed these references
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, pelanggan.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPelangganDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
