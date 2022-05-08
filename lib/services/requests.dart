import 'package:dio/dio.dart';
import 'package:weather_app/config.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/models/coordinates.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/utils/api_status.dart';
import 'package:weather_app/utils/constants.dart';

Future<Object> getWeather(latitude, longitude) async {
  var dio = Dio();
  dio.interceptors.add(LogInterceptor());

  try {
    Response weatherResponse = await dio.get(
      'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$API_KEY',
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    if (weatherResponse.statusCode == 200) {
      var _weather = City.fromJson(weatherResponse.data);

      return Success(body: _weather);
    }
    return Failure(
        code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
  } catch (e) {
    return Failure(code: UNKNOWN_ERROR, errorResponse: e.toString());
  }
}

Future<Object> getForecast(latitude, longitude) async {
  var dio = Dio();
  dio.interceptors.add(LogInterceptor());

  //try {
  Response forecastResponse = await dio.get(
    'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$API_KEY',
    options: Options(headers: {"Content-Type": "application/json"}),
  );

  if (forecastResponse.statusCode == 200) {
    var _forecast = Forecast.fromJson(forecastResponse.data);

    return Success(body: _forecast);
  }
  return Failure(
      code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
  // } catch (e) {
  //   return Failure(code: UNKNOWN_ERROR, errorResponse: e.toString());
  // }
}

Future<Object> getCoordinates(city) async {
  var dio = Dio();
  dio.interceptors.add(LogInterceptor());

  try {
    Response coordinatesResponse = await dio.get(
      'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$API_KEY',
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    if (coordinatesResponse.statusCode == 200) {
      var _coordinates = Coordinates(
        name: coordinatesResponse.data[0]["name"],
        lat: coordinatesResponse.data[0]["lat"],
        lon: coordinatesResponse.data[0]["lon"],
        country: coordinatesResponse.data[0]["country"],
      );
      return Success(body: _coordinates);
    }
    return Failure(
        code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
  } catch (e) {
    return Failure(code: UNKNOWN_ERROR, errorResponse: e.toString());
  }
}

// api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={cnt}&appid={API key}
// api.openweathermap.org/data/2.5/forecast/daily?lat=51.5073219&lon=-0.1276474&cnt=3&appid=0ae82b1b7630936c105806748134d37c
// https://api.openweathermap.org/data/2.5/onecall?lat=51.5073219&lon=-0.1276474&appid=0ae82b1b7630936c105806748134d37c

// http://api.openweathermap.org/data/2.5/weather?lat=51.5073219&lon=-0.1276474&appid=0ae82b1b7630936c105806748134d37c