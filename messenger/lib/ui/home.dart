import 'package:flutter/material.dart';
import 'package:messenger/forum/ui/posts.dart';
import 'package:messenger/models/user_model.dart';
import 'package:messenger/services/data.dart';
import 'package:messenger/supabase/auth/auth.dart';

import 'package:messenger/ui/texting_ui.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var link = Provider.of<Data>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger"),
        automaticallyImplyLeading: false,
        actions: [_logOutButton(context)],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // stream
            StreamProvider<List<UserModel>>.value(
                value: link.getResponse,
                initialData: const [],
                child: const UsersList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: const Icon(Icons.account_circle),
        onPressed: () {},
      ),
    );
  }

  Widget _logOutButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        Auth _auth = Auth();
        await _auth.out();
      },
      icon: const Icon(Icons.logout),
    );
  }
}

class UsersList extends StatelessWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List userList = Provider.of<List<UserModel>>(context);
    var link = Provider.of<Data>(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: userList.length,
      itemBuilder: (_, int index) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: ListTile(
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostsUI(
                              user: userList[index].id.toString(),
                            )),
                  );
                },
                icon: const Icon(Icons.forum_rounded)),
            title: Text(
              userList[index].username,
            ),
            subtitle: Text(userList[index].id),
            trailing: Stack(
              children: <Widget>[
                Icon(Icons.trip_origin,
                    color: userList[index].connected == true
                        ? Colors.green
                        : Colors.grey),
                // using consumer to avoid full rebuilds
                Consumer<Data>(
                    builder: ((context, value, child) =>
                        value.newMsg == userList[index].id.toString()
                            ? Positioned(
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const Text("")))
              ],
            ),
            onTap: () async {
              link.currentUser = userList[index].id.toString();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TextingUI(
                          name: userList[index].username.toString(),
                        )),
              );
            },
            dense: true,
          ),
        ),
      ),
    );
  }
}
