import 'package:ateam_test/config/mapbox_config.dart';
import 'package:ateam_test/data/models/location.dart';
import 'package:ateam_test/presentation/widgets/location_search_field.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location? startLocation;
  Location? endLocation;
  MapboxMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Finder'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LocationSearchField(
                  label: 'Start Location',
                  onLocationSelected: (location) {
                    setState(() => startLocation = location);
                    _updateMapPin(location, isStart: true);
                  },
                ),
                SizedBox(height: 16),
                LocationSearchField(
                  label: 'End Location',
                  onLocationSelected: (location) {
                    setState(() => endLocation = location);
                    _updateMapPin(location, isStart: false);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: MapboxMap(
              accessToken: MapboxConfig.publicKey,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 1,
              ),
              onMapCreated: (controller) => mapController = controller,
              onStyleLoadedCallback: () {
                // Map style loaded callback
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: startLocation != null && endLocation != null
                  ? () => _navigateToResults()
                  : null,
              child: Text('Navigate'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMapPin(Location location, {required bool isStart}) {
    if (mapController == null) return;

    final symbol = SymbolOptions(
      geometry: LatLng(location.latitude, location.longitude),
      iconImage: isStart ? 'start-pin' : 'end-pin',
      iconSize: 1.5,
    );

    mapController!.addSymbol(symbol);
    mapController!.animateCamera(
      CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
    );
  }

  void _navigateToResults() {
    if (startLocation != null && endLocation != null) {
      Navigator.pushNamed(
        context,
        '/results',
        arguments: {
          'start': startLocation,
          'end': endLocation,
        },
      );
    }
  }
}
