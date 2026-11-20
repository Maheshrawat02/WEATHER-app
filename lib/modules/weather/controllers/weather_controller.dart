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

    final weatherResult = await service.getWeather(cityName);
    final forecastResult = await service.getForecast(cityName);

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