import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/products/price_tag.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../models/product.model.dart';
import '../scoped-model/main.dart';

class ProductsDetailsPage extends StatelessWidget {

  _showDeleteWarning(BuildContext context, Product product) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${product.title}'),
          content: Text('This action can not undone, are you sure?'),
          actions: [
            RaisedButton(
              color: Theme.of(context).secondaryHeaderColor,
              child: Text('DISCARD'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              color: Colors.red,
              child: Text('CONTINUE'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Row _buildTitleAndPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleDefault(title: product.title),
        SizedBox(
          width: 15,
        ),
        PriceTag(
          product.price.toString(),
        ),
      ],
    );
  }

  RaisedButton _buildDeleteRaisedButton(
      BuildContext context, Product product) {
    return RaisedButton(
      color: Colors.red,
      child: Text('DELETE'),
      onPressed: () => _showDeleteWarning(context, product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product product = model.selectedProduct;
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false);
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Product Details'),
            ),
            body: Center(
              child: ListView(
                children: <Widget>[
                  Image.network(product.image),
                  SizedBox(height: 10.0),
                  SizedBox(
                    height: 10,
                  ),
                  _buildTitleAndPriceRow(product),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(product.description),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text('Created by: ${product.userEmail}'),
                  ),
                  SizedBox(height: 10.0),
                  _buildDeleteRaisedButton(
                      context, product),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
