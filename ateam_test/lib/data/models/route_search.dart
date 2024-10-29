import 'package:ateam_test/data/models/location.dart';
import 'package:hive/hive.dart';
part 'route_search.g.dart';

@HiveType(typeId: 1)
class RouteSearch extends HiveObject {
  @HiveField(0)
  final Location startLocation;

  @HiveField(1)
  final Location endLocation;

  @HiveField(2)
  final DateTime searchTime;

  @HiveField(3)
  final double distance;

  @HiveField(4)
  final double duration;

  RouteSearch({
    required this.startLocation,
    required this.endLocation,
    required this.searchTime,
    required this.distance,
    required this.duration,
  });
}
