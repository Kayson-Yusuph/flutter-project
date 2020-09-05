import 'package:flutter/cupertino.dart';

import '../models/product.model.dart';
import './connected_products.dart';

class ProductsModel extends ConnectedProducts {
  bool _showFavourite = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayProducts {
    final List<Product> _theProducts = [];
    if (_showFavourite) {
      products.forEach((Product product) {
        if (product.favourite) {
          _theProducts.add(product);
        }
      });
      return List.from(_theProducts);
    }
    return List.from(products);
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  void deleteProduct() {
    // delete product
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
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
    products[selProductIndex] = product;
    selProductIndex = null;
  }

  void setSelectedProductIndex(int index) {
    if (index > -1) {
      selProductIndex = index;
    } else {
      selProductIndex = null;
    }
  }

  void toggleProductFavourityStatus() {
    final bool oldFavourity = products[selProductIndex].favourite;
    final Product oldProduct = products[selProductIndex];
    products[selProductIndex] = Product(
      image: oldProduct.image,
      description: oldProduct.description,
      title: oldProduct.title,
      favourite: !oldFavourity,
      price: oldProduct.price,
      userId: oldProduct.userId,
      userEmail: oldProduct.userEmail,
    );
    selProductIndex = null;
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
