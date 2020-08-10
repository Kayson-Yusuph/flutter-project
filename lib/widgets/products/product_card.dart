import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.model.dart';
import '../../scoped-model/products.dart';

class ProductCard extends StatefulWidget {
  final int index;
  final Product product;

  ProductCard({this.index, this.product});
  @override
  State<StatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _index = 0;
  Product _product;

  @override
  void initState() {
    _product = widget.product;
    _index = widget.index;
    super.initState();
  }

  Row _buildTitleAndPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleDefault(
          title: _product.title,
        ),
        SizedBox(
          width: 10,
        ),
        PriceTag(
          _product.price.toString(),
        ),
      ],
    );
  }

  ButtonBar _buildButtonBar(int index, Function setIndex, Function delete) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setIndex(index);
            Navigator.pushNamed(context, '/products/$_index').then((value) {
              if (value != null && value == true) {
                print(value);
                delete();
              } else {
                print(value);
                setIndex(-1);
              }
            });
          },
        ),
        IconButton(
          icon:
              Icon(_product.favourite ? Icons.favorite : Icons.favorite_border),
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
  ScopedModelDescendant<ProductsModel> build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return Card(
          child: Column(
            children: <Widget>[
              Image.asset(_product.image),
              SizedBox(
                height: 10,
              ),
              _buildTitleAndPriceRow(),
              AddressTag('Mpanda-Katavi, Tanzania'),
              _buildButtonBar(
                  _index, model.setSelectedProductIndex, model.deleteProduct),
            ],
          ),
        );
      },
    );
  }

  void manageFavourite() {
    setState(() => _product.favourite = !_product.favourite);
  }
}
