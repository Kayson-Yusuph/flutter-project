import 'package:flutter/material.dart';


class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  ProductListPage({this.products});

  ListView _buildProductList() {
    return ListView.builder( itemCount: products.length, itemBuilder: (BuildContext context, int index) {
      return _buildProductListTile(index);
    },);
  }

  Column _buildProductListTile(int index) {
    final Map<String, dynamic> _product = products[index];
    return Column(children: [ListTile(leading: CircleAvatar(backgroundImage: AssetImage(_product['image'],),), title: Text(_product['title'],),subtitle: Text('TZS ${_product['price'].toString()}'), trailing: GestureDetector(onTap: () {
      print('${products[index]['title']} selected!');
    }, child: Icon(Icons.edit,),),), Divider(thickness: 1, color: Colors.black,),],);
  }
  @override
  Widget build(BuildContext context) {
    Widget center = Center(
      child: Text('Product list here!'),
    );
    if(products.length > 0) {
      center = _buildProductList();
    }
    return  center;
  }
}
