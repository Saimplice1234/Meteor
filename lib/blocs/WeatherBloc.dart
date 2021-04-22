import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meteor/blocs/bloc.dart';
import 'package:meteor/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends Bloc{

  Future weatherAPi(dynamic locality) async{
    String url="http://api.weatherstack.com/current?access_key=119782608f55fc00e6846c42d3929677&query=$locality";
    try {
      var response = await Dio().get(url);
      print(response.statusCode);
      if(response.statusCode == 200){sink.add(response.data);}
      print("haiti ${response.data}");
    } catch (e) {
      print(e);
    }
  }
  final _streamController=BehaviorSubject<Map<String,dynamic>>();
  Sink<Map<String,dynamic>> get sink=>_streamController.sink;
  Stream<Map<String,dynamic>> get stream=>_streamController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }
}
