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

Widget _buildCreateRaisedButton() {
    // return RaisedButton(
    //             color: Theme.of(context).primaryColor,
    //             child: Text('Save'),
    //             onPressed:
    //                 (_title == '' || _description == '' || _price == null)
    //                     ? null : onCreate,
    //           );
    return GestureDetector(
      onTap: () { print('Double tapped!');},
      child: Container(
      padding: EdgeInsets.all(5),
      color: Colors.green,
      child: Text('Create'),
    ),
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
      child: ListView(
        children: _buildListViewChildren(alignVertical),
      ),
    );
  }
}
