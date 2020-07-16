import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;
  PriceTag(this.price);

  @override
  Container build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(6)),
      child: Text(
        'TZS $price',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
