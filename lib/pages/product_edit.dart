import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';
import '../scoped-model/products.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Product product;
  final int productIndex;
  final Function updateProduct;

  ProductEditPage(
      {this.product, this.productIndex, this.addProduct, this.updateProduct});
  @override
  State<StatefulWidget> createState() => _ProductEditPage();
}

class _ProductEditPage extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'price': null,
    'description': null,
    'image': 'assets/food.jpg',
    'favourite': false
  };

  Product _product;
  TextEditingController _title;
  TextEditingController _price;
  TextEditingController _description;
  // TextEditingController _image;
  // TextEditingController _favourite;

  @override
  initState() {
    if (widget.product != null) {
      _product = widget.product;
      _title = TextEditingController(text: _product.title);
      _price = TextEditingController(text: _product.price.toString());
      _description = TextEditingController(text: _product.description);
    }
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextFormField _buildTitleTextField() {
    return TextFormField(
      controller: _title,
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      // autovalidate: true,
      validator: (String value) {
        dynamic rtn;
        if (value.isEmpty || value.length < 4) {
          rtn = 'Title is required and must be 4+ characters';
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
      controller: _description,
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (String value) {
        dynamic rtn;
        if (value.isEmpty || value.length < 10) {
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
      controller: _price,
      decoration:
          InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (String value) {
        dynamic rtn;
        if (value.isEmpty || double.tryParse(value) == null) {
          rtn = 'Price is required and must be a number';
        }
        return rtn;
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildButtonBar() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ProductsModel model) {
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
              onPressed: () =>
                  onSave(context, model.addProduct, model.updateProduct),
            ),
          ],
        );
      },
    );
  }

  void onSave(
      BuildContext context, Function addProduct, Function updateProduct) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_product == null) {
      print('Create');
      final Product newProduct = new Product(
          title: _formData['title'],
          price: _formData['price'],
          favourite: _formData['favourite'],
          image: _formData['image'],
          description: _formData['description']);
      addProduct(newProduct);
    } else {
      print('Update');
      final Product newProduct = new Product(
          title: _formData['title'],
          price: _formData['price'],
          description: _formData['description'],
          image: _product.image,
          favourite: _product.favourite);
      updateProduct(widget.productIndex, newProduct);
    }
    Navigator.pushReplacementNamed(context, '/');
  }

  List<Widget> _buildListViewChildren(BuildContext context, bool vertical) {
    List<Widget> children = <Widget>[
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

    if (!vertical) {
      children = <Widget>[
        Row(
          children: [
            Flexible(
              child: _buildTitleTextField(),
              flex: 4,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: _buildPriceTextField(),
              flex: 3,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _buildDescriptionTextField(),
        _buildButtonBar(),
      ];
    }
    return children;
  }

  _buildPageContent(BuildContext context, bool alignVertical) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: _buildListViewChildren(context, alignVertical),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    bool alignVertical = true;
    if (deviceWidth > 420) {
      alignVertical = false;
    }
    return _product == null
        ? _buildPageContent(context, alignVertical)
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit product'),
            ),
            body: _buildPageContent(context, alignVertical),
          );
  }
}
