import 'package:cloud_firestore/cloud_firestore.dart';

class Kontak {
  final String id;
  final String nama;
  final String email;
  final String noHp;
  final String kategori;

  Kontak({
    this.id = '',
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori = 'Umum',
  });

  Kontak copyWith({
    String? id,
    String? nama,
    String? email,
    String? noHp,
    String? kategori,
  }) {
    return Kontak(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      kategori: kategori ?? this.kategori,
    );
  }

  // Ubah dokumen Firestore menjadi objek Kontak
  factory Kontak.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Kontak(
      id: doc.id,
      nama: data['nama'] ?? '',
      email: data['email'] ?? '',
      noHp: data['hp'] ?? '',
      kategori: data['kategori'] ?? 'Umum',
    );
  }

  // Ubah objek Kontak menjadi data untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'hp': noHp,
      'kategori': kategori,
    };
  }
}