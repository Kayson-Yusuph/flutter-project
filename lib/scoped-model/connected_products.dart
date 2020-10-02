import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.model.dart';
import '../models/user.model.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _user;
  String _selProductId;
  bool _isLoading = false;
  final String _dbUrl = 'https://flutter-project-841e3.firebaseio.com/products';

  register(String email, String password) async {
   try{
      final Map<String, dynamic> _authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };
    final http.Response response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDArO1uM71y8qfQUC2PaAKiVZjfCLx9ERM', body: json.encode(_authData));
    if(response.body != null) {
      final Map<String, dynamic> _userData = json.decode(response.body);
    _user = User(id: _userData['localId'], email: email, token: _userData['idToken']);
    notifyListeners();
    return;
    }
    notifyListeners();
   } catch (e) {
     print('Something went wrong, try again after sometime');
     notifyListeners();
   }
  }

  login(String email, String password) async{
    try{
      final Map<String, dynamic> _authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };
    final http.Response response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDArO1uM71y8qfQUC2PaAKiVZjfCLx9ERM', body: json.encode(_authData));
    if(response.body != null) {
    final Map<String, dynamic> _userData = json.decode(response.body);
    _user = User(id: _userData['localId'], email: email, token: _userData['idToken']);
    notifyListeners();
    }
    notifyListeners();
    } catch (e) {
      print('Some thing went wrong, try again after sometime');
      notifyListeners();
    }
  }

  logout() {
    _user = null;
    notifyListeners();
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
    double price,
    String description,
  ) async {
    final Map<String, dynamic> productData = {
      'title': title,
      'price': price,
      'description': description,
      'imageUrl':
          'https://vaya.in/recipes/wp-content/uploads/2018/02/Milk-Chocolate-1.jpg',
      'userEmail': _user.email,
      'userId': _user.id,
    };
    _isLoading = true;
    notifyListeners();
    try{
    final http.Response response = await http
        .post('$_dbUrl.json', body: json.encode(productData));
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
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get('$_dbUrl.json').then((http.Response response) {
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
      _productData.forEach((String productId, dynamic product) {
        final Product _product = Product(
          id: productId,
          title: product['title'],
          price: product['price'],
          description: product['description'],
          image: product['imageUrl'],
          favorite: product['favorite'] != null ? product['favorite'] : false,
          userId: product['userId'],
          userEmail: product['userEmail'],
        );

        _fetchedProductList.add(_product);
      });
      _products = _fetchedProductList;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    // delete product
    final _deletedProductIndex = selectedProductIndex;
    final _deletedProductId = selectedProduct.id;
    // _selProductId = null;
    _isLoading = true;
    notifyListeners();
    return http.delete('$_dbUrl/$_deletedProductId.json').then((response) {
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
    double price,
    String description,
  ) {
    // update product
    final Map<String, dynamic> productData = {
      'id': selectedProduct.id,
      'title': title,
      'price': price,
      'description': description,
      'imageUrl': selectedProduct.image,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
      'favorite': selectedProduct.favorite,
    };
    _isLoading = true;
    notifyListeners();
    return http
        .put(
      '$_dbUrl/${selectedProduct.id}.json',
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
        favorite: resData['favorite'],
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

  void toggleProductFavoriteStatus() {
    final bool oldFavorite = _products[selectedProductIndex].favorite;
    final Product oldProduct = _products[selectedProductIndex];
    _products[selectedProductIndex] = Product(
      image: oldProduct.image,
      description: oldProduct.description,
      id: oldProduct.id,
      title: oldProduct.title,
      favorite: !oldFavorite,
      price: oldProduct.price,
      userId: oldProduct.userId,
      userEmail: oldProduct.userEmail,
    );
    _selProductId = null;
    notifyListeners();
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
