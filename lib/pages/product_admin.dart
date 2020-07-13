import 'package:flutter/material.dart';

import './product_create.dart';
import './product_list.dart';

class ProductAdminPage extends StatelessWidget {
  final bool mode;
  final Function setMode;
  final Function addProduct;
  final Function deleteProduct;

  ProductAdminPage({this.mode, this.setMode, this.addProduct, this.deleteProduct});
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
                leading: Icon(Icons.shop),
                title: Text('All Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
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
                icon: Icon(Icons.create),
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
        body: TabBarView(
          children: [ProductCreatePage(addProduct), ProductListPage()],
        ),
      ),
    );
  }
}
