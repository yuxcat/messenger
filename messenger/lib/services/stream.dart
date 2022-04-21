import 'dart:async';

class StreamSocket {
  final socketResponse = StreamController<dynamic>();

  //void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => socketResponse.stream;

  void dispose() {
    socketResponse.close();
  }
}