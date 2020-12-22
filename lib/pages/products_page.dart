import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/shared/app-loader.dart';
import '../widgets/products/products_widget.dart';
import '../scoped-model/main.dart';
import '../widgets/ui_elements/logout.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  @override
  State<StatefulWidget> createState() {
    return _MyProductPageState();
  }

  ProductsPage(this.model);
}

class _MyProductPageState extends State<ProductsPage> {
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
            title: Text('Manage my products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          LogoutTile(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(MainModel _model) {
    return AppBar(title: Text('EasyList'), actions: [
      IconButton(
        icon: Icon(_model.showFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          _model.toggleDisplayMode();
        },
      ),
      IconButton(
        icon: Icon(!_model.displayMode? Icons.wb_sunny: Icons.brightness_2_rounded),
        onPressed: () {
          _model.setDisplayMode();
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
        return !model.loading
            ? Scaffold(
                drawer: _buildSideDrawer(context),
                appBar:
                    _buildAppBar(model),
                body: RefreshIndicator(
                  onRefresh: model.fetchProducts,
                  child: ProductsWidget(),
                ),
              )
            : AppLoader('Loading products!');
      },
    );
  }
}
