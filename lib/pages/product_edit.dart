import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';
import '../scoped-model/main.dart';
import '../widgets/helpers/ensure_visible.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductEditPage();
}

class _ProductEditPage extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'price': null,
    'description': null,
    'favorite': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  EnsureVisibleWhenFocused _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: Container(
        child: TextFormField(
          initialValue: product == null ? '' : product.title,
          focusNode: _titleFocusNode,
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
        ),
      ),
    );
  }

  EnsureVisibleWhenFocused _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          initialValue: product == null ? '' : product.description,
          focusNode: _descriptionFocusNode,
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
        ));
  }

  EnsureVisibleWhenFocused _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
          initialValue: product == null ? '' : product.price.toString(),
          focusNode: _priceFocusNode,
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
        ));
  }

  Widget _buildButtonBar(Product product, Function addProduct,
      Function updateProduct, Function setIndex) {
    return ButtonBar(
      children: [
        RaisedButton(
          color: Theme.of(context).secondaryHeaderColor,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('Save'),
          onPressed: () =>
              onSave(context, product, addProduct, updateProduct, setIndex),
        ),
      ],
    );
  }

  void onSave(BuildContext context, Product product, Function addProduct,
      Function updateProduct, Function setIndex) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (product == null) {
      addProduct(
        _formData['title'],
        _formData['price'],
        _formData['description'],
        _formData['image'],
      );
    } else {
      updateProduct(
        _formData['title'],
        _formData['price'],
        _formData['description'],
        product.image,
      );
    }
    Navigator.pushReplacementNamed(context, '/').then((_) {
      setIndex(null);
    });
  }

  List<Widget> _buildListViewChildren(
      BuildContext context,
      Product product,
      Function addProduct,
      Function updateProduct,
      Function setIndex,
      bool vertical) {
    List<Widget> children = <Widget>[
      Container(child: _buildTitleTextField(product)),
      SizedBox(
        height: 10,
      ),
      Container(
        child: _buildPriceTextField(product),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        child: _buildDescriptionTextField(product),
      ),
      _buildButtonBar(product, addProduct, updateProduct, setIndex),
    ];

    if (!vertical) {
      children = <Widget>[
        Row(
          children: [
            Flexible(
              child: Container(
                child: _buildTitleTextField(product),
              ),
              flex: 4,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                child: _buildPriceTextField(product),
              ),
              flex: 3,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: _buildDescriptionTextField(product),
        ),
        _buildButtonBar(product, addProduct, updateProduct, setIndex),
      ];
    }
    return children;
  }

  _buildPageContent(BuildContext context, Product product, Function addProduct,
      Function updateProduct, Function setIndex, bool alignVertical) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: _buildListViewChildren(context, product, addProduct,
                updateProduct, setIndex, alignVertical),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        final deviceWidth = MediaQuery.of(context).size.width;
        bool alignVertical = true;
        if (deviceWidth > 420) {
          alignVertical = false;
        }
        return model.selectedProductIndex == null
            ? _buildPageContent(
                context,
                model.selectedProduct,
                model.addProduct,
                model.updateProduct,
                model.setSelectedProductIndex,
                alignVertical)
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit product'),
                ),
                body: _buildPageContent(
                    context,
                    model.selectedProduct,
                    model.addProduct,
                    model.updateProduct,
                    model.setSelectedProductIndex,
                    alignVertical),
              );
      },
    );
  }
}
