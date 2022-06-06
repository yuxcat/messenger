import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/forum/models/post_model.dart';
import 'package:messenger/forum/models/replies_model.dart';
import 'package:messenger/forum/ui/replies_streamUI.dart';
import 'package:messenger/supabase/db/db.dart';
import 'package:provider/provider.dart';

class RepliesUI extends StatelessWidget {
  const RepliesUI({Key? key, required this.postId}) : super(key: key);
  final int postId;

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Replies'),
      ),
      body: Column(children: <Widget>[
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            FutureBuilder<List<Post>>(
              future: db.onePost(postId),
              builder: (context, snapshot) {
                final notes = (snapshot.data ?? [])
                  ..sort(
                      (x, y) => y.uptime.difference(x.uptime).inMilliseconds);
                return Column(
                  children: notes.map(_toPostWidget).toList(),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10.00),
        _addReplyWidget(context),
        StreamProvider<List<Reply>>.value(
          initialData: const [],
          value: db.fetchReplies(postId),
          child: const ReplyStreamUI(),
        ),
      ]),
    );
  }

  Widget _toPostWidget(Post post) {
    return Card(
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.contents),
        dense: true,
      ),
    );
  }

  Future<void> _addNote() async {}

  Widget _addReplyWidget(BuildContext context) {
    TextEditingController _title = TextEditingController();
    TextEditingController _content = TextEditingController();

    return Card(
      child: ListTile(
        title: CupertinoTextFormFieldRow(
          controller: _title,
          placeholder: 'Title',
        ),
        subtitle: CupertinoTextFormFieldRow(
          controller: _content,
          placeholder: 'reply',
        ),
        dense: true,
        trailing: IconButton(
            onPressed: () async {
              var db = Provider.of<Database>(context, listen: false);
              db.addReply(_title.text, _content.text, postId);
            },
            icon: const Icon(CupertinoIcons.add)),
      ),
    );
  }
}
