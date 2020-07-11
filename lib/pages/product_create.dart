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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Tile',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              setState(() => _title = value);
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            onChanged: (String value) {
              setState(() => _description = value);
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
                labelText: 'Price', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() => _price = double.parse(value));
            },
          ),
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
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Save'),
                onPressed:
                    (_title == '' || _description == '' || _price == null)
                        ? null
                        : () {
                            print({
                              'title': _title,
                              'description': _description,
                              'price': _price
                            });
                            final product = {
                              'title': _title,
                              'image': 'assets/food.jpg',
                              'description': _description,
                              'price': _price
                            };
                            if (_title != null &&
                                _description != null &&
                                _price != null) {
                              widget.addProduct(product);
                            }
                            Navigator.pushReplacementNamed(context, '/');
                          },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
