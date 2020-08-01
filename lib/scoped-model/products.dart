import 'package:scoped_model/scoped_model.dart';

import '../models/product.model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  void addProduct(Product product) {
    // add product
  }

  void deleteProduct(int index) {
    // delete product
  }

  void updateProduct(int index, Product product) {
    // update product
  }
}
