import 'package:flutter/material.dart';

class StaticMap extends StatefulWidget {
  Map<String, String> location;
  final int width;
  final int height;
  final int zoom;

  StaticMap(
      {this.width, this.height, this.location, this.zoom});
  @override
  _StaticMapState createState() => new _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  final String googleMapsApiKey = 'AIzaSyDArO1uM71y8qfQUC2PaAKiVZjfCLx9ERM';
  String startUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2000px-Solid_white.svg.png';
  String nextUrl;
  static const int defaultWidth = 600;
  static const int defaultHeight = 400;
  Map<String, String> defaultLocation = {
    "lat": '37.0902',
    "lng": '-95.7192'
  };

  _buildUrl(Map<String, String> location, int width, int height) {
    var finalUri;
    var baseUri = new Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    
      finalUri = baseUri.replace(queryParameters: {
        'center': "${location['lat']},${location['lng']}",
        'zoom': widget.zoom.toString(),
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        'key': '$googleMapsApiKey'
      });

      /*
    if (widget.locations.length == 1) {
      finalUri = baseUri.replace(queryParameters: {
        'center': '${locations[0]['latitude']},${locations[0]['longitude']}',
        'zoom': widget.zoom.toString(),
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        '${widget.googleMapsApiKey}': ''
      });
    } else {
      List<String> markers = new List();
      widget.locations.forEach((location) {
        var lat = location['latitude'];
        var lng = location['longitude'];
        String marker = '$lat,$lng';
        markers.add(marker);
      });
      String markersString = markers.join('|');
      finalUri = baseUri.replace(queryParameters: {
        'markers': markersString,
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        '${widget.googleMapsApiKey}': ''
      });
    }
    */
    setState(() {
      startUrl = nextUrl ?? startUrl;
      nextUrl = finalUri.toString();
      print('Url is: $nextUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.location == null) {
    // }
      widget.location = defaultLocation;
    _buildUrl(widget.location, widget.width ?? defaultWidth,
        widget.height ?? defaultHeight);
    return Scaffold(appBar: AppBar(title: Text('Static Map View'),), body: Container(
        child: new FadeInImage(
      placeholder: new NetworkImage(startUrl),
      image: new NetworkImage(nextUrl),
    )));
  }
}