import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';
import '../models/user.model.dart';
import 'package:http/http.dart' as http;

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _user;
  int _selProductIndex;
  final String _dbUrl =
      'https://flutter-project-841e3.firebaseio.com/products.json';

  void addProduct(
    String title,
    double price,
    String description,
    String imageUrl,
  ) {
    final Map<String, dynamic> productData = {
      'title': title,
      'price': price,
      'description': description,
      'imageUrl':
          'https://vaya.in/recipes/wp-content/uploads/2018/02/Milk-Chocolate-1.jpg',
      'userEmail': _user.email,
      'userId': _user.id,
    };
    http
        .post(_dbUrl, body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> productData = json.decode(response.body);
      if (productData == null) {
        notifyListeners();
        return;
      }
      final Product product = Product(
        id: productData['name'],
        title: title,
        price: price,
        description: description,
        image: imageUrl,
        userEmail: _user.email,
        userId: _user.id,
      );
      // add product
      _products.add(product);
      notifyListeners();
    });
  }

  void fetchProducts() {
    http.get(_dbUrl).then((http.Response response) {
      final Map<String, dynamic> _productData = json.decode(response.body);
      final List<Product> _fetchedProductList = [];
      if (_productData == null) {
        notifyListeners();
        return;
      }
      _productData.forEach((String productId, dynamic product) {
        final Product _product = Product(
          id: productId,
          title: product['title'],
          price: product['price'],
          description: product['description'],
          image: product['imageUrl'],
          favorite:
              product['favorite'] != null ? product['favorite'] : false,
          userId: product['userId'],
          userEmail: product['userEmail'],
        );

        _fetchedProductList.add(_product);
      });
      _products = _fetchedProductList;
      notifyListeners();
    });
  }

  login(String email, String password) {
    _user = User(id: 'slkfjsldkfs', email: email, password: password);
    notifyListeners();
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
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  void deleteProduct() {
    // delete product
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void updateProduct(
    String title,
    double price,
    String description,
    String imageUrl,
  ) {
    // update product
    final Product product = Product(
      id: selectedProduct.id,
      title: title,
      price: price,
      description: description,
      image: imageUrl,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      favorite: selectedProduct.favorite,
    );
    _products[_selProductIndex] = product;
  }

  void setSelectedProductIndex(int index) {
    _selProductIndex = index;
  }

  void toggleProductFavoriteStatus() {
    final bool oldFavorite = _products[_selProductIndex].favorite;
    final Product oldProduct = _products[_selProductIndex];
    _products[_selProductIndex] = Product(
      image: oldProduct.image,
      description: oldProduct.description,
      id: oldProduct.id,
      title: oldProduct.title,
      favorite: !oldFavorite,
      price: oldProduct.price,
      userId: oldProduct.userId,
      userEmail: oldProduct.userEmail,
    );
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
