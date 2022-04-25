import 'package:flutter/material.dart';
import 'package:messenger/models/user_model.dart';
import 'package:messenger/services/data.dart';
import 'package:messenger/ui/user.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Data()),
        StreamProvider<List<UserModel>>(
            initialData: [], create: (context) => Data().userStream())
      ],
      child: const MaterialApp(
        home: User(),
      ),
    );
  }
}
