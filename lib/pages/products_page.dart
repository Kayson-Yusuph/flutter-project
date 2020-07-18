import 'package:flutter/material.dart';

import '../widgets/products/products_widget.dart';

class ProductsPage extends StatelessWidget {
  final bool mode;
  final List<Map<String, dynamic>> products;
  final Function setMode;

  ProductsPage({
    this.products,
    this.mode,
    this.setMode,
  });

  Drawer _buildSideDrawer(BuildContext context) {
    return Drawer(
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('EasyList'),
      actions: products.length > 0 ? [
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            // ...
          },
        ), IconButton(
          icon: Icon(Icons.wb_sunny),
          onPressed: () {
            setMode(mode);
          },
        )
      ]: [
        IconButton(
          icon: Icon(Icons.wb_sunny),
          onPressed: () {
            setMode(mode);
          },
        )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: _buildAppBar(),
      body: ProductsWidget(products),
    );
  }
}
