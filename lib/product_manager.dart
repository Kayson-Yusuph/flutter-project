import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  ProductManager({this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   margin: EdgeInsets.all(10.0),
        //   child: ProductControl(addProduct),
        // ),
        Expanded(
          child: Products(products),
        ),
      ],
    );
  }
}
