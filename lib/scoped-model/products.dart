import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';

class ProductsModel extends Model{
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavourite = false;

  List<Product> get products {
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
    if (_selectedProductIndex == null) {
      return null;
    }
    return _products[_selectedProductIndex];
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  void addProduct(Product product) {
    // add product
    _products.add(product);
    _selectedProductIndex = null;
  }

  void deleteProduct() {
    // delete product
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    // update product
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
  }

  void setSelectedProductIndex(int index) {
    if (index > -1) {
      _selectedProductIndex = index;
    } else {
      _selectedProductIndex = null;
    }
  }

  void toggleProductFavourityStatus() {
    final bool oldFavourity = _products[_selectedProductIndex].favourite;
    final Product oldProduct = _products[_selectedProductIndex];
    _products[_selectedProductIndex] = Product(
      image: oldProduct.image,
      description: oldProduct.description,
      title: oldProduct.title,
      favourite: !oldFavourity,
      price: oldProduct.price,
    );
    _selectedProductIndex = null;
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
