import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_bloc_api/blocs/home_event.dart';
import 'package:weather_app_bloc_api/blocs/home_state.dart';
import 'package:weather_app_bloc_api/services/weather_api_client.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiClient weatherApiClient;

  WeatherBloc(this.weatherApiClient) : super(WeatherLoading()) {
    on<GetWeather>((event, emit) async {
      try {
        emit(WeatherLoading());
        final weather = await weatherApiClient.getCurrentWeather(event.location);
        emit(WeatherLoaded(weather!));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<GetWeatherByLatLon>((event, emit) async {
      try {
        emit(WeatherLoading());
        final weather = await weatherApiClient.getWeatherByLatLon(event.lat, event.lon);
        emit(WeatherLoaded(weather!));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
  }
}



// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:weather_app_bloc_api/blocs/home_event.dart';
// import 'package:weather_app_bloc_api/blocs/home_state.dart';
// import 'package:weather_app_bloc_api/services/weather_api_client.dart';

// class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
//   final WeatherApiClient weatherApiClient;

//   WeatherBloc(this.weatherApiClient) : super(WeatherLoading());

//   Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
//     yield WeatherLoading();
//     try {
//       if (event is GetWeather) {
//         final weather = await weatherApiClient.getCurrentWeather(event.location);
//         yield WeatherLoaded(weather!);
//       } else if (event is GetWeatherByLatLon) {
//         final weather = await weatherApiClient.getWeatherByLatLon(event.lat, event.lon);
//         yield WeatherLoaded(weather!);
//       }
//     } catch (e) {
//       yield WeatherError(e.toString());
//     }
//   }
// }
