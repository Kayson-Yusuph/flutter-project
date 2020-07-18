import 'package:flutter/material.dart';

import './product_card.dart';

class ProductsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  ProductsWidget(this.products);
  @override
  State<StatefulWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  List<Map<String, dynamic>> _products = [];
  bool favoured = false;

  @override
  void initState() {
    _products = widget.products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget productCards;
    if (_products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(favourite: favoured, index: index, product: _products[index], manageFavourite: manageFavourite,),
        itemCount: _products.length,
      );
    } else {
      productCards = Center(
        child: Text('No product found, please add some'),
      );
    }
    return productCards;
  }

  void manageFavourite(favoured) {
    setState(() => favoured = !favoured);
  }
}
