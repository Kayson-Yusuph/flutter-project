import 'package:flutter/material.dart';

import './pages/product_admin.dart';
import './pages/products_page.dart';
import './pages/auth.dart';
import './pages/product.dart';
import './pages/page_not_found.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // final String _startingProduct = 'Food Paradise';
  bool nightMode = false;
  IconData mode = Icons.wb_sunny;
  List<Map<String, dynamic>> products = [];
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: !nightMode ? Brightness.light : Brightness.dark,
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.deepPurple),
      // home: AuthPage(mode: nightMode, setMode: setMode),
      routes: {
        '/': (BuildContext context) => !isLogin
            ? AuthPage(
                mode: nightMode,
                setMode: setMode,
                signIn: signIn,
              )
            : ProductsPage(
              mode: nightMode,
              setMode: setMode,
              products: products,
            ),
        '/admin': (BuildContext context) => ProductAdminPage(
                products: products,
                mode: nightMode,
                setMode: setMode,
                addProduct: _addProduct,
                deleteProduct: deleteProduct,
              )
      },
      onGenerateRoute: (RouteSettings settings) {
        List<String> route = settings.name.split('/');
        if (route[0] == null) {
          return null;
        }
        if (route[1] == 'products') {
          final int index = int.parse(route[2]);
          return MaterialPageRoute(
            builder: (BuildContext context) => ProductsDetailsPage(
              product: products[index],
            ),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => PageNotFound());
      },
    );
  }

  void _addProduct(Map<String, dynamic> product) {
    setState(() => products.add(product));
  }

  void deleteProduct(int index) {
    setState(() => products.removeAt(index));
  }

  setMode(mode) {
    setState(() => nightMode = !nightMode);
  }

  signIn(BuildContext context) {
    setState(() => isLogin = true);
    Navigator.pushReplacementNamed(context, '/');
  }
}
