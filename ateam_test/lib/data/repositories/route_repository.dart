import 'package:hive/hive.dart';
import '../models/route_search.dart';

class RouteRepository {
  static const String _boxName = 'routes';

  Future<void> saveRoute(RouteSearch route) async {
    final box = await Hive.openBox<RouteSearch>(_boxName);
    await box.add(route);
  }

  Future<List<RouteSearch>> getSearchHistory() async {
    final box = await Hive.openBox<RouteSearch>(_boxName);
    return box.values.toList();
  }
}
