 import 'dart:convert';
 import 'package:geolocator/geolocator.dart';
 import 'package:http/http.dart' as http;
 import 'weather_model.dart';

   class WeatherService {
     final String apiKey = '7cc8dae3190a83911a8a77702a83ecb7';
   final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Get current device location
   Future<Position> getCurrentLocation() async {
     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       throw Exception('Location services are disabled.');
     }

     LocationPermission permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         throw Exception('Location permissions are denied.');
       }
     }

     if (permission == LocationPermission.deniedForever) {
       throw Exception('Location permissions are permanently denied.');
     }

     return await Geolocator.getCurrentPosition(
       desiredAccuracy: LocationAccuracy.high,
     );
   }

   // Fetch weather with longitude and latitude inside the position
   Future<Weather> getWeatherByLocation() async {
     try {
       final position = await getCurrentLocation();
       

       final url =
           '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';
       final response = await http
           .get(Uri.parse(url))
           .timeout(const Duration(seconds: 10));

       if (response.statusCode == 200) {
         print(" Weather fetched successfully");
         return Weather.fromJson(jsonDecode(response.body));
       } else {
         print("Response status: ${response.statusCode}");
         print(" Response body: ${response.body}");
         throw Exception('Unable to detect your city');
       }
     } catch (e) {
       print(" Exception: $e");
       throw Exception('Unable to detect your city');
     }
   }
 }
