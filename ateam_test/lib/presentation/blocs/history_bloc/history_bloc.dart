import 'package:ateam_test/data/repositories/route_repository.dart';
import 'package:ateam_test/presentation/blocs/history_bloc/history_event.dart';
import 'package:ateam_test/presentation/blocs/history_bloc/history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final RouteRepository _routeRepository;

  HistoryBloc(this._routeRepository) : super(HistoryInitial()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<DeleteSearchHistory>(_onDeleteSearchHistory);
    on<ClearSearchHistory>(_onClearSearchHistory);
  }

  void _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(HistoryLoading());
      final searches = await _routeRepository.getSearchHistory();
      emit(HistoryLoadSuccess(searches));
    } catch (e) {
      emit(HistoryError('Failed to load search history: ${e.toString()}'));
    }
  }

  void _onDeleteSearchHistory(
    DeleteSearchHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(HistoryLoading());
      //await _routeRepository.deleteRoute(event.routeId);
      final searches = await _routeRepository.getSearchHistory();
      emit(HistoryLoadSuccess(searches));
    } catch (e) {
      emit(HistoryError('Failed to delete route: ${e.toString()}'));
    }
  }

  void _onClearSearchHistory(
    ClearSearchHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      emit(HistoryLoading());
      //await _routeRepository.clearHistory();
      emit(HistoryLoadSuccess([]));
    } catch (e) {
      emit(HistoryError('Failed to clear history: ${e.toString()}'));
    }
  }
}
