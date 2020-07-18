import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/products/price_tag.dart';

import '../widgets/ui_elements/title_default.dart';

class ProductsDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductsDetailsPage({this.product});

  _showDeleteWarning(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${product['title']}'),
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

  Row _buildTitleAndPriceRow() {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleDefault(title: product['title']),
              SizedBox(
                width: 15,
              ),
              PriceTag(product['price'].toString(),),
            ],
          );
  }

  RaisedButton _buildDeleteRaisedButton(BuildContext context) {
    return  RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('DELETE'),
                onPressed: () => _showDeleteWarning(context),
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
          child: ListView(
            children: <Widget>[
              Image.asset(product['image']),
              SizedBox(height: 10.0),SizedBox(height: 10,),
              _buildTitleAndPriceRow(),
              SizedBox(height: 10.0),
              Text(product['description']),
              SizedBox(height: 10.0),
            _buildDeleteRaisedButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
