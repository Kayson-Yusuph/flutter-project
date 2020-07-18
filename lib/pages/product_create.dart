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
  final Map<String, dynamic> _formData = {
    'title': null,
    'price': null,
    'description': null,
    'image': 'assets/food.jpg',
    'favourite': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextFormField _buildTitleTextField() {
    return TextFormField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            // autovalidate: true,
            validator: (String value) {
              dynamic rtn;
              if(value.isEmpty || value.length < 5) {
                rtn = 'Title is required and must be 5+ characters';
              }
              return rtn;
            },
            onSaved: (String value) {
              _formData['title'] = value;
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
              dynamic rtn;
              if(value.isEmpty || value.length < 10) {
                rtn = 'Description is required and must be 10+ characters';
              }
              return rtn;
            },
            maxLines: 5,
            onSaved: (String value) {
              _formData['description'] = value;
            },
          );
  }

  TextFormField _buildPriceTextField() {
    return TextFormField(
            decoration: InputDecoration(
                labelText: 'Price', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (String value) {
              dynamic rtn;
              if(value.isEmpty || double.tryParse(value) == null) {
                rtn = 'Price is required and must be a number';
              }
              return rtn;
            },
            onSaved: (String value) {
              _formData['price'] = double.parse(value);
            },
          );
  }

ButtonBar _buildButtonBar() {
    return ButtonBar(
            children: [
              RaisedButton(
                color: Theme.of(context).secondaryHeaderColor,
                child: Text('Cancel'),
                onPressed: () {              
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Save'),
                onPressed: onCreate,
              ),
            ],
          );
  }

  void onCreate() {
    if(!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.addProduct(_formData);
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
          _buildButtonBar(),
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
          _buildButtonBar(),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
      margin: EdgeInsets.all(10),
      child: Form(key: _formKey, child: ListView(
        children: _buildListViewChildren(alignVertical),
      ),),
    ),);
  }
}
