part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [];
}

class CityLoading extends MainState {
  @override
  List<Object> get props => [];
}

class CityLoaded extends MainState {
  final City? city;

  const CityLoaded({this.city});

  @override
  List<Object> get props => [city as City];
}

class ForecastLoaded extends MainState {
  final List<Daily> forecast;

  const ForecastLoaded({required this.forecast});

  @override
  List<Object> get props => [forecast as Daily];
}

class LoadError extends MainState {
  final String error;

  const LoadError({this.error = 'Default Error Unknown'});

  @override
  List<Object> get props => [error];
}
