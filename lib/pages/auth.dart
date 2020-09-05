import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../pages/products_page.dart';

class AuthPage extends StatefulWidget {
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
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'E-Mail',
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black),
        focusColor: Colors.black,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      validator: (String value) {
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
      cursorColor: Colors.black,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
      validator: (String value) {
        dynamic rtn;
        if (value.isEmpty) {
          rtn = 'Password is required';
        }
        if(!value.isEmpty && value.length < 6) {
          rtn = 'Password must be 6+ characters long';
        }
        return rtn;
      },
      onSaved: (String value) {
        _passwordValue = value;
      },
    );
  }

  Widget _buildTermsAndConditionSwitch() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: SwitchListTile(
            value: model.acceptedTerms,
            onChanged: (bool value) {
              model.toggleTermAndConditions();
            },
            title: Text(
              'Accept terms',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginRaisedButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () => _onLogin(model.login),
          child: Text('LOGIN'),
        );
      },
    );
  }

  void _onLogin(Function login) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    login(_emailValue, _passwordValue);
  }

  Form _buildFormWidget(double targetWidth) {
    return Form(
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
    );
  }

  _deriveDeviceWidth(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    double targetWidth = deviceWidth;
    if (deviceWidth > 550) {
      targetWidth = deviceWidth * 0.6;
    } else if (deviceWidth > 410) {
      targetWidth = deviceWidth * 0.8;
    }
    return targetWidth;
  }

// !isLogin ? AuthPage() : ProductsPage()

  @override
  Widget build(BuildContext context) {
    final double targetWidth = _deriveDeviceWidth(context);
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.loginUser == null
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Login'),
                ),
                body: Container(
                  decoration: BoxDecoration(
                    image: _buildBackgroundImage(),
                  ),
                  child: _buildFormWidget(targetWidth),
                ),
              )
            : ProductsPage();
      },
    );
  }
}
