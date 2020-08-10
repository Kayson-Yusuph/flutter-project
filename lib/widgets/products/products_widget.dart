import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.model.dart';
import '../../scoped-model/products.dart';

class ProductsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  _buildProductCard(BuildContext context, List<Product> products) {
    Widget productCards = Center(
      child: Text('No product found, please add some'),
    );
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(
          index: index,
          product: products[index],
        ),
        itemCount: products.length,
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      print(model.products.length);
      return _buildProductCard(context, model.products);
    });
  }
}
