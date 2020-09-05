import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.model.dart';
import '../../scoped-model/main.dart';

class ProductCard extends StatefulWidget {
  final int index;

  ProductCard({this.index});
  @override
  State<StatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Row _buildTitleAndPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleDefault(
          title: product.title,
        ),
        SizedBox(
          width: 10,
        ),
        PriceTag(
          product.price.toString(),
        ),
      ],
    );
  }

  ButtonBar _buildButtonBar(
      product, Function setIndex, Function delete, Function toggleStatus) {
    final int index = widget.index;
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setIndex(index);
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
          icon:
              Icon(product.favourite ? Icons.favorite : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            // ...
            setIndex(index);
            toggleStatus();
          },
        )
      ],
    );
  }

  @override
  ScopedModelDescendant<MainModel> build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product product = model.displayProducts[widget.index];
        return Card(
          child: Column(
            children: <Widget>[
              Image.asset(product.image),
              SizedBox(
                height: 10,
              ),
              _buildTitleAndPriceRow(product),
              AddressTag('Mpanda-Katavi, Tanzania'),
              Text(product.userEmail),
              _buildButtonBar(product, model.setSelectedProductIndex,
                  model.deleteProduct, model.toggleProductFavourityStatus),
            ],
          ),
        );
      },
    );
  }
}
