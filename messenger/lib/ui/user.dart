import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/services/data.dart';
import 'package:messenger/ui/home.dart';
import 'package:provider/provider.dart';

class User extends StatelessWidget {
  const User({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    var link = Provider.of<Data>(context, listen: false);
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
                  onPressed: () async {
                    await connect(context, username.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
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

connect(context, String text) {
  var link = Provider.of<Data>(context, listen: false);
  link.connectToServer(text);
}
