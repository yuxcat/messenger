import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/ui/home.dart';

class User extends StatelessWidget {
  const User({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.00),
        child: Column(
          children: <Widget>[
            // TEXTFIELD
            CupertinoTextField.borderless(
              controller: username,
            ),

            // BUTTON
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                username: username.text,
                              )),
                    );
                  },
                  child: const Text("Set Username")),
            )
          ],
        ),
      ),
    );
  }
}
