import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "locatr",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  CameraPosition _currentCameraPosition;

  Location _locationService = new Location();

  bool _permission = false;
  bool _done = false;
  String error;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(40.773779, -73.971854),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;

    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        if (_permission) {
          location = await _locationService.getLocation();
          _currentCameraPosition = CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 11,
          );
          _done = true;
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          _init();
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.hybrid,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      initialCameraPosition: _initialCamera,
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
        while (!_done) {}
        final GoogleMapController tempController = await _controller.future;
        tempController.moveCamera(
          CameraUpdate.newCameraPosition(_currentCameraPosition),
        );
      },
    );
  }
}
