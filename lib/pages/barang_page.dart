import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/barang_provider.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  @override
  void initState() {
    super.initState();
    // Memastikan barang data dimuat saat widget pertama kali ditampilkan
    Provider.of<BarangProvider>(context, listen: false).fetchBarang();
  }

  Future<void> _showAddBarangDialog(BuildContext context) async {
    final kdBarangController = TextEditingController();
    final namaController = TextEditingController();
    final merekController = TextEditingController();
    final hargaController = TextEditingController();
    final stokController = TextEditingController();

    final barangProvider = Provider.of<BarangProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Barang'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: kdBarangController,
                  decoration: const InputDecoration(labelText: 'Kode Barang'),
                ),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Barang'),
                ),
                TextField(
                  controller: merekController,
                  decoration: const InputDecoration(labelText: 'Merek'),
                ),
                TextField(
                  controller: hargaController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stokController,
                  decoration: const InputDecoration(labelText: 'Stok'),
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
                final success = await barangProvider.addBarang(
                  kdBarang: kdBarangController.text,
                  nama: namaController.text,
                  merek: merekController.text,
                  harga: int.tryParse(hargaController.text) ?? 0,
                  stok: int.tryParse(stokController.text) ?? 0,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Barang berhasil ditambahkan')),
                    );
                    // Refresh list after adding
                    barangProvider.fetchBarang();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal menambahkan barang')),
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

  Future<void> _showEditBarangDialog(BuildContext context, var barang) async {
    final kdBarangController = TextEditingController(text: barang.kdBarang);
    final namaController = TextEditingController(text: barang.nama);
    final merekController = TextEditingController(text: barang.merek);
    final hargaController = TextEditingController(text: barang.harga.toString());
    final stokController = TextEditingController(text: barang.stok.toString());

    final barangProvider = Provider.of<BarangProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Barang'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: kdBarangController,
                  decoration: const InputDecoration(labelText: 'Kode Barang'),
                ),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Barang'),
                ),
                TextField(
                  controller: merekController,
                  decoration: const InputDecoration(labelText: 'Merek'),
                ),
                TextField(
                  controller: hargaController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stokController,
                  decoration: const InputDecoration(labelText: 'Stok'),
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
                final success = await barangProvider.editBarang(
                  id: barang.id,
                  kdBarang: kdBarangController.text,
                  nama: namaController.text,
                  merek: merekController.text,
                  harga: int.tryParse(hargaController.text) ?? 0,
                  stok: int.tryParse(stokController.text) ?? 0,
                );

                // Memastikan widget masih aktif sebelum menampilkan notifikasi
                if (mounted) {
                  Navigator.of(ctx).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Barang berhasil diperbarui')),
                    );
                    barangProvider.fetchBarang();  // Refresh list after editing
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal memperbarui barang')),
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
    final barangProvider = Provider.of<BarangProvider>(context, listen: false);

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
      final success = await barangProvider.deleteBarang(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil dihapus')),
        );
        barangProvider.fetchBarang(); // Refresh list after deleting
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus barang')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);

    return Scaffold(
      body: barangProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : barangProvider.barangList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Tidak ada data barang.'),
                      ElevatedButton(
                        onPressed: () {
                          barangProvider.fetchBarang();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: barangProvider.barangList.length,
                  itemBuilder: (context, index) {
                    final barang = barangProvider.barangList[index];
                    return GestureDetector(
                      onTap: () {
                        _showEditBarangDialog(context, barang);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: barang.image != 'no-image.jpg'
                              ? Image.network(
                                  'http://10.10.24.8/latihan-json/images/${barang.image}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                          title: Text(barang.nama),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Merek: ${barang.merek}'),
                              Text('Harga: Rp${barang.harga}'),
                              Text('Stok: ${barang.stok}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, barang.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBarangDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
