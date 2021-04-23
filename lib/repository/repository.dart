import 'package:meteor/blocs/LocalityBloc.dart';
import 'package:meteor/blocs/WeatherBloc.dart';

class Repository{
  static String apiKey="119782608f55fc00e6846c42d3929677";
  static WeatherBloc blocWeather=WeatherBloc();
  static LocalityBloc blocLocality=LocalityBloc();
  static dynamic Locality;
}
