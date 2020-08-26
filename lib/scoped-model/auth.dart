import 'package:scoped_model/scoped_model.dart';
import '../models/user.model.dart';

class AuthModel extends Model {
  User _user;
  bool _termsAndConditions = false;

  login(String email, String password) {
    _user = User(id: 'slkfjsldkfs', email: email, password: password);
    notifyListeners();
  }

  User get loginUser {
    return _user;
  }

  toggleTermAndConditions() {
    _termsAndConditions = !_termsAndConditions;
    notifyListeners();
  }

  bool get acceptedTerms {
    return _termsAndConditions;
  }

  logout() {
    _user = null;
    notifyListeners();
  }
}
