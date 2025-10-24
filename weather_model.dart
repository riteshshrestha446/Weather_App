class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> data) {
    return Weather(
      cityName: data['name'],
      temperature: data['main']['temp'].toDouble(),
      mainCondition: data['weather'][0]['main'],
    );
  }
}
