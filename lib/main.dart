import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/product_admin.dart';
import './pages/auth.dart';
import './pages/product.dart';
import './pages/page_not_found.dart';
import './scoped-model/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  IconData mode = Icons.wb_sunny;
  bool isLogin = false;
  final MainModel _model = MainModel();

  // final String name = 'flutter_project';
  // final FirebaseOptions firebaseOptions = const FirebaseOptions(
  //   appId: '1:807926849887:android:f9b46559cfeceff98196ea',
  //   apiKey: 'AIzaSyDArO1uM71y8qfQUC2PaAKiVZjfCLx9ERM',
  //   projectId: 'flutter-project-841e3',
  //   messagingSenderId: '807926849887',
  // );

  // Future<void> initializeSecondary() async {
  //   FirebaseApp app =
  //       await Firebase.initializeApp(name: name, options: firebaseOptions);

  //   assert(app != null);
  //   print('Initialized $app');
  // }

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
        return MaterialApp(
          theme: ThemeData(
            brightness: _model.displayMode ? Brightness.light : Brightness.dark,
            primarySwatch: Colors.lightGreen,
            accentColor: Colors.deepPurple,
          ),
          routes: {
            '/': (BuildContext context) => AuthPage(),
            // '/': (BuildContext context) => !true ? AuthPage() : ProductsPage(),
            '/admin': (BuildContext context) =>
                _model.loginUser == null ? AuthPage() : ProductAdminPage(_model)
          },
          onGenerateRoute: (RouteSettings settings) {
            List<String> route = settings.name.split('/');
            if (route[0] == null) {
              return null;
            }
            if (route[1] == 'products') {
              final String productId = route[2];
              _model.setSelectedProductId(productId);
              return MaterialPageRoute(
                builder: (BuildContext context) => _model.loginUser == null
                    ? AuthPage()
                    : ProductsDetailsPage(),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    _model.loginUser == null ? AuthPage() : PageNotFound());
          },
        );
      }),
    );
  }
}
