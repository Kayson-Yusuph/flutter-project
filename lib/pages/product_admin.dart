import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';

class ProductAdminPage extends StatelessWidget {
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
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: _buildTabsBar(),
      title: Text('Manage products'),
      actions: [
        IconButton(
          icon: Icon(Icons.wb_sunny),
          onPressed: () {
            // setMode(mode);
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
        appBar: _buildAppBar(),
        body: TabBarView(
          children: tabChildren,
        ),
      ),
    );
  }
}
