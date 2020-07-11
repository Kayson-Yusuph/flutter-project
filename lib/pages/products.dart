import 'package:flutter/material.dart';

import '../product_manager.dart';

class ProductsPage extends StatelessWidget {
  final bool mode;
  final Function setMode;
  final Function addProduct;
  final Function deleteProduct;
  final List<Map<String, dynamic>> products;

  ProductsPage({
    this.products,
    this.mode,
    this.setMode,
    this.addProduct,
    this.deleteProduct,
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
            icon: Icon(Icons.wb_sunny),
            onPressed: () {
              setMode(mode);
            },
          )
        ],
      ),
      body: ProductManager(
        products: products,
        addProduct: addProduct,
        deleteProduct: deleteProduct,
      ),
    );
  }
}
