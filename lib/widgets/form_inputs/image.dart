import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final picker = ImagePicker();
  File _image;

  void _openImagePickerButtons(BuildContext context) {
    showBottomSheet(
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _getImage(true);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt),
                      Text('Take picture'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(false);
                  },
                  child: Column(
                    children: [
                      Icon(Icons.photo_album),
                      Text('pick from gallery')
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future _getImage(bool usingCamera) async {
    PickedFile filePicked;
    if (usingCamera) {
      filePicked = await picker.getImage(source: ImageSource.camera);
    } else {
      filePicked = await picker.getImage(source: ImageSource.gallery);
    }

    setState(() {
      if (filePicked != null) {
        _image = File(filePicked.path);
      } else {
        print('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _buttonColor = Theme.of(context).accentColor;
    return Column(
      children: [
        OutlineButton(
          borderSide: BorderSide(width: 2, color: _buttonColor),
          onPressed: () => _openImagePickerButtons(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                color: _buttonColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Add picture',
                style: TextStyle(color: _buttonColor),
              ),
            ],
          ),
        ),
        _image == null
            ? SizedBox()
            : Container(
                height: 300,
                child: Image.file(_image),
              )
      ],
    );
  }
}
