import 'package:flutter/material.dart';

class ProductsDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center( child: Column(
        children: <Widget>[
          Container(
            child: Text('Details'),
          ),
          RaisedButton(
            child: Text('Back'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),),
    );
  }
}
