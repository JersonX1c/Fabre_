import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  String city = "Bamban";
  String condition = "Cloudy";
  int temperature = 39;

  final String apiKey = "8e4f3a785cad2007689b44d68d08c00b";

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String cityName) async {
    try {
      final weatherUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey';
      final weatherRes = await http.get(Uri.parse(weatherUrl));

      if (weatherRes.statusCode != 200) {
        throw Exception("City not found");
      }

      final weatherData = json.decode(weatherRes.body);

      setState(() {
        temperature = weatherData['main']['temp'].toInt();

        // Limit to Cloudy, Sunny, Rainy
        String apiCondition = weatherData['weather'][0]['main'];
        if (apiCondition.toLowerCase().contains("clear")) {
          condition = "Sunny";
        } else if (apiCondition.toLowerCase().contains("rain")) {
          condition = "Rainy";
        } else {
          condition = "Cloudy";
        }

        city = weatherData['name'];
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not fetch weather data.")),
      );
    }
  }

  void _searchCity() {
    if (_controller.text.isNotEmpty) {
      fetchWeather(_controller.text);
    }
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "sunny":
        return "assets/sunny.webp";
      case "rainy":
        return "assets/rainy.png";
      case "cloudy":
      default:
        return "assets/cloudy.png";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}'/${date.month}'"; // Format: day'/month'
  }

  List<Map<String, String>> _getNextThreeDays() {
    final now = DateTime.now();
    return [
      {
        "day": "Today",
        "date": _formatDate(now),
      },
      {
        "day": DateFormat('EEEE').format(now.add(const Duration(days: 1))),
        "date": _formatDate(now.add(const Duration(days: 1))),
      },
      {
        "day": DateFormat('EEEE').format(now.add(const Duration(days: 2))),
        "date": _formatDate(now.add(const Duration(days: 2))),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final nextDays = _getNextThreeDays();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "WEATHER",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A5C82),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Search city",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _searchCity,
                      icon: const Icon(Icons.search, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // City name
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  city.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A5C82),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Temperature and weather
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$temperature°",
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        _getWeatherIcon(condition),
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 10),
                      // Text sa gilid ng icon: CAPS + date
                      Text(
                        "${condition.toUpperCase()}' ${_formatDate(DateTime.now())}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A5C82),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sa ilalim: Next three days with date only
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: nextDays.map((day) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            day["day"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            day["date"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
