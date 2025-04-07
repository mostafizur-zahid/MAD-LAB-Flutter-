import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.blueGrey[50],
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final String _apiKey =
      "YOUR_API_KEY"; // Replace with your OpenWeatherMap API key

  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    // Fetch default city weather on app start
    _fetchWeatherData('London');
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherData(String city) async {
    if (city.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage =
              errorData['message'] ?? 'Failed to fetch weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error occurred. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  String _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return '☁️';

    switch (iconCode) {
      case '01d':
        return '☀️'; // Clear sky day
      case '01n':
        return '🌙'; // Clear sky night
      case '02d':
        return '⛅'; // Few clouds day
      case '02n':
        return '☁️'; // Few clouds night
      case '03d':
      case '03n':
        return '☁️'; // Scattered clouds
      case '04d':
      case '04n':
        return '☁️'; // Broken clouds
      case '09d':
      case '09n':
        return '🌧️'; // Shower rain
      case '10d':
      case '10n':
        return '🌦️'; // Rain
      case '11d':
      case '11n':
        return '⛈️'; // Thunderstorm
      case '13d':
      case '13n':
        return '❄️'; // Snow
      case '50d':
      case '50n':
        return '🌫️'; // Mist
      default:
        return '☁️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                _weatherData != null
                    ? () => _fetchWeatherData(_weatherData!['name'])
                    : null,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => _fetchWeatherData(_cityController.text),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _fetchWeatherData(_cityController.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),
          ),

          // Error Message
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading Indicator
          if (_isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Fetching weather data...'),
                  ],
                ),
              ),
            ),

          // Weather Data Display
          if (!_isLoading && _weatherData != null)
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchWeatherData(_weatherData!['name']),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // City Name
                      Text(
                        _weatherData!['name'] +
                            ', ' +
                            _weatherData!['sys']['country'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Weather Icon and Condition
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeatherIcon(
                              _weatherData!['weather'][0]['icon'],
                            ),
                            style: const TextStyle(fontSize: 70),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_weatherData!['main']['temp'].round()}°C',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _weatherData!['weather'][0]['description']
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Additional Weather Details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildWeatherDetailRow(
                              'Feels Like',
                              '${_weatherData!['main']['feels_like'].round()}°C',
                              Icons.thermostat,
                            ),
                            const Divider(),
                            _buildWeatherDetailRow(
                              'Humidity',
                              '${_weatherData!['main']['humidity']}%',
                              Icons.water_drop,
                            ),
                            const Divider(),
                            _buildWeatherDetailRow(
                              'Wind Speed',
                              '${_weatherData!['wind']['speed']} m/s',
                              Icons.air,
                            ),
                            const Divider(),
                            _buildWeatherDetailRow(
                              'Pressure',
                              '${_weatherData!['main']['pressure']} hPa',
                              Icons.speed,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Min-Max Temperature
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTemperatureCard(
                            'Min',
                            '${_weatherData!['main']['temp_min'].round()}°C',
                            Icons.arrow_downward,
                            Colors.blue[700]!,
                          ),
                          const SizedBox(width: 16),
                          _buildTemperatureCard(
                            'Max',
                            '${_weatherData!['main']['temp_max'].round()}°C',
                            Icons.arrow_upward,
                            Colors.red[700]!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueGrey[700], size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard(
    String label,
    String temp,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            Text(
              temp,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
