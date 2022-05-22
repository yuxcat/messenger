import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:messenger/models/msg_model.dart';
import 'package:messenger/models/user_model.dart';
import 'package:messenger/services/toast.dart';
import 'package:messenger/supabase/db/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:supabase_flutter/supabase_flutter.dart';

class Data extends ChangeNotifier {
  // Streams
  // user stream
  final _socketResponse = StreamController<List>();

  //void Function(List<dynamic>) get addResponse => _socketResponse.sink.add;

  Stream<List<UserModel>> get getResponse => _socketResponse.stream
      .map((event) => event.map((e) => UserModel.fromMap(e)).toList());

  /*Stream<List<UserModel>> userStream() {
    return getResponse
        .map((event) => event.map((e) => UserModel.fromMap(e)).toList());
  } */

  // States

  bool usernameSelected = false;
  late String signeduser;

  // messages
  List<MsgModel> _messages = [];
  List<MsgModel> get messages => _messages;
  set messages(List<MsgModel> val) {
    print("msg setter triggered");
    _messages = val;
    notifyListeners();
  }

  // socketter
  late IO.Socket _socket;
  IO.Socket get socket => _socket;
  set socket(IO.Socket value) {
    _socket = value;
    notifyListeners();
  }

  // validations
  bool userSelected = true;
  String _currentUser = "";
  String get currentUser => _currentUser;
  set currentUser(String value) {
    setMessages.clear();
    _currentUser = value;
    newMsg = '';

    for (var v in messages) {
      if (v.from == value || v.from == uid) {
        setMsg(v.from, v.msg, v.to);
        print("looped");
      }
    }

    notifyListeners();
  }

  List<MsgModel> _setMessages = [];
  List<MsgModel> get setMessages => _setMessages;
  set setMessages(List<MsgModel> val) {
    _setMessages = val;
    notifyListeners();
  }

  Future<void> setMsg(from, msg, to) async {
    setMessages.insert(0, MsgModel(from: from, msg: msg, to: to));
    notifyListeners();
  }

  // clients
  var map = {};

  Data() {
    getUser();
  }

  Future<void> getUser() async {
    var user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final String id = Supabase.instance.client.auth.currentUser!.id;
      final String? email = Supabase.instance.client.auth.currentUser!.email;
      final Database _db = Database();
      final String role = await _db.getRole();
      await connectToServer(email, id, role);
    } else {
      log("Connection failed");
    }
  }

  // connector

  Future<void> connectToServer(username, authid, role) async {
    try {
      passRole();
      //test area
      //final Database _db = Database();
      //await _db.fetchData();

      //test area ends

      // init
      socket = IO.io('http://127.0.0.1:3005', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('dispatch', handleMsg);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
      // socket.on('send_message', sent);
      // handler
      socket.on('users', handleUsers);
      // sessions\
      socket.on('session', storeSession);
      socket.on('user_connected', (data) => print(data));
      socket.on('self', selfControl);
      // init ends

      final prefs = await SharedPreferences.getInstance();

      // getter
      late String name = username;

      final String? id = prefs.getString('sessionID');

      if (id != null) {
        socket.auth = {"sessionID": id};
        socket.connect();
        usernameSelected = true;
      } else {
        print("ID.......:" + role);
        socket.auth = {"username": username, "uid": authid, "role": role};
        usernameSelected = true;
        socket.connect();
        log("session not detected");
      }
      notifyListeners();
      // Handle socket events

      // stream
      //socket.on('users', (data) => kok.socketResponse.sink.add(data));

      // catcher
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

// Session Emitter

  Future<void> storeSession(data) async {
    final prefs = await SharedPreferences.getInstance();
    String sid = data['sessionID'];
    uid = data['userID'];
    await prefs.setString('sessionID', sid);

    notifyListeners();
  }

  // userid by session emitter
  String _uid = "";
  String get uid => _uid;
  set uid(String fromSession) {
    _uid = fromSession;
    notifyListeners();
  }

  Future<void> specSend(String username, String msg) async {
    String to = map[username];

    socket.emit("message", {
      "to": to,
      "content": msg,
    });
  }

  // Listen to all message events from connected users
  void handleUsers(data) {
    messages.clear();
    setMessages.clear();
    map = {
      for (var v in data) v['username'].toString(): v['userID'].toString()
    };

    // storing messages on messages obj
    for (var v in data) {
      for (var msg in v['messages']) {
        addMsg(msg['from'], msg['content'], msg['to']);
        notifyListeners();
      }
    }

    List<dynamic> list1 = ['lecturer'];
    List<dynamic> list2 = data;
    List<dynamic> list3 =
        list2.where((map) => list1.contains(map['type'])).toList();

    //list2.where((element) => element['type'] == "lecturer").toList();

    // filtering data
    // otehwise just add to sink

    if (isLec == false) {
      print("executed false............");
      _socketResponse.sink.add(list3);
    } else {
      _socketResponse.sink.add(data);
    }
    notifyListeners();
  }

  // List msges = [];

  String _newMsg = "";
  String get newMsg => _newMsg;
  set newMsg(String from) {
    _newMsg = from;
    notifyListeners();
  }

  void handleMsg(data) async {
    var msg = MsgModel.fromJson(data);

    if (userSelected == true && msg.from == currentUser) {
      await addMsg(msg.from, msg.msg, msg.to);
    } else {
      await addMsg(msg.from, msg.msg, msg.to);
    }

    newMsg = msg.from;
    notifyListeners();
  }

  Future<void> addMsg(from, msg, to) async {
    messages.insert(0, MsgModel(from: from, msg: msg, to: to));
    setMessages.insert(0, MsgModel(from: from, msg: msg, to: to));
    print("message added....");
    notifyListeners();
  }

  @override
  void dispose() {
    socket.disconnect();
    _socketResponse.close();
    super.dispose();
  }

  Future<void> selfControl(data) async {
    var msg = MsgModel.fromJson(data);

    final String signedUser = uid;
    if (msg.from == signedUser) {
      await addMsg(msg.from, msg.msg, msg.to);
    } else {
      toast("self control error");
    }
  }

  bool _isLec = false;
  bool get isLec => _isLec;
  set isLec(bool value) {
    _isLec = true;
    notifyListeners();
  }

  void passRole() async {
    Database _db = Database();
    if (await _db.getRole() != "student") {
      isLec = true;
      print(isLec);
    }
  }
}
