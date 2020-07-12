import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final bool mode;
  final Function setMode;
  final Function signIn;
  AuthPage({this.mode, this.setMode, this.signIn});
  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'E-Mail',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  _emailValue = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  _passwordValue = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            SwitchListTile(
              value: _acceptTerms,
              onChanged: (bool value) {
                setState(() {
                  _acceptTerms = value;
                });
              },
              title: Text('Accept terms '),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: !_acceptTerms? null: () {
                widget.signIn(context);
              },
              child: Text('LOGIN'),
            )
          ],
        ),
      ),
    );
  }
}
