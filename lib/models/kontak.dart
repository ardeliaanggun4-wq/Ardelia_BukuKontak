class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String? kategori;

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori,
  });
}