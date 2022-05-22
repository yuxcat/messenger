import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:messenger/services/data.dart';
import 'package:messenger/services/toast.dart';
import 'package:messenger/splash.dart';
import 'package:messenger/supabase/db/db.dart';

import 'package:provider/provider.dart';
// ui tests

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Data()),
        ChangeNotifierProvider(create: (context) => Database()),

        /* StreamProvider<List<MsgModel>>(
          initialData: [],
          create: (context) => Data().msgStream(),
        ) */
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: snackbarKey,
        home: const Splash(),
      ),
    );
  }
}
