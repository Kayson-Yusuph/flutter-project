import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String price;
  final String description;
  final String image;
  final String userEmail;
  final String userId;
  final bool favorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.image,
    @required this.userEmail,
    @required this.userId,
    this.favorite = false,
  });

  bool get imageExist => this.image != null && this.image != '';
}
