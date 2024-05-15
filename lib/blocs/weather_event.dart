abstract class WeatherEvent {}

class GetWeather extends WeatherEvent {
  final String location;

  GetWeather(this.location);
}

class GetWeatherByLatLon extends WeatherEvent {
  final double lat;
  final double lon;

  GetWeatherByLatLon(this.lat, this.lon);
}
