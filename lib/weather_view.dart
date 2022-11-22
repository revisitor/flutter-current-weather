import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'secrets.dart';
import 'weather.dart';
import 'weather_service.dart';

final _logger = Logger();

class WeatherView extends StatefulWidget {
  final _weatherService = const WeatherService(apiKey: apiKey);

  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: FutureBuilder(
          future: widget._weatherService.getWeather(55.3333, 86.0833),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingWidget();
            }

            if (snapshot.hasData) {
              return _WeatherViewBody(snapshot.data!.toDomain());
            }

            if (snapshot.hasError) {
              _logger.e(snapshot.error! as Error);
              return const _WeatherViewErrorBody();
            }

            return const Text('Неизвестная ошибка.');
          },
        ),
      ),
    );
  }
}

class _WeatherViewBody extends StatelessWidget {
  final Weather weather;

  const _WeatherViewBody(this.weather);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${weather.place}, ${weather.countryCode}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Image.network('https://openweathermap.org/img/wn/${weather.icon}@4x.png'),
            Text(
              weather.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Text(
              '${weather.temperature}°C',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text(
              '${weather.pressureMmHg} мм рт. ст',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherViewErrorBody extends StatelessWidget {
  const _WeatherViewErrorBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Возникла ошибка при получении погоды',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
