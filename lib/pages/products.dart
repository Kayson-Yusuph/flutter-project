import 'package:flutter/material.dart';

import '../product_manager.dart';

class ProductsPage extends StatefulWidget {
  final Function setMode;
  final bool mode;

  ProductsPage({this.setMode, this.mode});
  @override
  State<StatefulWidget> createState() => _ProductsPage();
}

class _ProductsPage extends State<ProductsPage> {
  bool _nigthMode;
  Function _changeMode;
  @override
  void initState() {
    _nigthMode = widget.mode;
    _changeMode = widget.setMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: () {
              _changeMode(_nigthMode);
            },
          )
        ],
      ),
      body: ProductManager(),
    );
  }
}
