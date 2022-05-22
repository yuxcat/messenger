import 'package:flutter/cupertino.dart';
import 'package:messenger/admin/up.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _mail = TextEditingController();
    TextEditingController _pw = TextEditingController();
    TextEditingController _name = TextEditingController();
    return Column(
      children: <Widget>[
        CupertinoFormSection.insetGrouped(
            header: const Text('Lecturer Sign Up'),
            children: [
              CupertinoTextFormFieldRow(
                controller: _name,
                prefix: const Icon(CupertinoIcons.mail),
                placeholder: 'name',
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              CupertinoTextFormFieldRow(
                controller: _mail,
                prefix: const Icon(CupertinoIcons.mail),
                placeholder: 'email',
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              CupertinoTextFormFieldRow(
                controller: _pw,
                prefix: const Icon(CupertinoIcons.padlock),
                placeholder: 'password',
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ]),
        Padding(
          padding: const EdgeInsets.all(30.00),
          child: CupertinoButton.filled(
            onPressed: () async {
              AdminAuth _auth = AdminAuth();
              await _auth.signUp(_mail.text, _pw.text, _name.text);
            },
            child: const Text('Sign up'),
          ),
        ),
      ],
    );
  }
}
