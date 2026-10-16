import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HomeKasus3()));

class HomeKasus3 extends StatelessWidget {
  const HomeKasus3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus 3: Dispose')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormTransaksi()),
          ),
          child: const Text('Buka Form Transaksi'),
        ),
      ),
    );
  }
}

class FormTransaksi extends StatefulWidget {
  const FormTransaksi({super.key});
  @override
  State<FormTransaksi> createState() => _FormTransaksiState();
}

class _FormTransaksiState extends State<FormTransaksi> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('initState: controller dibuat');
  }

  @override
  void dispose() {
    debugPrint('dispose: controller dilepas');
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nama: ${_namaController.text}, Jumlah: ${_jumlahController.text}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pembeli',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Beli',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (int.tryParse(v ?? '') ?? 0) < 1 ? 'Minimal 1' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
