import 'package:weather_app_bloc_api/models/weather_model.dart';

abstract class WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}
