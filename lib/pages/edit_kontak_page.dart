import 'package:flutter/material.dart';
import '../models/kontak.dart';

class EditKontakPage extends StatefulWidget {
  final Kontak kontak;

  const EditKontakPage({super.key, required this.kontak});

  @override
  State<EditKontakPage> createState() => _EditKontakPageState();
}

class _EditKontakPageState extends State<EditKontakPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController hpController;
  late String kategoriTerpilih;

  final List<String> _kategoriList = const ['Umum', 'Keluarga', 'Teman', 'Kerja'];

  @override
  void initState() {
    super.initState();
    // Form Edit menampilkan data kontak yang sebelumnya sudah tersimpan
    namaController = TextEditingController(text: widget.kontak.nama);
    emailController = TextEditingController(text: widget.kontak.email);
    hpController = TextEditingController(text: widget.kontak.noHp);

    // Jika kategori kontak lama tidak ada dalam daftar pilihan, tambahkan
    // agar tetap tampil dan tidak hilang saat form dibuka.
    kategoriTerpilih = widget.kontak.kategori;
    if (!_kategoriList.contains(kategoriTerpilih)) {
      kategoriTerpilih = _kategoriList.first;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    super.dispose();
  }

  String? _validasiNama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  String? _validasiEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!value.contains('@')) {
      return 'Email harus menggunakan karakter @';
    }
    return null;
  }

  String? _validasiHp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'No. Handphone tidak boleh kosong';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'No. Handphone hanya boleh berupa angka';
    }
    if (value.length < 10) {
      return 'No. Handphone minimal 10 digit';
    }
    return null;
  }

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      // Data lama diperbarui dengan data baru dari form
      final kontakBaru = widget.kontak.copyWith(
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        noHp: hpController.text.trim(),
        kategori: kategoriTerpilih,
      );
      // Kembali ke halaman Kontak sambil membawa data hasil perubahan
      Navigator.pop(context, kontakBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kontak')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: _validasiNama,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validasiEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: hpController,
                decoration: const InputDecoration(
                  labelText: 'No. Handphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: _validasiHp,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: kategoriTerpilih,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _kategoriList
                    .map((kategori) => DropdownMenuItem(
                          value: kategori,
                          child: Text(kategori),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => kategoriTerpilih = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanPerubahan,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Simpan Perubahan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}