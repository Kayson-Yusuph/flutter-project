import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.model.dart';
import '../../scoped-model/main.dart';

class ProductsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  _buildProductCards(BuildContext context, List<Product> products) {
    Widget productCards = Stack(
      children: <Widget>[
        ListView(),
        Center(
          child: Text('No product found, please add some'),
        ),
      ],
    );
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(index: index),
        itemCount: products.length,
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      // print(model.products.length);
      return _buildProductCards(context, model.displayProducts);
    });
  }
}
