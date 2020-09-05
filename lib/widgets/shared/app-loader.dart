import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final String text;
  AppLoader([this.text = 'Loading...']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
