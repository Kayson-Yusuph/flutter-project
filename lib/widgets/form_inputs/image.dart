import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {

  final _buttonColor = Theme.of(context).accentColor;
    return Column(
      children: [
        OutlineButton(
          borderSide: BorderSide(width: 2, color: _buttonColor),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: _buttonColor,),
              SizedBox(
                width: 10,
              ),
              Text('Add picture', style: TextStyle(color: _buttonColor),),
            ],
          ),
        ),
      ],
    );
  }
}
