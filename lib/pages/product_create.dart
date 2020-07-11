import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String title = '';
  String description = '';
  double price = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Tile',
            border: OutlineInputBorder(),
          ),
          onChanged: (String value) {
            setState(() => title = value);
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
          onChanged: (String value) {
            setState(() => description = value);
          },
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          decoration:
              InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() => price = double.parse(value));
          },
        ),
        ButtonBar(
          children: [
            RaisedButton(
              color: Theme.of(context).secondaryHeaderColor,
              child: Text('Cancel'),
              onPressed: () {
                title = '';
                description = '';
                price = 0;
              },
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Save'),
              onPressed: () {
                print({'title': title, 'description': description, 'price': price});
              },
            ),
          ],
        ),
      ],
    );
  }
}
