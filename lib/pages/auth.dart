import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-model/main.dart';
import '../pages/products_page.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  bool _showPassword = false;
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

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
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-Mail',
        errorStyle: TextStyle(
          color: Colors.black,
        ),
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        focusColor: Colors.black,
        filled: true,
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

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      cursorColor: Colors.black,
      controller: _passwordController,
      obscureText: !_showPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: _showPassword ? Colors.blue : Colors.grey,
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.black,
        ),
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        filled: true,
      ),
      validator: (String value) {
        dynamic rtn;
        if (value.isEmpty) {
          rtn = 'Password is required';
        }
        if (!value.isEmpty && value.length < 6) {
          rtn = 'Password must be 6+ characters long';
        }
        return rtn;
      },
    );
  }

  TextFormField _buildConfirmPasswordTextField() {
    return TextFormField(
      cursorColor: Colors.black,
      obscureText: !_showPassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorStyle: TextStyle(
          color: Colors.black,
        ),
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        filled: true,
      ),
      validator: (String value) {
        print('password is ${_passwordController.text} and confirm is $value');
        dynamic rtn;
        if (_passwordController.text != value) {
          rtn = 'Password mismatch';
        }
        return rtn;
      },
    );
  }

  Widget _buildTermsAndConditionSwitch() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          child: SwitchListTile(
            value: model.acceptedTerms,
            onChanged: model.loading
                ? null
                : (bool value) {
                    model.toggleTermAndConditions();
                  },
            title: Text(
              'Accept terms',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthRaisedButton() {
    final _buttonText = _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP';
    return ScopedModelDescendant(
      builder: (
        BuildContext context,
        Widget child,
        MainModel model,
      ) {
        return ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
          return SizedBox(
            width: double.infinity,
            child: model.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed:
                        (_authMode == AuthMode.Signup && !model.acceptedTerms)
                            ? null
                            : () => _onAuthenticate(model.authenticate),
                    child: Text(_buttonText),
                  ),
          );
        });
      },
    );
  }

  _buildSwitchAuthStateFlatButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      final _buttonText = _authMode == AuthMode.Login ? 'signup' : 'login';
      Widget rtnWidget = SizedBox();
      if (!model.loading) {
        rtnWidget = FlatButton(
          onPressed: () {
            setState(() {
              final condition = _authMode == AuthMode.Login;
              if (condition) {
                _authMode = AuthMode.Signup;
                return;
              }
              _authMode = AuthMode.Login;
            });
          },
          child: Text(
            'Switch to $_buttonText',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        );
      }
      return rtnWidget;
    });
  }

  void _onAuthenticate(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    final Map<String, dynamic> _response =
        await authenticate(_emailValue, _passwordController.text, _authMode);
    if (!_response['success']) {
      _showDialog(context, _response['message']);
    }
  }

  Form _buildFormWidget(double targetWidth) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: targetWidth,
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                _authMode == AuthMode.Login
                    ? Container()
                    : Column(
                        children: [
                          _buildConfirmPasswordTextField(),
                          SizedBox(height: 10),
                        ],
                      ),
                _authMode == AuthMode.Login
                    ? Container()
                    : Column(
                        children: [
                          _buildTermsAndConditionSwitch(),
                          SizedBox(height: 10),
                        ],
                      ),
                _buildAuthRaisedButton(),
                SizedBox(
                  height: 10,
                ),
                _buildSwitchAuthStateFlatButton(),
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

  void _showDialog(BuildContext context, String message) {
    final BuildContext theContext = context;
    showDialog(
      context: theContext,
      builder: (BuildContext context) => _buildAlertDialog(theContext, message),
      barrierDismissible: true,
    );
  }

  Dialog _buildAlertDialog(BuildContext context, String message) {
    final String _messageToDisplay =
        message != null ? message : 'Something went wrong!';
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 200,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 50,
                  ),
                  Text(_messageToDisplay),
                ],
              ),
              _buildCloseDialogButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCloseDialogButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Colors.white,
          onPressed: () {
            print('Closing Dialog now');
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double targetWidth = _deriveDeviceWidth(context);
    // final _pageTitle = _authMode == AuthMode.Signup ? 'Sign-up' : 'Login';
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.loginUser == null
            ? Scaffold(
                // appBar: AppBar(
                //   title: Text(_pageTitle),
                // ),
                body: Container(
                  decoration: BoxDecoration(
                    image: _buildBackgroundImage(),
                  ),
                  child: _buildFormWidget(targetWidth),
                ),
              )
            : ProductsPage(model);
      },
    );
  }
}
