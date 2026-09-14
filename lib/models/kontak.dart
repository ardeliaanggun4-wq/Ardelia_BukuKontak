class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String kategori;

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori = 'Umum',
  });

  
  Kontak copyWith({
    String? nama,
    String? email,
    String? noHp,
    String? kategori,
  }) {
    return Kontak(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      kategori: kategori ?? this.kategori,
    );
  }
}