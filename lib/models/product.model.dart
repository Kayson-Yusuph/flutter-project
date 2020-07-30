import 'package:flutter/material.dart';

class Product {
  String title;
  double price;
  String description;
  String image;
  bool favourite;

  Product({@required this.title, @required this.price, @required this.description, @required this.image, this.favourite = false});
}
