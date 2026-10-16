import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ApiService {
  static const String _url = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.take(20).map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception('Server bermasalah (kode ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Koneksi terlalu lama, coba lagi.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    }
  }
}
