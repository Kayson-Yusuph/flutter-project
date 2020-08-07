import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;

  List<Product> get products {
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
    // _selectedProductIndex = null;
  }

  void deleteProduct() {
    // delete product
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void updateProduct(Product product) {
    // update product
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
  }

  void setSelectedProductIndex(int index) {
    _selectedProductIndex = index;
  }
}
