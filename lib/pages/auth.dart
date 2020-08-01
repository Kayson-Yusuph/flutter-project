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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/background.jpg'),
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-Mail',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
      ),
      validator: (String value) {
        // dynamic rtn;
        // if(value.isEmpty) {
        //   rtn = 'Email is required';
        // }
        // return rtn;
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Enter Valid Email';
        else
          return null;
      },
      onSaved: (String value) {
        _emailValue = value;
      },
    );
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(),
      ),
      validator: (String value) {
        dynamic rtn;
        if (value.isEmpty) {
          rtn = 'Password is required';
        }
        return rtn;
      },
      onSaved: (String value) {
        _passwordValue = value;
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
      onPressed: !_acceptTerms ? null : _onLogin,
      child: Text('LOGIN'),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.signIn(context);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double targetWidth = deviceWidth;
    if (deviceWidth > 550) {
      targetWidth = deviceWidth * 0.6;
    } else if (deviceWidth > 410) {
      targetWidth = deviceWidth * 0.8;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
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
            ),
          ),
        ),
      ),
    );
  }
}
