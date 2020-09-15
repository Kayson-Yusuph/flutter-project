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
  Product _product;
  bool _savingData = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  EnsureVisibleWhenFocused _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: Container(
        child: TextFormField(
          enabled: !_savingData,
          initialValue: _product == null ? '' : _product.title,
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

  EnsureVisibleWhenFocused _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _descriptionFocusNode,
        child: TextFormField(
          enabled: !_savingData,
          initialValue: _product == null ? '' : _product.description,
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

  EnsureVisibleWhenFocused _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: _priceFocusNode,
        child: TextFormField(
          enabled: !_savingData,
          initialValue: _product == null ? '' : _product.price.toString(),
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

  Widget _buildButtonBar() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : ButtonBar(
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
                  onPressed: () => onSave(
                    context,
                    model.addProduct,
                    model.updateProduct,
                    model.setSelectedProductIndex,
                  ),
                ),
              ],
            );
    });
  }

  void onSave(BuildContext context, Function addProduct,
      Function updateProduct, Function setIndex) {
        setState(() => _savingData = true);
    if (!_formKey.currentState.validate()) {
        setState(() => _savingData = false);
      return;
    }
        setState(() => _savingData = false);
    _formKey.currentState.save();
    if (_product == null) {
      addProduct(
        _formData['title'],
        _formData['price'],
        _formData['description'],
      )
          .then((_) => Navigator.pushReplacementNamed(context, '/'))
          .then((_) => setIndex(null));
    } else {
      updateProduct(
        _formData['title'],
        _formData['price'],
        _formData['description'],
      )
          .then((_) => Navigator.pushReplacementNamed(context, '/'))
          .then((_) => setIndex(null));
    }
    // Navigator.pushReplacementNamed(context, '/').then((_) {
    // });
  }

  List<Widget> _buildListViewChildren(
      BuildContext context,
      bool vertical) {
    List<Widget> children = <Widget>[
      Container(child: _buildTitleTextField(),),
      SizedBox(
        height: 10,
      ),
      Container(
        child: _buildPriceTextField(),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        child: _buildDescriptionTextField(),
      ),
      SizedBox(
        height: 10,
      ),
      _buildButtonBar(),
    ];

    if (!vertical) {
      children = <Widget>[
        Row(
          children: [
            Flexible(
              child: Container(
                child: _buildTitleTextField(),
              ),
              flex: 4,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                child: _buildPriceTextField(),
              ),
              flex: 3,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: _buildDescriptionTextField(),
        ),
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
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        _product = model.selectedProduct;
        final deviceWidth = MediaQuery.of(context).size.width;
        bool alignVertical = true;
        if (deviceWidth > 420) {
          alignVertical = false;
        }
        return model.selectedProductIndex == null
            ? _buildPageContent(
                context,
                alignVertical)
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit product'),
                ),
                body: _buildPageContent(
                    context,
                    alignVertical),
              );
      },
    );
  }
}
