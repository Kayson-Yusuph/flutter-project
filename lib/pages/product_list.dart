import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/shared/app-loader.dart';
import './product_edit.dart';
import '../models/product.model.dart';
import '../scoped-model/main.dart';

class ProductListPage extends StatelessWidget {
  _buildProductEditButton(context, int index, Function selectProductIndex) {
    return IconButton(
      onPressed: () {
        selectProductIndex(index);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProductEditPage()))
            .then((_) {
          selectProductIndex(null);
        });
      },
      icon: Icon(
        Icons.edit,
      ),
    );
  }

  ListView _buildProductList(BuildContext context, List<Product> products,
      Function setIndex, Function delete) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildProductListTile(
            context, products[index], index, setIndex, delete);
      },
    );
  }

  Dismissible _buildProductListTile(
      context, Product product, int index, Function setIndex, Function delete) {
    // final Product _product = products[index];
    return Dismissible(
      key: Key(product.title),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart ||
            direction == DismissDirection.startToEnd) {
          setIndex(index);
          delete();
        } else {
          print('Other swipe directions!');
        }
      },
      background: Container(
        color: Colors.red,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                product.image,
              ),
            ),
            title: Text(
              product.title,
            ),
            subtitle: Text('TZS ${product.price.toString()}'),
            trailing: _buildProductEditButton(context, index, setIndex),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final List<Product> products = model.allProducts;
        Widget center = Stack(
          children: <Widget>[
            ListView(),
            Center(
              child: Text('Product list is empty!'),
            )
          ],
        );
        if (model.allProducts.length > 0) {
          center = _buildProductList(context, products,
              model.setSelectedProductIndex, model.deleteProduct);
        }
        return model.loading
            ? AppSimpleLoader()
            : RefreshIndicator(
                onRefresh: model.fetchProducts,
                child: center,
              );
      },
    );
  }
}
