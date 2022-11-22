import 'dart:convert';

import 'package:http/http.dart' as http;

import 'weather.dart';

class WeatherService {
  static const _headers = {
    'Accept': 'application/json',
  };

  final String apiKey;

  const WeatherService({required this.apiKey});

  Future<WeatherModel> getWeather(double latitude, double longitude) async {
    var url = _createUrl(latitude, longitude);
    var response = await http.get(url, headers: _headers);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      default:
        throw Exception('Не удалось получить погоду');
    }
  }

  Uri _createUrl(double latitude, double longitude) {
    return Uri.https(
      'api.openweathermap.org',
      'data/2.5/weather',
      {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'appid': apiKey,
        'units': 'metric',
        'lang': 'ru',
      },
    );
  }
}

class WeatherModel {
  final WeatherJson weather;
  final Main main;
  final Sys sys;
  final String place;

  WeatherModel({
    required this.main,
    required this.sys,
    required this.place,
    required this.weather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      weather: WeatherJson.fromJson(json['weather']),
      main: Main.fromJson(json['main']),
      sys: Sys.fromJson(json['sys']),
      place: json['name'],
    );
  }

  Weather toDomain() {
    return Weather(
      description: weather.description,
      icon: weather.icon,
      temperature: main.temperature,
      pressureMmHg: main.pressureMmHg,
      countryCode: sys.countryCode,
      place: place,
    );
  }
}

class WeatherJson {
  final String description;
  final String icon;

  WeatherJson({required this.description, required this.icon});

  factory WeatherJson.fromJson(List<dynamic> json) {
    Map<String, dynamic> weather = json.first;
    return WeatherJson(
      description: weather['description'],
      icon: weather['icon'],
    );
  }
}

class Main {
  final int temperature;
  final double pressureMmHg;

  Main({
    required this.temperature,
    required this.pressureMmHg,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    num temperature = json['temp'];
    return Main(
      temperature: temperature.round(),
      pressureMmHg: _hPaToMmHg(json['pressure']),
    );
  }

  static double _hPaToMmHg(int hPa) => hPa * 0.75;
}

class Sys {
  final String countryCode;

  Sys({required this.countryCode});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(countryCode: json['country']);
  }
}
