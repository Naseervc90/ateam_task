import 'package:hive/hive.dart';
part 'location.g.dart';

@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
