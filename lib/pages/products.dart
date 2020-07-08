import 'package:flutter/material.dart';

class ProductsDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
        ),
        body: Center(
          child: Text('No product selected!'),
        ));
  }
}
