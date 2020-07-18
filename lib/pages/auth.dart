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

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: AssetImage('assets/background.jpg'),
            );
  }

  TextField _buildEmailTextField() {
    return TextField(
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _emailValue = value;
                      });
                    },
                  );
  }

  TextField _buildPasswordTextField() {
    return TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _passwordValue = value;
                      });
                    },
                  );
  }

  Container _buildTermsAndConditionSwitch() {
    return Container(
                    color: Colors.white,
                    child: SwitchListTile(
                      value: _acceptTerms,
                      onChanged: (bool value) {
                        setState(() {
                          _acceptTerms = value;
                        });
                      },
                      title: Text('Accept terms '),
                    ),
                  );
  }

  RaisedButton _buildLoginRaisedButton() {
    return RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: !_acceptTerms
                        ? null : _onLogin,
                    child: Text('LOGIN'),
                  );
  }

  void _onLogin() {
    widget.signIn(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          margin: EdgeInsets.all(10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildTermsAndConditionSwitch(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildLoginRaisedButton(),
                ],
              ),
            ),
          )),
    );
  }
}
