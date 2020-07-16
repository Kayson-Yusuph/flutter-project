import 'package:flutter/material.dart';

import './price_tag.dart';
import '../ui_elements/title_default.dart';

class ProductCard extends StatefulWidget {
  final bool favourite;
  final int index;
  final Map<String, dynamic> product;
  final Function manageFavourite;

  ProductCard({this.favourite, this.index, this.product, this.manageFavourite});
  @override
  State<StatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  bool _favourite = false;
  int _index = 0;
  Map<String, dynamic> _product = {};

  @override
  void initState() {
    // _product = widget.product;
    _index = widget.index;
    print('favourite is ' + _product['favourite']);
    super.initState();
  }
  @override
  Card build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(_product['image']),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            TitleDefault(title: _product['title'],),
              SizedBox(
                width: 10,
              ),
              PriceTag(_product['price'].toString(),)
              ,
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
                color: Theme.of(context).primaryColor,
                onPressed: () =>
                    Navigator.pushNamed(context, '/products/$_index'),
              ),
              IconButton(
                icon: Icon(_favourite? Icons.favorite: Icons.favorite_border),
                color: Colors.red,
                onPressed: () => {
                  // ...
                  manageFavourite(_favourite)
                },
              )
            ],
          )
        ],
      ),
    );
  }
  void manageFavourite(favoured) {
    setState(() => favoured = !favoured);
  }
}