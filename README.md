
# Weather App

The Weather App is a Flutter application that provides users with current weather information based on their location or any specific location they enter. The app fetches weather data from the OpenWeatherMap API and displays it in a user-friendly interface.


## Features

- View current weather information based on user's location
- Search for weather information for specific locations
- Display temperature, humidity, wind speed, weather condition and feels like.



## Setup

To run the Weather App on your local machine, follow these steps:

Prerequisites
-
Flutter SDK installed on your machine. You can download it from https://docs.flutter.dev/release/archive.

Android/iOS emulator or a physical device connected for testing.

Installation
-
1. Clone this repository to your local machine using:
```bash
  git clone https://github.com/aakashsahh/Weather_App.git
```
2. Navigate to the project directory:

```bash
  cd weather_app
```
3. Install dependencies using Flutter CLI:
```bash
flutter pub get
```
Running the App
-
Ensure that you have an Android/iOS emulator running or a physical device connected.
Run the app using Flutter CLI:
```bash
flutter run
```

## Running Tests

Unit tests can be run using Flutter CLI:
```bash
flutter test
```
To generate a coverage report, use the following command:
```bash
flutter test --coverage
```

## Usage
1. Upon launching the app, the current weather information for your location will be displayed.

2. You can enter a specific location in the search bar and tap the "Update" button to fetch weather information for that location.

3. If the location is valid, the app will display the weather details. Otherwise, an error message will be shown.


## Credits
This app utilizes the OpenWeatherMap API for fetching weather data.

Icons used in the app are provided by [OpenWeatherMap](https://openweathermap.org/current).
## Contributing

Contributions are welcome! If you find any bugs or want to suggest improvements, feel free to open an issue or submit a pull request.



## License
This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License. See the LICENSE file for details.



