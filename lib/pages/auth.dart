import 'package:flutter/material.dart';

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
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text('LOGIN'),
        ),
      ),
    );
  }
}
