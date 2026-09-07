import 'package:flutter/material.dart';
import '../models/kontak.dart';

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  // 1. Bungkus dengan Form + GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final kategoriController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  void _simpanKontak() {
    // 3. Validasi dulu sebelum simpan
    if (_formKey.currentState!.validate()) {
      final kontakBaru = Kontak(
        nama: namaController.text.trim(),
        email: emailController.text.trim(),
        noHp: hpController.text.trim(),
        kategori: kategoriController.text.trim().isEmpty
            ? null
            : kategoriController.text.trim(),
      );
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
              // 2. Nama -> wajib diisi
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. Email -> wajib diisi & harus mengandung '@'
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung karakter @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. No HP -> hanya angka, minimal 10 digit
              TextFormField(
                controller: hpController,
                decoration: const InputDecoration(
                  labelText: 'No. Handphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'No. HP wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'No. HP hanya boleh berisi angka';
                  }
                  if (value.trim().length < 10) {
                    return 'No. HP minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Kategori tetap opsional, tanpa validator
              TextFormField(
                controller: kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (opsional)',
                  hintText: 'Keluarga / Teman / Kerja',
                  border: OutlineInputBorder(),
                ),
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