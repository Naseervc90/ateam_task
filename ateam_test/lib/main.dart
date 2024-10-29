import 'package:ateam_test/data/models/location.dart';
import 'package:ateam_test/data/models/route_search.dart';
import 'package:ateam_test/data/repositories/route_repository.dart';
import 'package:ateam_test/data/services/mapbox_service.dart';
import 'package:ateam_test/presentation/blocs/history_bloc/history_bloc.dart';
import 'package:ateam_test/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:ateam_test/presentation/screens/history_screen.dart';
import 'package:ateam_test/presentation/screens/home_screen.dart';
import 'package:ateam_test/presentation/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(RouteSearchAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MapboxService mapboxService = MapboxService();
  final RouteRepository routeRepository = RouteRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(mapboxService),
        ),
        BlocProvider<HistoryBloc>(
          create: (context) => HistoryBloc(routeRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Route Finder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/history': (context) => HistoryScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/results') {
            final args = settings.arguments as Map<String, Location>;
            return MaterialPageRoute(
              builder: (context) => ResultsScreen(
                startLocation: args['start']!,
                endLocation: args['end']!,
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
