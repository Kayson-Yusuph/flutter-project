import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  Products(this.products);

  Card _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                products[index]['title'],
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Oswald',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'TZS ${products[index]['price'].toString()}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(padding: EdgeInsets.all(5), child: Text('Mpanda-Katavi, Tanzania'),),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () =>
                    Navigator.pushNamed(context, '/products/$index'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    } else {
      productCards = Center(
        child: Text('No product found, please add some'),
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
