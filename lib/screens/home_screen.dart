import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
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
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  Position? position;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
      _showSnackBar(_kLocationServicesDisabledMessage);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text(_kLocationServicesDisabledMessage)),
      //);

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Location Permission is denied")),
        // );
        _showSnackBar("Location Permission is denied");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Location Permission is denied, Please enable it from settings")),
      // );
      _showSnackBar("Location Permission is denied, Please enable it from settings");

      return false;
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text(_kPermissionGrantedMessage)),
    // );
    _showSnackBar(_kPermissionGrantedMessage);

    return true;
  }

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> isValidLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      return locations.isNotEmpty;
    } catch (e) {
      return false;
    }
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                  const SizedBox(
                    height: 20,
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
                        if (await isValidLocation(location)) {
                          widget.weatherBloc.add(GetWeather(location));
                        } else {
                          // Handle invalid location
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Invalid Location'),
                                content: const Text('Please enter a valid location.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Update'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        (state.weather.icon != null)
                            ? Image.network(
                                "https://openweathermap.org/img/wn/${state.weather.icon}@2x.png",
                                height: 100,
                                width: 200,
                              )
                            : const Text("No data Found"),
                        Text(
                          (state.weather.currentTemp != null) ? '${state.weather.currentTemp} \u2103' : "No data Found",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (state.weather.cityName != null) ? '${state.weather.cityName}' : "No Data Found",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (state.weather.condition != null) ? '${state.weather.condition}' : "No Data Found",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.grey,
                  )
                ],
              ),
            );
          } else if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () async {
                      Position position = await _getCurrentPosition();
                      widget.weatherBloc.add(GetWeatherByLatLon(position.latitude, position.longitude));
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Unexpected error occurred.'));
          }
        },
      ),
    );
  }
}
