import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../models/product.model.dart';

class ProductAdminPage extends StatelessWidget {
  final List<Product> products;
  final bool mode;
  final Function setMode;
  final Function addProduct;
  final Function updateProduct;
  final Function deleteProduct;

  ProductAdminPage({this.products,this.mode, this.setMode, this.addProduct, this.updateProduct, this.deleteProduct});

TabBar _buildTabsBar() {
    return TabBar(
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
          );
  }
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
          bottom: _buildTabsBar(),
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
          children: [ProductEditPage(addProduct: addProduct), ProductListPage(products: products,addProduct: addProduct, deleteProduct: deleteProduct, updateProduct: updateProduct,)],
        ),
      ),
    );
  }
}
