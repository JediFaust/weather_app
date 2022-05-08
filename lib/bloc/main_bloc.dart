import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/coordinates.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/services/requests.dart';

import 'package:weather_app/utils/api_status.dart';

part 'main_event.dart';
part 'main_state.dart';

/*

  I am using LoadCity event to load the city.
  and LoadForecast event to load the forecast.
  Names of the events are self-explanatory.

*/

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<MainEvent>((event, emit) {});

    on<LoadCity>((event, emit) async {
      emit(CityLoading());
      // Getting coordinates from the city we load from user input
      var coordinatesResponse = await getCoordinates(event.city);

      if (coordinatesResponse is Success) {
        // If we get coordinates successfully, we load the Weather
        var weatherResponse = await getWeather(
            (coordinatesResponse.body as Coordinates).lat,
            (coordinatesResponse.body as Coordinates).lon);

        if (weatherResponse is Success) {
          var city = weatherResponse.body as City;
          // if we get weather successfully, we emit CityLoaded state with the city
          emit(CityLoaded(city: city));
        }
        // Code below is for error handling
        if (weatherResponse is Failure) {
          emit(LoadError(error: weatherResponse.errorResponse as String));
        }
      }
      if (coordinatesResponse is Failure) {
        emit(LoadError(error: coordinatesResponse.errorResponse as String));
      }
    });

    on<LoadForecast>((event, emit) async {
      emit(CityLoading());
      // We load the forecast daily from ready coordinates
      var forecastResponse = await getForecast(event.lat, event.lon);

      if (forecastResponse is Success) {
        var forecast = forecastResponse.body as Forecast;

        // if we get forecast successfully, we get first three days
        // and we extract Daily item
        // with minimum combined day/night temperature

        Daily minDaily = forecast.daily!.first;
        int minIndex = 0;
        List<Daily> dailyForecast = forecast.daily!.sublist(0, 3).map((e) {
          if ((e.temp!.day! + e.temp!.night!) <
              (minDaily.temp!.day! + minDaily.temp!.night!)) {
            minDaily = e;
            minIndex = forecast.daily!.indexOf(e);
          }
          return e;
        }).toList();

        // If minimum index is not 0, we swap minimum daily with the first one
        if (minIndex != 0) {
          var tmp = dailyForecast[0];
          dailyForecast[0] = dailyForecast[minIndex];
          dailyForecast[minIndex] = tmp;
        }

        // After we get ready daily forecast, we emit ForecastLoaded state with the forecast
        emit(ForecastLoaded(forecast: dailyForecast));
      }
      if (forecastResponse is Failure) {
        emit(LoadError(error: forecastResponse.errorResponse as String));
      }
    });
  }
}
