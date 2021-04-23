import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meteor/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';

class LocalityBloc extends Bloc{
  final _streamController=BehaviorSubject<String>();
  Sink<String> get sink=>_streamController.sink;
  Stream<String> get stream=>_streamController.stream;
  void addLocality(String local){
    sink.add(local);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }
}
