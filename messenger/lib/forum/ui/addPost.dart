import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/supabase/db/db.dart';
import 'package:provider/provider.dart';

class AddPost extends StatelessWidget {
  const AddPost({Key? key, required this.user}) : super(key: key);
  final String user;

  @override
  Widget build(BuildContext context) {
    var link = Provider.of<Database>(context, listen: false);
    TextEditingController _title = TextEditingController();
    TextEditingController _contents = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('new thread'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            CupertinoFormSection.insetGrouped(
                header: const Text('new thread'),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _title,
                    placeholder: 'title ...',
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 330.00,
                    child: CupertinoTextFormFieldRow(
                      controller: _contents,
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      placeholder: 'u say ....',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.all(30.00),
              child: CupertinoButton.filled(
                onPressed: () async {
                  await link.addThread(_title.text, _contents.text, user);
                },
                child: const Text('add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
