import 'package:flutter/material.dart';

import './products.dart';

class ManageProductsPange extends StatelessWidget {
  final bool mode;
  final Function setMode;

  ManageProductsPange({this.mode, this.setMode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Product list'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductsPage(
                      mode: mode,
                      setMode: setMode,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Manage products'),
        actions: [
          IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: () {
              setMode(mode);
            },
          )
        ],
      ),
      body: Center(
        child: Text('No product to manage'),
      ),
    );
  }
}
