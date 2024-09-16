import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LatLng _pGooglePlex=LatLng(37.4, -122.04);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:GoogleMap(
        initialCameraPosition:CameraPosition(
            target: _pGooglePlex,
            zoom:13,
        ),
        markers: {
          Marker(
              markerId: MarkerId("_currentLocation"),
              icon:BitmapDescriptor.defaultMarker,
              position: _pGooglePlex)
        },
      )
    );
  }
}
