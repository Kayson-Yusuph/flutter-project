import 'package:flutter/material.dart';

import './product_edit.dart';
import '../models/product.model.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;
  final Function addProduct;
  final Function deleteProduct;
  final Function updateProduct;
  ProductListPage({this.products, this.addProduct,this.updateProduct, this.deleteProduct});

_buildProductEditButton(context, int index) {
  return IconButton(onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductEditPage(productIndex: index, product: products[index], updateProduct: updateProduct,)));
    }, icon: Icon(Icons.edit,),);
}
  ListView _buildProductList() {
    return ListView.builder( itemCount: products.length, itemBuilder: (BuildContext context, int index) {
      return _buildProductListTile(context,index);
    },);
  }

  Dismissible _buildProductListTile(context,int index) {
    final Product _product = products[index];
    return Dismissible(key: Key(products[index].title), onDismissed: (DismissDirection direction) {
      if(direction == DismissDirection.endToStart) {
        deleteProduct(index);
      } else if(direction == DismissDirection.startToEnd) {
        print('Swiped from left to right!');
      } else {
        print('Other swips directions!');
      }
    }, background: Container(color: Colors.red,), child: Column(children: [ListTile(leading: CircleAvatar(backgroundImage: AssetImage(_product.image,),), title: Text(_product.title,),subtitle: Text('TZS ${_product.price.toString()}'), trailing: _buildProductEditButton(context,index),), Divider(),],),);
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
