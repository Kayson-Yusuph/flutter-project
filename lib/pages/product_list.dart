import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  ProductListPage({this.products});

  ListView _buildProductList() {
    return ListView.builder( itemCount: products.length, itemBuilder: (BuildContext context, int index) {
      return _buildProductListTile(index);
    },);
  }

  ListTile _buildProductListTile(int index) {
    final Map<String, dynamic> _product = products[index];
    return ListTile(leading: Image.asset(_product['image']), title: Text(_product['title']),subtitle: Text(_product['description']), trailing: Icon(Icons.more_vert,),);
  }
  @override
  Widget build(BuildContext context) {
    Widget center = Center(
      child: Text('Product list here!'),
    );
    if(products.length > 0) {
      center = _buildProductList();
    }
    return  center;
  }
}
