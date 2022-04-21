import 'package:flutter/material.dart';
import 'package:messenger/services/data.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.username}) : super(key: key);

  final String username;
  @override
  Widget build(BuildContext context) {
    Data data = Data();
    data.connectToServer(username);

    TextEditingController to = TextEditingController();
    TextEditingController msg = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("suck my dick"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              // field
              TextField(
                controller: to,
              ),
              TextField(controller: msg),

              // btn
              OutlinedButton(
                  onPressed: () async {
                    await data.specSend(to.text, msg.text);
                  },
                  child: const Text("CLick Bitch")),

              // stream
              StreamBuilder<dynamic>(
                  stream: data.kok.getResponse,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Loading....');
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text('Result: ${snapshot.data}');
                        }
                    }
                  })
            ],
          ),
        ));
  }
}
