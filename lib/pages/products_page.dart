import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products_widget.dart';
import '../scoped-model/main.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  @override
  State<StatefulWidget> createState() {
    return _MyProductPageState();
  }

  ProductsPage(this.model);
}

class _MyProductPageState extends State<ProductsPage>{

  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }
  Drawer _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(bool showFavorite, Function toggleListMode) {
    return AppBar(title: Text('EasyList'), actions: [
      IconButton(
        icon: Icon(showFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          toggleListMode();
        },
      ),
      IconButton(
        icon: Icon(Icons.wb_sunny),
        onPressed: () {
          // setMode(mode);
        },
      )
    ]
        // : [
        //   IconButton(
        //     icon: Icon(Icons.wb_sunny),
        //     onPressed: () {
        //       // setMode(mode);
        //     },
        //   )
        // ],
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: _buildAppBar(model.showFavorite, model.toggleDisplayMode),
          body: ProductsWidget(),
        );
      },
    );
  }
}
