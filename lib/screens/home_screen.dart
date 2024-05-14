import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_bloc_api/blocs/home_bloc.dart';
import 'package:weather_app_bloc_api/blocs/home_event.dart';
import 'package:weather_app_bloc_api/blocs/home_state.dart';
import 'package:weather_app_bloc_api/services/weather_api_client.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final WeatherBloc weatherBloc;

  const HomeScreen(this.weatherBloc, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController inputController = TextEditingController();

  WeatherApiClient weatherApiClient = WeatherApiClient();

  static const String _kLocationServicesDisabledMessage = 'Location services are disabled.';
  // static const String _kPermissionDeniedMessage = 'Permission denied.';
  // static const String _kPermissionDeniedForeverMessage =
  //     'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  Position? position;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<Position> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      throw Exception('Location permissions not granted');
    }

    Position localPosition = await _geolocatorPlatform.getCurrentPosition();
    widget.weatherBloc.add(GetWeatherByLatLon(localPosition.latitude, localPosition.longitude));

    return localPosition;
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_kLocationServicesDisabledMessage)),
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location Permission is denied")),
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location Permission is denied, Please enable it from settings")),
      );

      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(_kPermissionGrantedMessage)),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        bloc: widget.weatherBloc,
        builder: (context, state) {
          if (state is WeatherLoading) {
            return CircularProgressIndicator();
          } else if (state is WeatherLoaded) {
            return Column(
              children: [
                Text('Temperature in ${state.weather.cityName}: ${state.weather.currentTemp} \u2103'),
                TextFormField(
                  controller: inputController,
                  decoration: InputDecoration(
                    label: const Text("Location"),
                    hintText: "Enter location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(width: 2, color: Colors.red),
                  ),
                  onPressed: () async {
                    String location = inputController.text;
                    if (location.isEmpty) {
                      Position position = await _getCurrentPosition();
                      widget.weatherBloc.add(GetWeatherByLatLon(position.latitude, position.longitude));
                    } else {
                      
                      widget.weatherBloc.add(GetWeather(location));
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          } else if (state is WeatherError) {
            return Text('Error: ${state.message}');
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
