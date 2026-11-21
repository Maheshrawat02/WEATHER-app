import 'package:get/get.dart';
import 'package:weather/modules/weather/models/forecast_model.dart';
import 'package:weather/modules/weather/models/weather_model.dart';
import 'package:weather/modules/weather/services/weather_service.dart';

class WeatherController extends GetxController{
 WeatherService service = WeatherService();

 final weather = Rxn<WeatherModel>();
 final forecasts = <ForecastModel>[].obs;

 var isLoading = false.obs;
 var error ="".obs;

 Future searchWeather(String cityName) async{

  try{
    isLoading(true);
    error("");

    weather.value = null;
    forecasts.clear();

    // Step 1 - confirm the city exists (exact name match)
    final place = await service.findCity(cityName);

    final lat = (place["lat"] as num).toDouble();
    final lon = (place["lon"] as num).toDouble();

    // Step 2 - fetch weather and forecast for that exact place
    final weatherResult = await service.getWeather(lat, lon);
    final forecastResult = await service.getForecast(lat, lon);

    weather.value = weatherResult;
    forecasts.value = forecastResult;

  }catch(e){

    error(e.toString());
    print(error);

  }finally{
    isLoading(false);
  }
 }

 // CHANGED (suggestions): loads weather for the place the user tapped
 Future searchWeatherByPlace(Map<String, dynamic> place) async{

  try{
    isLoading(true);
    error("");

    weather.value = null;
    forecasts.clear();

    final lat = (place["lat"] as num).toDouble();
    final lon = (place["lon"] as num).toDouble();

    final weatherResult = await service.getWeather(lat, lon);
    final forecastResult = await service.getForecast(lat, lon);

    weather.value = weatherResult;
    forecasts.value = forecastResult;

  }catch(e){

    error(e.toString());
    print(error);

  }finally{
    isLoading(false);
  }
 }

}