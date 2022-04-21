import 'package:messenger/services/stream.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Data {
  // instance
  final StreamSocket kok = StreamSocket();
  //final String username;

  // Constructor
  //Data({required this.username});

  // socketter
  IO.Socket socket = IO.io('http://127.0.0.1:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // clients
  var map = {};

  // connector

  void connectToServer(username) async {
    try {
      // Connect to websocket
      socket.auth = {"username": username};
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('location', handleLocationListen);
      socket.on('typing', handleTyping);
      socket.on('message', handleMsg);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
      socket.on('send_message', sent);
      // handler
      socket.on('users', handleMessage);

      // stream
      socket.on('users', (data) => kok.socketResponse.sink.add(data));

      // catcher
    } catch (e) {
      print(e.toString());
    }
  }

  // Send Location to Server
  void sendLocation(Map<String, dynamic> data) {
    socket.emit("location", data);
  }

  // Listen to Location updates of connected usersfrom server
  handleLocationListen(data) async {
    print(data);
  }

  // Send update of user's typing status
  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

  // Listen to update of typing status from connected users
  void handleTyping(data) {
    print(data);
  }

  // Send a Message to the server
  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  specSend(String username, String msg) {
    String to = map[username];
    print(to);

    socket.emit("send_message", {
      "to": to,
      "content": msg,
    });
  }

  // Listen to all message events from connected users
  void handleMessage(data) {
    // print(data[0]['userID'].toString());

    // mapper
    print(data.runtimeType);

    map = {
      for (var v in data) v['username'].toString(): v['userID'].toString()
    };
    print(map);
  }

  void handleMsg(data) {
    print(data);
  }

  void sent(data) {
    print(data);
  }
}
