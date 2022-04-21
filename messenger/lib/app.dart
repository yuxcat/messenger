import 'package:flutter/material.dart';
import 'package:messenger/ui/home.dart';
import 'package:messenger/ui/user.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      home: User(),
    );
  }
}
