import 'package:flutter/material.dart';

class Product {
  final String title;
  final double price;
  final String description;
  final String image;
  final bool favourite;

  Product({@required this.title, @required this.price, @required this.description, @required this.image, this.favourite = false});
}
