import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_bloc_api/blocs/weather_bloc.dart';
import 'package:weather_app_bloc_api/screens/help_screen.dart';
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
      child: const MaterialApp(
        title: 'Weather App',
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: HelpScreen(),
      ),
    );
  }
}
