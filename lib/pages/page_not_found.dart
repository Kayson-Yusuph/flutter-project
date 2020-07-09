import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sorry!, Page not found!'),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        ),
      ),
    );
  }
}
