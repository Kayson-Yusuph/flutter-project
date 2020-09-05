import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../models/product.model.dart';
import '../models/user.model.dart';

class ConnectedProducts extends Model {
  List<Product> products = [];
  User user;
  int selProductIndex;

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
      userEmail: user.email,
      userId: user.id,
    );
    // add product
    products.add(product);
    selProductIndex = null;
  }

  login(String email, String password) {
    user = User(id: 'slkfjsldkfs', email: email, password: password);
    notifyListeners();
  }

  logout() {
    user = null;
    notifyListeners();
  }
}
