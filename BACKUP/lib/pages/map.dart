import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  MapPage(this.latLng);

  final LatLng latLng;

  @override
  _MapPageState createState() => _MapPageState(latLng);
}

class _MapPageState extends State<MapPage> {
  _MapPageState(this.latLng);

  final LatLng latLng;

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
      body: Map(null, latLng),
    );
  }
}

class Map extends StatefulWidget {
  Map(this.onTapFunction, this.center);

  final void Function(LatLng) onTapFunction;
  final LatLng center;

  @override
  _MapState createState() => _MapState(onTapFunction, center);
}

class _MapState extends State<Map> {
  _MapState(this.onTapFunction, this.center);

  final void Function(LatLng) onTapFunction;
  final LatLng center;

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

    if (center == null) {
      try {
        bool serviceStatus = await _locationService.serviceEnabled();
        if (serviceStatus) {
          _permission = await _locationService.requestPermission();
          if (_permission) {
            location = await _locationService.getLocation();
            _currentCameraPosition = CameraPosition(
                target: LatLng(location.latitude, location.longitude),
                zoom: 11);

            final GoogleMapController controller = await _controller.future;
            controller.moveCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));
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
    } else {
      _currentCameraPosition = CameraPosition(
        target: center,
        zoom: 11,
      );
      final GoogleMapController controller = await _controller.future;
      controller
          .moveCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
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
