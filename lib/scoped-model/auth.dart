import 'package:scoped_model/scoped_model.dart';
import '../models/user.model.dart';

class AuthModel extends Model {
  User _user;

  login(String email, String password) {
    _user = User(id: 'slkfjsldkfs', email: email, password: password);
    notifyListeners();
  }

  User get loginUser {
    return _user;
  }

  logout() {
    _user = null;
    notifyListeners();
  }
}
