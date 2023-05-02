import 'package:flutter/material.dart';

class ItemDetailsPage extends StatelessWidget {
  final Map<String, String> item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              item['image']!,
              height: 120.0,
              width: 120.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              item['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              item['subtitle']!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
