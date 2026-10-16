import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: Kasus2()));

class Kasus2 extends StatefulWidget {
  const Kasus2({super.key});
  @override
  State<Kasus2> createState() => _Kasus2State();
}

class _Kasus2State extends State<Kasus2> {
  final Map<String, String> _skenario = {
    'Normal (200)': 'https://jsonplaceholder.typicode.com/posts',
    'Server Error (500)': 'https://httpstat.us/500',
    'Not Found (404)': 'https://jsonplaceholder.typicode.com/postsxxx',
    'Host tidak ada': 'https://host-ngawur-123456.com/data',
  };
  String _pilihan = 'Normal (200)';

  List _data = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _data = [];
    });

    try {
      final response = await http
          .get(Uri.parse(_skenario[_pilihan]!))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (!mounted) return;
        setState(() => _data = decoded as List);
      } else if (response.statusCode >= 500) {
        if (!mounted) return;
        setState(
          () => _error =
              'Server lagi bermasalah (${response.statusCode}). Coba lagi nanti ya.',
        );
      } else if (response.statusCode == 404) {
        if (!mounted) return;
        setState(() => _error = 'Data tidak ditemukan (404).');
      } else {
        if (!mounted) return;
        setState(() => _error = 'Terjadi kesalahan (${response.statusCode}).');
      }
    } on SocketException {
      if (!mounted) return;
      setState(() => _error = 'Tidak ada koneksi internet.');
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _error = 'Koneksi timeout, coba lagi.');
    } on FormatException {
      if (!mounted) return;
      setState(() => _error = 'Format data dari server tidak valid.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Terjadi kesalahan tak terduga.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _body() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _fetchData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_data.isEmpty) {
      return const Center(child: Text('Pilih skenario lalu tekan Fetch'));
    }

    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (_, i) => ListTile(
        leading: CircleAvatar(child: Text('${_data[i]['id']}')),
        title: Text(
          _data[i]['title'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus 2: Error Handling')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _pilihan,
                    items: _skenario.keys
                        .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                        .toList(),
                    onChanged: (v) => setState(() => _pilihan = v!),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _fetchData,
                  child: const Text('Fetch'),
                ),
              ],
            ),
          ),
          Expanded(child: _body()),
        ],
      ),
    );
  }
}
