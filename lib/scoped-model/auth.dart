import 'package:scoped_model/scoped_model.dart';

class AuthModel extends Model {
  bool _isLogin = false;

  login() {
    _isLogin = true;
    // Navigator.pushReplacementNamed(context, '/');
  }

  logout() {
    _isLogin = false;
  }
}
