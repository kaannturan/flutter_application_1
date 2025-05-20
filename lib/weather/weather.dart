import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_application_1/location/location.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:http/http.dart" as http;

class WeatherModel {
  Icon? weatherIcon;
  AssetImage? weatherImage;

  WeatherModel({this.weatherIcon, this.weatherImage});
}

class WeatherData {
  WeatherData({required this.locationData});

  LocationHelper locationData;
  int? currentCondition;
  double? currentTempature;

  Future<void> getCurrentTempature() async {
    final String apiKey = "47785aa1720de454a9011e5569117ae9";
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey&units=metric";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var weatherData = res.body;
      var currentWeather = json.decode(weatherData);
      try {
        currentTempature = currentWeather["main"]["temp"];
        currentCondition = currentWeather["weather"][0]["id"];
        print("Temp: $currentTempature, Condition: $currentCondition");
      } catch (e) {
        print("JSON parse hatası: $e");
      }
    } else {
      print("apiden veri gelmiyor");
    }
  }

//gelen veriyi dinamik hale getirdiğimiz fonksiyon
  WeatherModel? getWeatherDisplayData() {
    if (currentCondition == null) return null;
    if (currentCondition! < 600) {
      return WeatherModel(
          weatherIcon: Icon(
            FontAwesomeIcons.cloud,
            size: 75,
            color: Colors.white,
          ),
          weatherImage: AssetImage("assets/images/bulutlu.jpg"));
    } else {
      var now = DateTime.now();
      if (now.hour >= 19) {
        return WeatherModel(
            weatherIcon: Icon(
              FontAwesomeIcons.moon,
              size: 75,
              color: Colors.white,
            ),
            weatherImage: AssetImage("assets/images/gece.jpg"));
      } else {
        return WeatherModel(
            weatherIcon: Icon(
              FontAwesomeIcons.sun,
              size: 75,
              color: Colors.white,
            ),
            weatherImage: AssetImage("assets/images/gunesli.jpg"));
      }
    }
  }
}
