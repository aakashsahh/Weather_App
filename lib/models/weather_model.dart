class Weather {
  final String locationName;
  final double temperatureCelsius;
  final String weatherText;
  final String weatherIconUrl;

  Weather({
    required this.locationName,
    required this.temperatureCelsius,
    required this.weatherText,
    required this.weatherIconUrl,
  });
}