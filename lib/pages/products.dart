import 'package:flutter/material.dart';

class ProductsDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/food.jpg'),
            SizedBox(height: 10.0),
            Text('Details'),
            SizedBox(height: 10.0),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Back'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
