import '../models/user.model.dart';
import './connected_products.dart';

class AuthModel extends ConnectedProducts {
  bool _termsAndConditions = false;

  User get loginUser {
    print(user);
    return user;
  }

  toggleTermAndConditions() {
    _termsAndConditions = !_termsAndConditions;
    notifyListeners();
  }

  bool get acceptedTerms {
    return _termsAndConditions;
  }
}
