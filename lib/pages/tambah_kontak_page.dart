import 'package:flutter/material.dart';
import '../models/kontak.dart';

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();

  final List<String> _kategoriList = const ['Umum', 'Keluarga', 'Teman', 'Kerja'];
  String kategoriTerpilih = 'Umum';

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

  void _simpanKontak() {
    if (_formKey.currentState!.validate()) {
      final kontakBaru = Kontak(
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        noHp: hpController.text.trim(),
        kategori: kategoriTerpilih,
      );
      // Kembali ke halaman Kontak sambil membawa data kontak baru
      Navigator.pop(context, kontakBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kontak')),
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
                  onPressed: _simpanKontak,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Simpan'),
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