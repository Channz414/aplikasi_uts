import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Kasus1()));

class Kasus1 extends StatefulWidget {
  const Kasus1({super.key});
  @override
  State<Kasus1> createState() => _Kasus1State();
}

class _Kasus1State extends State<Kasus1> {
  bool _responsif = true;

  final items = List.generate(
    20,
    (i) => 'Produk ${i + 1} namanyaaaaa panjangggggggggggggggggggg',
  );

  Widget _card(String name) => Card(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Icon(Icons.shopping_bag, size: 48)),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Text('Rp 50.000', style: TextStyle(color: Colors.indigo)),
        ],
      ),
    ),
  );

  Widget _gridStatis() => GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
    ),
    itemCount: items.length,
    itemBuilder: (_, i) => _card(items[i]),
  );

  // ignore: unused_element
  Widget _gridLayoutBuilder() => LayoutBuilder(
    builder: (context, c) {
      const spacing = 12.0;
      const itemHeight = 220.0;
      final cols = (c.maxWidth ~/ 180).clamp(2, 6);
      final itemWidth = (c.maxWidth - spacing * (cols + 1)) / cols;

      return GridView.builder(
        padding: const EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: itemWidth / itemHeight,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _card(items[i]),
      );
    },
  );

  // ignore: unused_element
  Widget _gridMediaQuery() {
    final width = MediaQuery.of(context).size.width;
    final cols = width > 600 ? 4 : 2;
    final itemWidth = (width - 12 * (cols + 1)) / cols;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: itemWidth / 220,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _card(items[i]),
    );
  }

  // ignore: unused_element
  Widget _gridExtent() => GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200,
      mainAxisExtent: 220,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: items.length,
    itemBuilder: (_, i) => _card(items[i]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_responsif ? 'Responsif' : 'Statis'),
        actions: [
          Switch(
            value: _responsif,
            onChanged: (v) => setState(() => _responsif = v),
          ),
        ],
      ),
      body: _responsif ? _gridExtent() : _gridStatis(),
    );
  }
}
