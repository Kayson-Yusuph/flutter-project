import 'package:flutter/material.dart';


class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function deleteProduct;
  ProductListPage({this.products, this.deleteProduct});

  ListView _buildProductList() {
    return ListView.builder( itemCount: products.length, itemBuilder: (BuildContext context, int index) {
      return _buildProductListTile(index);
    },);
  }

  Dismissible _buildProductListTile(int index) {
    final Map<String, dynamic> _product = products[index];
    return Dismissible(key: Key(products[index]['title']), onDismissed: (DismissDirection direction) {
      if(direction == DismissDirection.endToStart) {
        deleteProduct(index);
      } else if(direction == DismissDirection.startToEnd) {
        print('Swiped from left to right!');
      } else {
        print('Other swips directions!');
      }
    }, background: Container(color: Colors.red,), child: Column(children: [ListTile(leading: CircleAvatar(backgroundImage: AssetImage(_product['image'],),), title: Text(_product['title'],),subtitle: Text('TZS ${_product['price'].toString()}'), trailing: GestureDetector(onTap: () {
      print('${products[index]['title']} selected!');
    }, child: Icon(Icons.edit,),),), Divider(),],),);
  }
  
  @override
  Widget build(BuildContext context) {
    Widget center = Center(
      child: Text('Product list is empty!'),
    );
    if(products.length > 0) {
      center = _buildProductList();
    }
    return  center;
  }
}
