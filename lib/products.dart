import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  Products(this.products);
  @override
  State<StatefulWidget> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Map<String, dynamic>> _products = [];
  bool favoured = false;

  Card _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(_products[index]['image']),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _products[index]['title'],
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
                  'TZS ${_products[index]['price'].toString()}',
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
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Mpanda-Katavi, Tanzania'),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () =>
                    Navigator.pushNamed(context, '/products/$index'),
              ),
              IconButton(
                icon: Icon(favoured? Icons.favorite: Icons.favorite_border),
                onPressed: () => {
                  // ...
                  setState(() => favoured = !favoured)
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCards;
    if (_products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: _products.length,
      );
    } else {
      productCards = Center(
        child: Text('No product found, please add some'),
      );
    }
    return productCards;
  }

  @override
  void initState() {
    _products = widget.products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
