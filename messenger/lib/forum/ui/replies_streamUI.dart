import 'package:flutter/material.dart';
import 'package:messenger/forum/models/replies_model.dart';
import 'package:messenger/supabase/db/db.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class ReplyStreamUI extends StatelessWidget {
  const ReplyStreamUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List reply = Provider.of<List<Reply>>(context);
    Database _db = Database();
    final String id = sb.Supabase.instance.client.auth.currentUser!.id;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: reply.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, int index) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: ListTile(
                // name fetcher
                leading: FutureProvider<String>(
                  create: (_) => _db.nameGetter(reply[index]?.createdby),
                  initialData: "",
                  child: Consumer<String>(
                      builder: ((context, value, child) => Text(
                            value.toString(),
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ))),
                ),
                title: Text(reply[index]?.title),
                subtitle: Text(reply[index]?.contents),
                // enabling delete
                trailing: reply[index]?.createdby == id
                    ? IconButton(
                        onPressed: () async {
                          await _db.delReply(reply[index].id);
                        },
                        icon: const Icon(Icons.delete_outlined))
                    : Text(reply[index].uptime.toString()),
                dense: true,
              ),
            )),
      ),
    );
  }
}
