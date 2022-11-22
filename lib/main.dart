import 'package:flutter/material.dart';
import 'package:weather_app/weather_view.dart';

void main() {
  var app = const MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherView(),
    );
  }
}
