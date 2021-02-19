import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/form_inputs/image.dart';
import 'package:flutter_project/widgets/form_inputs/static_map.dart';
import 'package:flutter_project/widgets/shared/app-loader.dart';
import 'package:location/location.dart';

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
      return model.loading && _savingData
          ? AppSimpleLoader()
          : SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Save'),
                onPressed: () => onSave(
                  context,
                  model.addProduct,
                  model.updateProduct,
                  model.setSelectedProductId,
                ),
              )
              //   ],
              );
    });
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
        }).then((_) {
      setState(() => _savingData = false);
    });
  }

  void onSave(BuildContext context, Function addProduct, Function updateProduct,
      Function setProductId) {
    setState(() => _savingData = true);
    if (!_formKey.currentState.validate()) {
      setState(() => _savingData = false);
      return;
    }
    _formKey.currentState.save();
    if (_product == null) {
      addProduct(
        _formData['title'],
        _formData['price'],
        _formData['description'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/');
          setProductId(null);
        } else {
          _showErrorDialog(context);
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['price'],
        _formData['description'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/');
          setProductId(null);
        } else {
          _showErrorDialog(context);
        }
      });
    }
  }

  List<Widget> _buildListViewChildren(BuildContext context, bool vertical) {
    final Container _locationContainer = Container(
      child: GestureDetector(
        child: Icon(Icons.map),
        onTap: () async {
          Location location = new Location();

          bool _serviceEnabled;
          PermissionStatus _permissionGranted;
          LocationData _locationData;

          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              return;
            }
          }

          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted != PermissionStatus.granted) {
              return;
            }
          }

          _locationData = await location.getLocation();
          await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            final Map<String, String> location = {
              'lat': _locationData.latitude.toString(),
              'lng': _locationData.longitude.toString()
            };
            return StaticMap(
              width: 500,
              height: 400,
              location: location,
              zoom: 4,
            );
          }));
        },
      ),
    );
    List<Widget> children = <Widget>[
      Container(
        child: _buildTitleTextField(),
      ),
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
      // TODO: Enable google map api to use these code
      // SizedBox(
      //   height: 10,
      // ),
      // _locationContainer,
      Divider(
        height: 10,
      ),
      ImageInput(),
      SizedBox(
        height: 20,
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
        SizedBox(
          height: 10,
        ),
        ImageInput(),
        SizedBox(
          height: 10,
        ),
        // TODO: Enable google map api to use these code
        // _locationContainer,
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
        return model.selectedProductId == null
            ? Scaffold(
                body: _buildPageContent(context, alignVertical),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit product'),
                ),
                body: _buildPageContent(context, alignVertical),
              );
      },
    );
  }
}
