import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.model.dart';
import '../models/user.model.dart';
import '../models/auth.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _user;
  String _selProductId;
  Timer _authTimer;
  bool _isLoading = false;
  final String _dbUrl = 'https://flutter-project-841e3.firebaseio.com/products';
  final String apiKey = 'AIzaSyDArO1uM71y8qfQUC2PaAKiVZjfCLx9ERM';

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> _returnData = {
      'success': true,
      'message': 'Login succeded'
    };
    final Map<String, dynamic> _authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };
    _isLoading = true;
    notifyListeners();
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey',
          body: json.encode(_authData));
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey',
        body: json.encode(_authData),
      );
    }
    if (response.body != null) {
      final Map<String, dynamic> _userData = json.decode(response.body);
      if (_userData['error'] != null) {
        _returnData['success'] = false;
        final Map<String, dynamic> _error = _userData['error'];
        if (_error['message'] == 'EMAIL_NOT_FOUND') {
          _returnData['message'] = 'Email does not exist';
        } else if (_error['message'] == 'INVALID_PASSWORD') {
          _returnData['message'] = 'Invalid password';
        } else if (_error['message'].contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          _returnData['message'] =
              'Account is temporarily disabled due to too many attemps, reset your password to restore it or try again after sometime.';
        } else if (_error['message'] == 'EMAIL_EXISTS') {
          _returnData['message'] = 'Email already exists';
        } else {
          _returnData['message'] =
              'Some thing went wrong, try again after sometime';
        }
      } else {
        final String _token = _userData['idToken'];
        final String _id = _userData['localId'];
        final int _time = int.parse(_userData['expiresIn']);
        final DateTime now = DateTime.now();
        final String _expireTime =
            now.add(Duration(seconds: _time)).toIso8601String();
        setAuthTimer(_time);
        _user = User(
          id: _id,
          email: email,
          token: _token,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth-id', _id);
        await prefs.setString('auth-email', email);
        await prefs.setString('auth-token', _token);
        await prefs.setString('auth-expire-time', _expireTime);
      }
    } else {
      _returnData['success'] = false;
      _returnData['message'] =
          'Some thing went wrong, try again after sometime';
    }
    _isLoading = false;
    notifyListeners();
    return _returnData;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth-id');
    await prefs.remove('auth-email');
    await prefs.remove('auth-token');
    _user = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();
  }

  void setAuthTimer(int expireTime) {
    _authTimer = Timer(Duration(seconds: expireTime), logout);
  }

  void autoAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('auth-token');
    if (_token != null) {
      final _time = prefs.getString('auth-expire-time');
      final DateTime now = DateTime.now();
      final expireDate = DateTime.parse(_time);
      if (now.isBefore(expireDate)) {
        notifyListeners();
        return;
      }
      final int tokenLifeSpan = expireDate.difference(now).inSeconds;
      final _email = prefs.getString('auth-email');
      final _id = prefs.getString('auth-id');
      _user = User(
        id: _id,
        email: _email,
        token: _token,
      );
      setAuthTimer(tokenLifeSpan);
      notifyListeners();
    }
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayProducts {
    final List<Product> _theProducts = [];
    if (_showFavorite) {
      _products.forEach((Product product) {
        if (product.favorite) {
          _theProducts.add(product);
        }
      });
      return List.from(_theProducts);
    }
    return List.from(_products);
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((product) => product.id == selectedProductId);
  }

  int get selectedProductIndex {
    return _products.indexWhere((product) => product.id == selectedProductId);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Future<bool> addProduct(
    String title,
    String price,
    String description,
    String imageUrl,
  ) async {
    final Map<String, dynamic> productData = {
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'userEmail': _user.email,
      'userId': _user.id,
    };
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response response = await http.post(
          '$_dbUrl.json?auth=${_user.token}',
          body: json.encode(productData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> resData = json.decode(response.body);
      final Product product = Product(
        id: resData['name'],
        title: title,
        price: price,
        description: description,
        image: productData['imageUrl'],
        userEmail: _user.email,
        userId: _user.id,
      );
      // add product
      _products.add(product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(json.decode(e));
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchProducts({onlyForUser: false}) async{
    _isLoading = true;
    try{
    notifyListeners();
    http.Response response = await  http
        .get('$_dbUrl.json?auth=${_user.token}');
        // .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> _productData = json.decode(response.body);
      final List<Product> _fetchedProductList = [];
      if (_productData == null) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      print('Length: ${_productData.length}');
      _productData.forEach((String productId, dynamic product) {
        final Product _product = Product(
          id: productId,
          title: product['title'],
          price: product['price'].toString(),
          description: product['description'],
          image: product['imageUrl'],
          favorite: product['wishLessUsers'] == null
              ? false
              : (product['wishLessUsers'] as Map<String, dynamic>)
                  .containsKey(_user.id),
          userId: product['userId'],
          userEmail: product['userEmail'],
        );

        _fetchedProductList.add(_product);
      });
      print('Fetched: ${_fetchedProductList.length}');
      _products = onlyForUser? _fetchedProductList.where((Product p) => p.userId == _user.id).toList(): _fetchedProductList;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // }).catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> deleteProduct() {
    // delete product
    final _deletedProductIndex = selectedProductIndex;
    final _deletedProductId = selectedProduct.id;
    // _selProductId = null;
    _isLoading = true;
    notifyListeners();
    return http
        .delete('$_dbUrl/$_deletedProductId.json?auth=${_user.token}')
        .then((response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final res = json.decode(response.body);
      if (res == null) {
        _products.removeAt(_deletedProductIndex);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateProduct(
    String title,
    String price,
    String description,
    String imageUrl,
  ) {
    // update product
    final Map<String, dynamic> productData = {
      'id': selectedProduct.id,
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
    };
    _isLoading = true;
    notifyListeners();
    return http
        .put(
      '$_dbUrl/${selectedProduct.id}.json?auth=${_user.token}',
      body: json.encode(productData),
    )
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      Map<String, dynamic> resData = json.decode(response.body);
      final Product product = Product(
        id: selectedProduct.id,
        title: resData['title'],
        price: resData['price'],
        description: description,
        image: resData['imageUrl'],
        userEmail: resData['userEmail'],
        userId: resData['userId'],
        favorite: resData['wishLessUsers'] == null
            ? false
            : (resData['wishLessUsers'] as Map<String, dynamic>)
                .containsKey(_user.id),
      );
      _products[selectedProductIndex] = product;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void setSelectedProductId(String id) {
    _selProductId = id;
  }

  void toggleProductFavoriteStatus() async {
    final bool _oldFavorite = _products[selectedProductIndex].favorite;
    final bool _newFavorite = !_oldFavorite;
    final Product oldProduct = _products[selectedProductIndex];
    _products[selectedProductIndex] = Product(
      image: oldProduct.image,
      description: oldProduct.description,
      id: oldProduct.id,
      title: oldProduct.title,
      favorite: _newFavorite,
      price: oldProduct.price,
      userId: oldProduct.userId,
      userEmail: oldProduct.userEmail,
    );
    notifyListeners();
    http.Response response;
    final String _productWishlessUsersRefLink =
        'https://flutter-project-841e3.firebaseio.com/products/${oldProduct.id}/wishLessUsers/${_user.id}.json?auth=${_user.token}';
    if (_newFavorite) {
      response = await http.put(
        _productWishlessUsersRefLink,
        body: json.encode(true),
      );
    } else {
      response = await http.delete(_productWishlessUsersRefLink);
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      _products[selectedProductIndex] = Product(
        image: oldProduct.image,
        description: oldProduct.description,
        id: oldProduct.id,
        title: oldProduct.title,
        favorite: !_newFavorite,
        price: oldProduct.price,
        userId: oldProduct.userId,
        userEmail: oldProduct.userEmail,
      );
      notifyListeners();
    }
    _selProductId = null;
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }

  bool get showFavorite {
    return _showFavorite;
  }
}

class AuthModel extends ConnectedProductsModel {
  bool _termsAndConditions = false;

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
}

class AppSettingModel extends Model {
  bool _nightMode = true;

  void setDisplayMode() {
    _nightMode = !_nightMode;
    notifyListeners();
  }

  bool get displayMode {
    return _nightMode;
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get loading {
    return _isLoading;
  }
}
