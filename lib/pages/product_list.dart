import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/shared/app-loader.dart';
import './product_edit.dart';
import '../models/product.model.dart';
import '../scoped-model/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;
  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }

  ProductListPage(this.model);
}

class _ProductListState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  _buildProductEditButton(context, Product product, Function setProductId) {
    return IconButton(
      onPressed: () {
        setProductId(product.id);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProductEditPage()))
            .then((_) {
          setProductId(null);
        });
      },
      icon: Icon(
        Icons.edit,
      ),
    );
  }

  ListView _buildProductList(BuildContext context, List<Product> products,
      Function setProductId, Function delete) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildProductListTile(
            context, products[index], index, setProductId, delete);
      },
    );
  }

  _showErrorDialog(BuildContext context) {
    final oldContext = context;
    return showDialog(
        context: oldContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text('Please try again later after sometime.'),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(oldContext).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }

  Dismissible _buildProductListTile(context, Product product, int index,
      Function setProductId, Function delete) {
    // final Product _product = products[index];
    return Dismissible(
      key: Key(product.title),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart ||
            direction == DismissDirection.startToEnd) {
          setProductId(product.id);
          delete().then((bool success) {
            if (!success) {
              _showErrorDialog(context);
            }
            setProductId(null);

          });
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
            trailing: _buildProductEditButton(context, product, setProductId),
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
              model.setSelectedProductId, model.deleteProduct);
        }
        return model.loading
            ? AppSimpleLoader()
            : RefreshIndicator(
                onRefresh: () {
                  return model.fetchProducts(onlyForUser: true);
                },
                child: center,
              );
      },
    );
  }
}
