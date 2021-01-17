import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final LocationData locationData;

  LocationInput(this.locationData);
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Completer<GoogleMapController> _controller = Completer();
  double lat = 37.42796133580664;
  double lng = -122.085749655962;
  CameraPosition _deviceLocation;
  @override
  void initState() {
    if (widget.locationData != null) {
      lat = widget.locationData.latitude;
      lng = widget.locationData.longitude;
    }
    _deviceLocation = CameraPosition(target: LatLng(lat, lng), zoom: 15);
    super.initState();
  }

  // GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    print(
        'Location data: Latitude: ${widget.locationData.latitude}, Longitude: ${widget.locationData.longitude}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: _deviceLocation,
        markers: {Marker(markerId: MarkerId('Current'), position: LatLng(lat,lng))},
        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // setState(() {
          //   _controller = controller;
          // });
        },
      ),
    );
    // return GoogleMap(initialCameraPosition: deviceLocation, mapType: MapType.hybrid, onMapCreated: (GoogleMapController controller) {
    //   _controller.complete(controller);
    // },);
    // return Column(children: <Widget>[
    //   TextField(),
    //   GoogleMap(initialCameraPosition: deviceLocation, mapType: MapType.hybrid, onMapCreated: (GoogleMapController controller) {
    //      _controller.complete(controller);
    //   },),
    //   Text('Am the demo'),
    // ]);
  }
}
