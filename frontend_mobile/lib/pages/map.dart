import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
      body: Map(null),
    );
  }
}

class Map extends StatefulWidget {
  Map(this.onTapFunction);

  final void Function(LatLng) onTapFunction;

  @override
  _MapState createState() => _MapState(onTapFunction);
}

class _MapState extends State<Map> {
  _MapState(this.onTapFunction);

  final void Function(LatLng) onTapFunction;

  LocationData _currentLocation;
  CameraPosition _currentCameraPosition;

  Location _locationService = new Location();

  bool _permission = false;
  String error;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(40.773779, -73.971854),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
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
              target: LatLng(location.latitude, location.longitude), zoom: 11);

          final GoogleMapController controller = await _controller.future;
          controller.moveCamera(
              CameraUpdate.newCameraPosition(_currentCameraPosition));

          if (mounted) {
            setState(() {
              _currentLocation = location;
            });
          }
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          initPlatformState();
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
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      initialCameraPosition: _initialCamera,
      onTap: onTapFunction,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
