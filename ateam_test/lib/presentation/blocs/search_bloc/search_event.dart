import 'package:ateam_test/data/models/location.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchLocation extends SearchEvent {
  final String query;

  SearchLocation(this.query);

  @override
  List<Object> get props => [query];
}

class GetRoute extends SearchEvent {
  final Location start;
  final Location end;

  GetRoute(this.start, this.end);

  @override
  List<Object> get props => [start, end];
}
