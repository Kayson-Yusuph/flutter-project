import 'package:flutter/material.dart';

import './products.dart';

class ProductAdminPage extends StatelessWidget {
  final bool mode;
  final Function setMode;

  ProductAdminPage({this.mode, this.setMode});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                title: Text('Product list'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProductsPage(
                        mode: mode,
                        setMode: setMode,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Create Product',
                icon: Icon(Icons.edit),
              ),
              Tab(
                text: 'Product List',
                icon: Icon(Icons.list),
              ),
            ],
          ),
          title: Text('Manage products'),
          actions: [
            IconButton(
              icon: Icon(Icons.wb_sunny),
              onPressed: () {
                setMode(mode);
              },
            ),
          ],
        ),
        body: Center(
          child: Text('No product to manage'),
        ),
      ),
    );
  }
}
