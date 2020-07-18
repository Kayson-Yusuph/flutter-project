import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String _title;
  String _description;
  double _price;

  TextField _buildTitleTextField() {
    return TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              setState(() => _title = value);
            },
          );
  }

  TextField _buildDescriptionTextField() {
    return TextField(
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            onChanged: (String value) {
              setState(() => _description = value);
            },
          );
  }

  TextField _buildPriceTextField() {
    return TextField(
            decoration: InputDecoration(
                labelText: 'Price', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() => _price = double.parse(value));
            },
          );
  }

RaisedButton _buildCreateRaisedButton() {
    return RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Save'),
                onPressed:
                    (_title == '' || _description == '' || _price == null)
                        ? null : onCreate,
              );
  }

  void onCreate() {
    final product = {
      'title': _title,
      'image': 'assets/food.jpg',
      'description': _description,
      'price': _price,
      'favourite': false
    };
    if (_title != null &&
        _description != null &&
        _price != null) {
      widget.addProduct(product);
    }
    Navigator.pushReplacementNamed(context, '/');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        children: [
          _buildTitleTextField(),
          SizedBox(
            height: 10,
          ),
          _buildDescriptionTextField(),
          SizedBox(
            height: 10,
          ),
          _buildPriceTextField(),
          ButtonBar(
            children: [
              RaisedButton(
                color: Theme.of(context).secondaryHeaderColor,
                child: Text('Cancel'),
                onPressed: () {
                  _title = '';
                  _description = '';
                  _price = 0;
                },
              ),
              _buildCreateRaisedButton(),
            ],
          ),
        ],
      ),
    );
  }
}
