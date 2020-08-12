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
  Row _buildTitleAndPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleDefault(
          title: widget.product.title,
        ),
        SizedBox(
          width: 10,
        ),
        PriceTag(
          widget.product.price.toString(),
        ),
      ],
    );
  }

  ButtonBar _buildButtonBar(Function setIndex, Function delete) {
    final int index = widget.index;
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setIndex(index);
            print(' Index is $index');
            Navigator.pushNamed(context, '/products/$index').then((value) {
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
          icon: Icon(widget.product.favourite
              ? Icons.favorite
              : Icons.favorite_border),
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
              Image.asset(widget.product.image),
              SizedBox(
                height: 10,
              ),
              _buildTitleAndPriceRow(),
              AddressTag('Mpanda-Katavi, Tanzania'),
              _buildButtonBar(
                model.setSelectedProductIndex,
                model.deleteProduct,
              ),
            ],
          ),
        );
      },
    );
  }

  void manageFavourite() {
    setState(() => widget.product.favourite = !widget.product.favourite);
  }
}
