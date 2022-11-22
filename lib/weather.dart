class Weather {
  final String description;
  final String icon;
  final int temperature;
  final double pressureMmHg;
  final String countryCode;
  final String place;

  Weather({
    required this.description,
    required this.icon,
    required this.temperature,
    required this.place,
    required this.pressureMmHg,
    required this.countryCode,
  });
}
