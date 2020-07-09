import 'package:flutter/material.dart';

class ProductsDetailsPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductsDetailsPage({this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: <Widget>[
              Image.asset(imageUrl),
              SizedBox(height: 10.0),
              Text(title),
              SizedBox(height: 10.0),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('DELETE'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
