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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextFormField _buildTitleTextField() {
    return TextFormField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            // autovalidate: true,
            validator: (String value) {
              if(value.isEmpty) {
                return 'Title is required';
              }
            },
            onSaved: (String value) {
              setState(() => _title = value);
            },
          );
  }

  TextFormField _buildDescriptionTextField() {
    return TextFormField(
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            validator: (String value) {
              if(value.isEmpty) {
                return 'Description is required';
              }
            },
            maxLines: 5,
            onSaved: (String value) {
              setState(() => _description = value);
            },
          );
  }

  TextFormField _buildPriceTextField() {
    return TextFormField(
            decoration: InputDecoration(
                labelText: 'Price', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (String value) {

              if(value.isNotEmpty && double.tryParse(value) == null) {
                return 'Enter a valid price in number';
              }
              if(value.isEmpty) {
                return 'Price is required';
              }
            },
            onSaved: (String value) {
              setState(() => _price = double.parse(value));
            },
          );
  }

Widget _buildCreateRaisedButton() {
    return RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Save'),
                onPressed: onCreate,
                    // (_title == '' || _description == '' || _price == null)
                    //     ? null : onCreate,
              );
  }

  void onCreate() {
    if(!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
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

  List<Widget> _buildListViewChildren(bool vertical) {
    List<Widget> children =  <Widget>[
          _buildTitleTextField(),
          SizedBox(
            height: 10,
          ),
          _buildPriceTextField(),
          SizedBox(
            height: 10,
          ),
          _buildDescriptionTextField(),
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
        ];

    if(!vertical) {
      children =  <Widget>[
        Row(children: [
        Flexible(child: _buildTitleTextField(), flex: 4,),
          SizedBox(
            width: 10,
          ),
          Flexible(child: _buildPriceTextField(), flex: 3,),
        ],),
          SizedBox(
            height: 10,
          ),
          _buildDescriptionTextField(),
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
        ];
    }
    return children;
  }
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
  bool alignVertical = true;
    if(deviceWidth > 420) {
      alignVertical = false;
    }
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(key: _formKey, child: ListView(
        children: _buildListViewChildren(alignVertical),
      ),),
    );
  }
}
