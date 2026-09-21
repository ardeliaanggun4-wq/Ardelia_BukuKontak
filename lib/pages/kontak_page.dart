import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kontak.dart';
import 'edit_kontak_page.dart';

class KontakPage extends StatefulWidget {
  const KontakPage({super.key});

  @override
  State<KontakPage> createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  final TextEditingController _searchController = TextEditingController();
  String _kataKunci = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _tampilkanPesan(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // Membuka Halaman Edit Kontak, lalu memperbarui dokumen yang SAMA
  // di Firestore (dicari lewat kontak.id) sehingga tidak muncul kontak ganda.
  Future<void> _bukaEdit(Kontak kontakLama) async {
    final hasil = await Navigator.push<Kontak>(
      context,
      MaterialPageRoute(
        builder: (context) => EditKontakPage(kontak: kontakLama),
      ),
    );

    if (hasil == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('kontak')
          .doc(kontakLama.id)
          .update(hasil.toMap());
      _tampilkanPesan('Data berhasil diperbarui');
    } catch (e) {
      debugPrint('ERROR EDIT: $e');
      _tampilkanPesan('Gagal memperbarui: $e');
    }
  }

  // Dialog konfirmasi, lalu hapus dokumen di Firestore lewat kontak.id
  Future<void> _konfirmasiHapus(Kontak kontak) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kontak'),
        content: Text('Apakah Anda yakin ingin menghapus "${kontak.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('kontak')
          .doc(kontak.id)
          .delete();
      _tampilkanPesan('Kontak berhasil dihapus');
    } catch (e) {
      debugPrint('ERROR HAPUS: $e');
      _tampilkanPesan('Gagal menghapus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama atau kategori...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: _kataKunci.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _kataKunci = '');
                      },
                    ),
            ),
            onChanged: (value) => setState(() => _kataKunci = value),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FirebaseFirestore.instance.collection('kontak').snapshots(),
            builder: (context, snapshot) {
              // Sedang memuat data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Terjadi error
              if (snapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'),
                );
              }

              // Ubah dokumen Firestore menjadi daftar Kontak
              final semuaKontak = (snapshot.data?.docs ?? [])
                  .map((doc) => Kontak.fromFirestore(doc))
                  .toList();

              // Saring berdasarkan kata kunci pencarian (nama)
              final hasilPencarian = semuaKontak.where((k) {
                final kata = _kataKunci.toLowerCase();
                return _kataKunci.isEmpty ||
                    k.nama.toLowerCase().contains(kata) ||
                    k.kategori.toLowerCase().contains(kata);
              }).toList();

              if (semuaKontak.isEmpty) {
                return const Center(
                  child: Text(
                      'Belum ada kontak. Tekan tombol + untuk menambah.'),
                );
              }

              if (hasilPencarian.isEmpty) {
                return const Center(child: Text('Kontak tidak ditemukan.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: hasilPencarian.length,
                itemBuilder: (context, i) {
                  final kontak = hasilPencarian[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          kontak.nama.isNotEmpty
                              ? kontak.nama[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(kontak.nama),
                      subtitle: Text(
                        '${kontak.email}\n${kontak.noHp}\nKategori: ${kontak.kategori}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            tooltip: 'Edit',
                            onPressed: () => _bukaEdit(kontak),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Hapus',
                            onPressed: () => _konfirmasiHapus(kontak),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}