import 'package:flutter/material.dart';
import '../models/kontak.dart';
import 'edit_kontak_page.dart';

class KontakPage extends StatefulWidget {
  final List<Kontak> kontakList;
  final void Function(int index, Kontak kontakBaru) onEdit;
  final void Function(int index) onDelete;

  const KontakPage({
    super.key,
    required this.kontakList,
    required this.onEdit,
    required this.onDelete,
  });

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

  // Membuka Halaman Edit Kontak. index yang dikirim selalu merujuk pada
  // posisi kontak di daftar ASLI (_kontakList di HomePage), bukan posisi
  // pada hasil pencarian, sehingga kontak yang diedit tetap benar
  // walaupun sedang dalam kondisi difilter oleh pencarian.
  Future<void> _bukaEdit(int index) async {
    final kontakLama = widget.kontakList[index];
    final hasil = await Navigator.push<Kontak>(
      context,
      MaterialPageRoute(
        builder: (context) => EditKontakPage(kontak: kontakLama),
      ),
    );

    if (hasil != null) {
      widget.onEdit(index, hasil);
    }
  }

  // Menampilkan dialog konfirmasi sebelum menghapus. index yang dikirim
  // juga selalu merujuk pada posisi kontak di daftar ASLI, dengan alasan
  // yang sama seperti pada _bukaEdit di atas.
  Future<void> _konfirmasiHapus(int index) async {
    final kontak = widget.kontakList[index];
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

    // Jika memilih Batal (atau dialog ditutup), kontak tidak boleh terhapus
    if (konfirmasi == true) {
      widget.onDelete(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pasangkan setiap kontak dengan index aslinya di _kontakList,
    // lalu filter berdasarkan kata kunci pencarian (nama).
    final List<MapEntry<int, Kontak>> hasilPencarian = [];
    for (int i = 0; i < widget.kontakList.length; i++) {
      final kontak = widget.kontakList[i];
      final cocok = _kataKunci.isEmpty ||
          kontak.nama.toLowerCase().contains(_kataKunci.toLowerCase());
      if (cocok) {
        hasilPencarian.add(MapEntry(i, kontak));
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari kontak berdasarkan nama...',
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
          child: widget.kontakList.isEmpty
              ? const Center(
                  child: Text('Belum ada kontak. Tekan tombol + untuk menambah.'),
                )
              : hasilPencarian.isEmpty
                  ? const Center(child: Text('Kontak tidak ditemukan.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: hasilPencarian.length,
                      itemBuilder: (context, i) {
                        final indexAsli = hasilPencarian[i].key;
                        final kontak = hasilPencarian[i].value;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                                  onPressed: () => _bukaEdit(indexAsli),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Hapus',
                                  onPressed: () => _konfirmasiHapus(indexAsli),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}