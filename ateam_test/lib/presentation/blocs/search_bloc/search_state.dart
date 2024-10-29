import 'package:ateam_test/data/models/location.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLocationSuccess extends SearchState {
  final List<Location> locations;

  SearchLocationSuccess(this.locations);

  @override
  List<Object> get props => [locations];
}

class RouteSuccess extends SearchState {
  final Map<String, dynamic> route;

  RouteSuccess(this.route);

  @override
  List<Object> get props => [route];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}
