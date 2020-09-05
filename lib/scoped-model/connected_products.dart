import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';
import '../models/user.model.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _user;
  int _selProductIndex;

  void addProduct(
    String title,
    double price,
    String description,
    String imageUrl,
  ) {
    final Product product = Product(
      title: title,
      price: price,
      description: description,
      image: imageUrl,
      userEmail: _user.email,
      userId: _user.id,
    );
    // add product
    _products.add(product);
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
  bool _showFavourite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayProducts {
    final List<Product> _theProducts = [];
    if (_showFavourite) {
      _products.forEach((Product product) {
        if (product.favourite) {
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
      title: title,
      price: price,
      description: description,
      image: imageUrl,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      favourite: selectedProduct.favourite,
    );
    _products[_selProductIndex] = product;
  }

  void setSelectedProductIndex(int index) {
    if (index > -1) {
      _selProductIndex = index;
    } else {
      _selProductIndex = null;
    }
  }

  void toggleProductFavourityStatus() {
    final bool oldFavourity = _products[_selProductIndex].favourite;
    final Product oldProduct = _products[_selProductIndex];
    _products[_selProductIndex] = Product(
      image: oldProduct.image,
      description: oldProduct.description,
      title: oldProduct.title,
      favourite: !oldFavourity,
      price: oldProduct.price,
      userId: oldProduct.userId,
      userEmail: oldProduct.userEmail,
    );
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavourite = !_showFavourite;
    notifyListeners();
  }

  bool get showFavourite {
    return _showFavourite;
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

class AppSettingModel extends Model{
  bool _nightMode = true;

  void setDisplayMode() {
    _nightMode = !_nightMode;
    notifyListeners();
  }

  bool get displayMode {
    return _nightMode;
  }
}