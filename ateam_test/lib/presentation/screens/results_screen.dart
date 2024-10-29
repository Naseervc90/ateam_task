import 'dart:math';

import 'package:ateam_test/config/mapbox_config.dart';
import 'package:ateam_test/data/models/location.dart';
import 'package:ateam_test/data/models/route_search.dart';
import 'package:ateam_test/data/repositories/route_repository.dart';
import 'package:ateam_test/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:ateam_test/presentation/blocs/search_bloc/search_event.dart';
import 'package:ateam_test/presentation/blocs/search_bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ResultsScreen extends StatefulWidget {
  final Location startLocation;
  final Location endLocation;

  const ResultsScreen({
    Key? key,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  MapboxMapController? mapController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  void _getRoute() {
    context.read<SearchBloc>().add(GetRoute(
          widget.startLocation,
          widget.endLocation,
        ));
  }

  void _drawRoute(Map<String, dynamic> routeData) {
    if (mapController == null) return;

    final coordinates =
        routeData['routes'][0]['geometry']['coordinates'] as List;
    final points = coordinates.map((coord) {
      return LatLng(coord[1] as double, coord[0] as double);
    }).toList();

    mapController!.addLine(
      LineOptions(
        geometry: points,
        lineColor: "#3887be",
        lineWidth: 5.0,
        lineOpacity: 0.8,
      ),
    );

    // Add markers for start and end points
    mapController!.addSymbol(
      SymbolOptions(
        geometry: LatLng(
            widget.startLocation.latitude, widget.startLocation.longitude),
        iconImage: 'marker-15',
        iconSize: 2.0,
      ),
    );

    mapController!.addSymbol(
      SymbolOptions(
        geometry:
            LatLng(widget.endLocation.latitude, widget.endLocation.longitude),
        iconImage: 'marker-15',
        iconSize: 2.0,
      ),
    );

    // Fit the camera to show the entire route
    // mapController!.fitBounds(
    //   LatLngBounds(
    //     southwest: LatLng(
    //       points.map((p) => p.latitude).reduce(min),
    //       points.map((p) => p.longitude).reduce(min),
    //     ),
    //     northeast: LatLng(
    //       points.map((p) => p.latitude).reduce(max),
    //       points.map((p) => p.longitude).reduce(max),
    //     ),
    //   ),
    //   padding: EdgeInsets.all(50.0),
    // );
  }

  Future<void> _saveRoute(Map<String, dynamic> routeData) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final route = routeData['routes'][0];
      final routeSearch = RouteSearch(
        startLocation: widget.startLocation,
        endLocation: widget.endLocation,
        searchTime: DateTime.now(),
        distance: route['distance'].toDouble(),
        duration: route['duration'].toDouble(),
      );

      await context.read<RouteRepository>().saveRoute(routeSearch);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save route: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  String _formatDistance(Map<String, dynamic> routeData) {
    final distance = routeData['routes'][0]['distance'] as num;
    return '${(distance / 1000).toStringAsFixed(1)} km';
  }

  String _formatDuration(Map<String, dynamic> routeData) {
    final duration = routeData['routes'][0]['duration'] as num;
    final minutes = (duration / 60).round();
    if (minutes < 60) {
      return '$minutes mins';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours h ${remainingMinutes} min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
        actions: [
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is RouteSuccess) {
                return IconButton(
                  icon: Icon(_isSaving ? Icons.hourglass_empty : Icons.save),
                  onPressed: _isSaving ? null : () => _saveRoute(state.route),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RouteSuccess) {
            return Column(
              children: [
                Expanded(
                  child: MapboxMap(
                    accessToken: MapboxConfig.publicKey,
                    styleString: MapboxConfig.styleUrl,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.startLocation.latitude,
                        widget.startLocation.longitude,
                      ),
                      zoom: 12,
                    ),
                    onMapCreated: (controller) {
                      mapController = controller;
                      _drawRoute(state.route);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            _formatDistance(state.route),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            _formatDuration(state.route),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is SearchError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading route',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _getRoute,
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
