import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../ui_elements/address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.model.dart';
import '../../scoped-model/main.dart';

class ProductCard extends StatefulWidget {
  final int index;

  ProductCard(this.index);
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

  _showErrorDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text('Please try again later after sometime.'),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }

  ButtonBar _buildButtonBar(
      product, Function setProductId, Function delete, Function toggleStatus) {
    final int index = widget.index;
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            // setIndex(index);
            // setProductId(product.id);
            Navigator.pushNamed(context, '/products/${product.id}')
                .then((value) {
                setProductId(null);
            });
          },
        ),
        IconButton(
          icon: Icon(product.favorite ? Icons.favorite : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            // ...
            setProductId(product.id);
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
              FadeInImage(
                image: product.imageExist? NetworkImage(product.image): AssetImage('assets/image-not-found.jpg'),
                placeholder: AssetImage('assets/image-loading.png'),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTitleAndPriceRow(product),
              AddressTag('Mpanda-Katavi, Tanzania'),
              Text(product.userEmail),
              _buildButtonBar(product, model.setSelectedProductId,
                  model.deleteProduct, model.toggleProductFavoriteStatus),
            ],
          ),
        );
      },
    );
  }
}
