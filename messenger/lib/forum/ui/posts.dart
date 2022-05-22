import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/forum/models/post_model.dart';
import 'package:messenger/forum/ui/addPost.dart';
import 'package:messenger/forum/ui/replies.dart';

import 'package:messenger/services/toast.dart';
import 'package:provider/provider.dart';

import '../../supabase/db/db.dart';
import 'package:get/get.dart';

class PostsUI extends StatelessWidget {
  const PostsUI({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  Widget build(BuildContext context) {
    var link = Provider.of<Database>(context, listen: false);
    Future<void> _addNote() async {
      //link.addThread(title, content, belongs);
    }

    var db = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threads'),
        actions: [_logOutButton(context)],
      ),
      body: ListView(
        children: [
          FutureBuilder<List<Post>>(
            future: db.fetchData(user),
            builder: (context, snapshot) {
              final notes = (snapshot.data ?? [])
                ..sort((x, y) => y.uptime.difference(x.uptime).inMilliseconds);
              return Column(
                children: notes.map(_toPostWidget).toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Start a thread'),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPost(
                      user: user,
                    )),
          );
        },
      ),
    );
  }

  Widget _logOutButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        toast("tyo");
      },
      icon: const Icon(Icons.logout),
    );
  }

  Widget _toPostWidget(Post post) {
    return Card(
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.contents),
        dense: true,
        onTap: () {
          Get.to(() => RepliesUI(postId: post.id));
          //Get.to(RepliesUI(postId: post.id));
        },
      ),
    );
  }

  Future showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("add Thread"),
        content: const Text("Are you sure you want to log out?"),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          CupertinoDialogAction(
              textStyle: const TextStyle(color: Colors.red),
              isDefaultAction: true,
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("Log out")),
        ],
      ),
    );
  }
}
