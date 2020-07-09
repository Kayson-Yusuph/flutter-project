import 'package:flutter/material.dart';
import 'package:flutter_project/pages/products.dart';

class AuthPage extends StatelessWidget {
  final bool mode;
  final Function setMode;
  AuthPage({this.mode, this.setMode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ProductsPage(mode: mode, setMode: setMode),
              ),
            );
          },
          child: Text('LOGIN'),
        ),
      ),
    );
  }
}
