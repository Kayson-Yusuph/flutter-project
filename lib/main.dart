import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}
class _MyAppState extends State<MyApp>{
  List<String> _products = ['assets/food.jpg'];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('EasyList'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _products.add('assets/food.jpg')
                  });
                },
                child: Text('Add Product'),
              ),
            ),


            Column(children: _products.map((product) => Card(child: Column(children: [Image.asset(product), Text('Food Paradise'),]),)).toList(),
            ),


        ),
      ),
    );
  }
}
