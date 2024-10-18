import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng? _currentLocation; // No default location
  bool _isLocationAvailable = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          // Handle denied permissions
          return;
        }
      }

      // Try to get the current location
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
        _isLocationAvailable = true;
      });
    } catch (e) {
      print("Error getting location: $e");
      // Handle exception (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLocationAvailable
          ? GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 18,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("_currentLocation"),
            position: _currentLocation!,
          ),
        },
      )
          : const Center(
        child: CircularProgressIndicator(), // Show loading indicator until location is available
      ),
    );
  }
}
