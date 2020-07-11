import 'package:flutter/material.dart';

class ProductsDetailsPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductsDetailsPage({this.title, this.imageUrl});

  _showDeleteWarning(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete confirmation'),
          content: Text('This action can not undo, are you sure?'),
          actions: [
            RaisedButton(
              color: Theme.of(context).secondaryHeaderColor,
              child: Text('DISCARD'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
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
                color: Theme.of(context).accentColor,
                child: Text('DELETE'),
                onPressed: () => _showDeleteWarning(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
