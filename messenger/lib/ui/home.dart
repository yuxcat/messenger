import 'package:flutter/material.dart';
import 'package:messenger/models/user_model.dart';
import 'package:messenger/services/data.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController to = TextEditingController();
    TextEditingController msg = TextEditingController();

    var link = Provider.of<Data>(context, listen: false);

    //
    List userList = Provider.of<List<UserModel>>(context);

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
                    await link.specSend(to.text, msg.text);
                  },
                  child: const Text("CLick Bitch")),

              // stream
              ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (_, int index) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: ListTile(
                      leading: const FlutterLogo(size: 56.0),
                      title: Text(
                        userList[index].id,
                      ),
                      subtitle: Text(
                        userList[index].username +
                            ' | ' +
                            userList[index].id.toString(),
                      ),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () {},
                      dense: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
