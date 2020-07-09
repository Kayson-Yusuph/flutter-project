import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductManager extends StatelessWidget {
  // final Map<String, String> startingProduct;
  final List<Map<String, String>> products;
  final Function addProduct;
  final Function deleteProduct;
  ProductManager({this.products, this.addProduct, this.deleteProduct});

//   @override
//   State<StatefulWidget> createState() {
//     return _ProductManager();
//   }
// }

// class _ProductManager extends State<ProductManager> {

//   @override
//   void initState() {
//     if (widget.startingProduct != null) {
//       _products.add(widget.startingProduct);
//     }
//     super.initState();
//   }

  // void _addProduct(Map<String, String> product) {
  //   setState(() {
  //     _products.add(product);
  //   });
  // }

  // void _deleteProduct(int index) {
  //   setState(() {
  //     _products.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(addProduct),
        ),
        Expanded(
          child: Products(products, deleteProduct: deleteProduct),
        ),
      ],
    );
  }
}
