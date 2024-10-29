import 'dart:convert';

import 'package:ateam_test/config/mapbox_config.dart';
import 'package:ateam_test/data/models/location.dart';
import 'package:http/http.dart' as http;

class MapboxService {
  final String _baseUrl = 'api.mapbox.com';
  final String _accessToken = MapboxConfig.publicKey;

  Future<List<Location>> searchLocation(String query) async {
    final url = Uri.https(_baseUrl, '/geocoding/v5/mapbox.places/$query.json', {
      'access_token': _accessToken,
      'limit': '5',
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List).map((feature) {
        final coordinates = feature['center'] as List;
        return Location(
          name: feature['place_name'],
          longitude: coordinates[0],
          latitude: coordinates[1],
        );
      }).toList();
    }
    throw Exception('Failed to search location');
  }

  Future<Map<String, dynamic>> getRoute(Location start, Location end) async {
    final url = Uri.https(
        _baseUrl,
        '/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}',
        {
          'access_token': _accessToken,
          'geometries': 'geojson',
        });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to get route');
  }
}
