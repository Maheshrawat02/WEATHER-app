import 'package:dio/dio.dart';
import 'package:weather/modules/weather/models/forecast_model.dart';
import 'package:weather/modules/weather/models/weather_model.dart';

class WeatherService {
  final Dio dio = Dio();

  static const String _apiKey = "yourAPIKey"; // put your own key here

  // Checks the name with the Geocoding API (exact name match).
  // Returns the matching place, or throws "City not found".
  Future<Map<String, dynamic>> findCity(
    String cityName, {
    List<String>? allowedCountries, // e.g. ['NP', 'IN']; null = any
  }) async {
    Response response = await dio.get(
      "https://api.openweathermap.org/geo/1.0/direct",
      queryParameters: {
        "q": cityName,
        "limit": 5,
        "appid": _apiKey,
      },
    );

    final List results = response.data;
    final typed = cityName.trim().toLowerCase();

    final matches = results.where((p) {
      final sameName = (p["name"] as String).toLowerCase() == typed;
      final countryOk =
          allowedCountries == null || allowedCountries.contains(p["country"]);
      return sameName && countryOk;
    }).toList();

    if (matches.isEmpty) {
      throw Exception("City not found");
    }

    return Map<String, dynamic>.from(matches.first);
  }

  // CHANGED (suggestions): returns up to 5 matching places for the dropdown
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    Response response = await dio.get(
      "https://api.openweathermap.org/geo/1.0/direct",
      queryParameters: {
        "q": query,
        "limit": 5,
        "appid": _apiKey,
      },
    );

    return (response.data as List)
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // weather by coordinates
  Future<WeatherModel> getWeather(double lat, double lon) async {
    Response response = await dio.get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": _apiKey,
        "units": "metric",
      },
    );

    var json = response.data;

    return WeatherModel.fromJson(json);
  }

  // forecast by coordinates
  Future<List<ForecastModel>> getForecast(double lat, double lon) async {
    Response response = await dio.get(
      "https://api.openweathermap.org/data/2.5/forecast",
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": _apiKey,
        "units": "metric",
      },
    );

    var forecastList = response.data["list"];

    return forecastList
        .map<ForecastModel>((json) => ForecastModel.fromJson(json))
        .toList();
  }
}