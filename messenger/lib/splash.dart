import 'package:flutter/material.dart';
import 'package:messenger/ui/auth_ui.dart';
import 'package:messenger/ui/home.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// navigator

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late var user = Supabase.instance.client.auth.currentUser;

    return SplashScreenView(
      navigateRoute: user != null ? const Home() : const AuthUI(),
      duration: 3000,
      imageSize: 130,
      imageSrc: "lib/assets/loading.gif",
      backgroundColor: Colors.white,
      // stylized
      text: "Messenger",
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40.0,
      ),
      colors: const [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
    );
  }
}
