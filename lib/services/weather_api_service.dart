
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_app_bloc_api/models/weather_model.dart';

class WeatherApiService {
  static const apiKey = '375f4d70bfb5a581278a072b75a010ab'; 
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeatherDataByLocation(double lat, double lon) async {
     final url = Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return _parseWeatherData(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Weather _parseWeatherData(Map<String, dynamic> json) {
    final locationName = json['name'] as String;
    final temperatureFahrenheit = json['main']['temp'] as double;
    final temperatureCelsius = _convertFahrenheitToCelsius(temperatureFahrenheit);
    final weatherText = json['weather'][0]['main'] as String;
    final weatherIconCode = json['weather'][0]['icon'] as String;
    final weatherIconUrl = 'https://openweathermap.org/img/wn/$weatherIconCode.png';

    return Weather(
      locationName: locationName,
      temperatureCelsius: temperatureCelsius,
      weatherText: weatherText,
      weatherIconUrl: weatherIconUrl,
    );
  }

  double _convertFahrenheitToCelsius(double temperatureFahrenheit) {
    return (temperatureFahrenheit - 32) * 5 / 9;
  }
}
