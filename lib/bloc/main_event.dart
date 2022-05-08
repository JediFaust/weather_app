part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class LoadCity extends MainEvent {
  final String? city;

  const LoadCity({this.city});

  @override
  List<Object> get props => [city as City];
}

class LoadForecast extends MainEvent {
  final double? lat;
  final double? lon;

  const LoadForecast({this.lat, this.lon});

  @override
  List<Object> get props => [lat as double, lon as double];
}
