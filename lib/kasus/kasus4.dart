import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: TransaksiScreen()));

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});
  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  static const int _harga = 100000;
  final _jumlahController = TextEditingController(text: '1');
  int _jumlah = 1;
  String? _voucher;

  static const Map<String, double> _diskon = {
    'DISCON20': 0.20,
    'DISCON50': 0.50,
  };

  int get _subtotal => _harga * _jumlah;
  int get _potongan => (_subtotal * (_diskon[_voucher] ?? 0)).round();
  int get _total => _subtotal - _potongan;

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _pilihVoucher() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const VoucherScreen()),
    );

    if (result != null && mounted) {
      setState(() => _voucher = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Kaos Polos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Harga: Rp $_harga'),
            const SizedBox(height: 16),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Beli',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _jumlah = int.tryParse(v) ?? 0),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pilihVoucher,
              icon: const Icon(Icons.local_offer),
              label: Text(
                _voucher == null
                    ? 'Pilih Voucher Diskon'
                    : 'Voucher: $_voucher',
              ),
            ),
            const Divider(height: 32),
            Text('Subtotal : Rp $_subtotal'),
            Text('Diskon   : - Rp $_potongan'),
            const SizedBox(height: 4),
            Text(
              'Total Bayar: Rp $_total',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vouchers = [
      {'kode': 'DISCON20', 'ket': 'Diskon 20%'},
      {'kode': 'DISCON50', 'ket': 'Diskon 50%'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Voucher')),
      body: ListView(
        children: vouchers
            .map(
              (v) => ListTile(
                leading: const Icon(Icons.confirmation_number),
                title: Text(v['ket']!),
                subtitle: Text(v['kode']!),
                onTap: () => Navigator.pop(context, v['kode']),
              ),
            )
            .toList(),
      ),
    );
  }
}
