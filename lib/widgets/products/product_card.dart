import 'package:flutter/material.dart';

import './price_tag.dart';
import '../ui_elements/address_tag.dart';
import '../ui_elements/title_default.dart';

class ProductCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> product;

  ProductCard({ this.index, this.product });
  @override
  State<StatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  int _index = 0;
  Map<String, dynamic> _product = {};

  @override
  void initState() {
    _product = widget.product;
    _index = widget.index;
    super.initState();
  }

  Row _buildTitleAndPriceRow(){
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TitleDefault(title: _product['title'],),
            SizedBox(
              width: 10,
            ),
            PriceTag(_product['price'].toString(),)
            ,
          ],
        );
  } 

  ButtonBar _buildButtonBar() {
    return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).primaryColor,
              onPressed: () =>
                  Navigator.pushNamed(context, '/products/$_index'),
            ),
            IconButton(
              icon: Icon(_product['favourite']? Icons.favorite: Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                // ...
                manageFavourite();
              },
            )
          ],
        );
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
          _buildTitleAndPriceRow(),
          AddressTag('Mpanda-Katavi, Tanzania'),
          _buildButtonBar(),
        ],
      ),
    );
  }
  void manageFavourite() {
    setState(() => _product['favourite'] = !_product['favourite']);
  }
}