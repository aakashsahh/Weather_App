import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, LocationPermission, Position;
import 'package:weather_app_bloc_api/models/weather_model.dart';
import 'package:weather_app_bloc_api/services/weather_api_service.dart';

class HomepageBloc extends Cubit<Weather> {
  final WeatherApiService _weatherApiService;

  HomepageBloc(this._weatherApiService) : super(Weather(
        locationName: '',
        temperatureCelsius: 0.0,
        weatherText: '',
        weatherIconUrl: '',
      )) {
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final position = await _determinePosition();
      final weatherData = await _weatherApiService.fetchWeatherDataByLocation(position.latitude, position.longitude);
      emit(weatherData);
    } catch (e) {
      // Handle error
    }
  }

  Future<Position> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      final permissionStatus = await Geolocator.requestPermission();
      if (permissionStatus != LocationPermission.whileInUse && permissionStatus != LocationPermission.always) {
        throw Exception('Location permissions are denied (actual value: $permissionStatus).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void updateWeatherData(String location) {
    _fetchWeatherData();
  }
}
