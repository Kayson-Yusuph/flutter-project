import 'package:flutter/material.dart';

import '../product_manager.dart';

class ProductsPage extends StatelessWidget {
  final bool mode;
  final List<Map<String, dynamic>> products;
  final Function setMode;

  ProductsPage({
    this.products,
    this.mode,
    this.setMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // ...
            },
          ),
          IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: () {
              setMode(mode);
            },
          )
        ],
      ),
      body: ProductManager(
        products: products,
      ),
    );
  }
}
