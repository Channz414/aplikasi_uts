import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product_model.dart';

class TransactionScreen extends StatefulWidget {
  final Product product;
  const TransactionScreen({super.key, required this.product});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();

  int get _total {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    return jumlah * widget.product.harga;
  }

  void _pesan() {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;

    if (jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal pembelian adalah 1!')),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Pesanan berhasil! Total ${formatRupiah(_total)}'),
      ),
    );
    Navigator.pop(context); // kembali ke katalog
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(title: const Text('Form Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              p.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Harga satuan: ${formatRupiah(p.harga)}'),
            const SizedBox(height: 20),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Jumlah Beli',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}), // hitung ulang total
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Catatan Pesanan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bayar:', style: TextStyle(fontSize: 16)),
                    Text(
                      formatRupiah(_total),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pesan,
                child: const Text('Pesan Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
