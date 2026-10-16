class Product {
  final int id;
  final String title;
  final String body;
  final int harga;

  Product({
    required this.id,
    required this.title,
    required this.body,
    required this.harga,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final int id = json['id'];
    return Product(
      id: id,
      title: json['title'],
      body: json['body'],
      harga: id * 10000,
    );
  }
}

String formatRupiah(int angka) {
  final teks = angka.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return 'Rp $teks';
}
