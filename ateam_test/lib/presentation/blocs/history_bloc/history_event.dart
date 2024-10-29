import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadSearchHistory extends HistoryEvent {}

class DeleteSearchHistory extends HistoryEvent {
  final String routeId;

  const DeleteSearchHistory(this.routeId);

  @override
  List<Object> get props => [routeId];
}

class ClearSearchHistory extends HistoryEvent {}
