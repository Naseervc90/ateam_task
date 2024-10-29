import 'package:ateam_test/data/models/route_search.dart';
import 'package:equatable/equatable.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoadSuccess extends HistoryState {
  final List<RouteSearch> searches;

  const HistoryLoadSuccess(this.searches);

  @override
  List<Object> get props => [searches];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
