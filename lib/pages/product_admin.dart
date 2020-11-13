import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../scoped-model/main.dart';
import '../widgets/ui_elements/logout.dart';

class ProductAdminPage extends StatelessWidget {
  final MainModel model;
  ProductAdminPage(this.model);
  TabBar _buildTabsBar() {
    return TabBar(
      tabs: [
        Tab(
          text: 'Create Product',
          icon: Icon(Icons.create),
        ),
        Tab(
          text: 'Product List',
          icon: Icon(Icons.list),
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          LogoutTile(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      bottom: _buildTabsBar(),
      title: Text('Manage products'),
      actions: [
        IconButton(
          icon: !model.displayMode? Icon(Icons.wb_sunny): Icon(Icons.brightness_2_rounded),
          onPressed: () {
            model.setDisplayMode();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabChildren = [ProductEditPage(), ProductListPage()];
    return DefaultTabController(
      length: tabChildren.length,
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: tabChildren,
        ),
      ),
    );
  }
}
