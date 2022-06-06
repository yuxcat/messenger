import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/admin/up.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _mail = TextEditingController();
    TextEditingController _pw = TextEditingController();

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 30.00,
          ),
          CupertinoFormSection.insetGrouped(
              header: const Text('Login'),
              children: [
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
                  obscureText: true,
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
                await _auth.signIn(_mail.text, _pw.text);
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
