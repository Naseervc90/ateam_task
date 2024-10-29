import 'package:ateam_test/data/services/mapbox_service.dart';
import 'package:ateam_test/presentation/blocs/search_bloc/search_event.dart';
import 'package:ateam_test/presentation/blocs/search_bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MapboxService _mapboxService;

  SearchBloc(this._mapboxService) : super(SearchInitial()) {
    on<SearchLocation>(_onSearchLocation);
    on<GetRoute>(_onGetRoute);
  }

  void _onSearchLocation(
      SearchLocation event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final locations = await _mapboxService.searchLocation(event.query);
      emit(SearchLocationSuccess(locations));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onGetRoute(GetRoute event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final route = await _mapboxService.getRoute(event.start, event.end);
      emit(RouteSuccess(route));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
