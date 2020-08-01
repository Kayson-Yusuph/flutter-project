import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../models/product.model.dart';
import '../scoped-model/products.dart';

class ProductListPage extends StatelessWidget {
  _buildProductEditButton(context, int index) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductEditPage(
                  productIndex: index,
                  product: products[index],
                  updateProduct: updateProduct,
                )));
      },
      icon: Icon(
        Icons.edit,
      ),
    );
  }

  ListView _buildProductList() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildProductListTile(context, index);
      },
    );
  }

  Dismissible _buildProductListTile(context, int index) {
    final Product _product = products[index];
    return Dismissible(
      key: Key(products[index].title),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart ||
            direction == DismissDirection.startToEnd) {
          deleteProduct(index);
        } else {
          print('Other swips directions!');
        }
      },
      background: Container(
        color: Colors.red,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                _product.image,
              ),
            ),
            title: Text(
              _product.title,
            ),
            subtitle: Text('TZS ${_product.price.toString()}'),
            trailing: _buildProductEditButton(context, index),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        Widget center = Center(
          child: Text('Product list is empty!'),
        );
        if (model.products.length > 0) {
          center = _buildProductList();
        }
        return center;
      },
    );
  }
}
