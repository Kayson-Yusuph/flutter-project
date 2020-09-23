import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/product_admin.dart';
import './pages/auth.dart';
import './pages/product.dart';
import './pages/page_not_found.dart';
import './scoped-model/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  IconData mode = Icons.wb_sunny;
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    final model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: !model.displayMode ? Brightness.light : Brightness.dark,
          primarySwatch: Colors.lightGreen,
          accentColor: Colors.deepPurple,
        ),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          // '/': (BuildContext context) => !true ? AuthPage() : ProductsPage(),
          '/admin': (BuildContext context) => ProductAdminPage(model)
        },
        onGenerateRoute: (RouteSettings settings) {
          List<String> route = settings.name.split('/');
          if (route[0] == null) {
            return null;
          }
          if (route[1] == 'products') {
            final String productId = route[2];
            model.setSelectedProductId(productId);
            return MaterialPageRoute(
              builder: (BuildContext context) => ProductsDetailsPage(),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => PageNotFound());
        },
      ),
    );
  }
}
