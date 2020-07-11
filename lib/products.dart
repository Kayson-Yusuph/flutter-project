import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function deleteProduct;
  Products(this.products, {this.deleteProduct});

  Card _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(products[index]['title']),
              SizedBox(
                width: 15,
              ),
              Text(
                'TZS ${products[index]['price'].toString()}',
              ),
            ],
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () =>
                    Navigator.pushNamed(context, '/products/$index')
                        .then((value) {
                  if (value != null && value) {
                    deleteProduct(index);
                  }
                }),
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
