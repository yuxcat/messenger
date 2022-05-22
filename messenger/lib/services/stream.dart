import 'dart:async';

class StreamSocket {
  final socketResponse = StreamController<dynamic>.broadcast();

  //void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => socketResponse.stream;

  // msg stream => list<string
  // this receives stream of string

  // final msgResponse = StreamController<List>();

  // Stream<dynamic> get getMsg => socketResponse.stream;
  /*
  Stream<List<MsgModel>> msgStream() {
    return msgResponse.stream.map((event) =>
        event.map((e) => MsgModel.fromMap(e)).toList(growable: true));
  } */

  void dispose() {
    socketResponse.close();
  }
}
