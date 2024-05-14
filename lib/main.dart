import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_bloc_api/blocs/home_bloc.dart';
import 'package:weather_app_bloc_api/screens/home_screen.dart';
import 'package:weather_app_bloc_api/services/weather_api_client.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(WeatherApiClient()),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(WeatherBloc(WeatherApiClient())),
      ),
    );
  }
}
