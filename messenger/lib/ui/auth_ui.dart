import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/admin/login.dart';
import 'package:messenger/models/scoped_segment.dart';
import 'package:provider/provider.dart';

import '../supabase/auth/auth.dart';
import 'package:get/get.dart';

class AuthUI extends StatelessWidget {
  const AuthUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScopedSegments scoped = ScopedSegments();

    Map<int, Widget> children = const <int, Widget>{
      0: Text("Signup"),
      1: Text("Login"),
    };

    List<Widget> widgets = [signupSegment(context), loginSegment(context)];

    return Scaffold(
      body: Material(
        child: Center(
          child: ChangeNotifierProvider<ScopedSegments>(
            create: (_) => scoped,
            child: Consumer<ScopedSegments>(
                builder: (context, value, child) => Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 50.00,
                        ),
                        SizedBox(
                          child: CupertinoSlidingSegmentedControl(
                              children: children,
                              groupValue: value.ssmodel.groupValue,
                              onValueChanged: (segment) async {
                                scoped.onChange(segment);
                              }),
                        ),

                        // segments here
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 10.00,
                              top: 20.00,
                              end: 10.00,
                              bottom: 5.00),
                          child: widgets[value.ssmodel.groupValue],
                        ),
                        // login
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: () {
                                  Get.to(() => const Login());
                                },
                                icon: const Icon(Icons.settings)),
                          ),
                        )
                      ],
                    )),
          ),
        ),
      ),
    );
  }

  // rest widgets

  Widget signupSegment(context) {
    TextEditingController _mail = TextEditingController();
    TextEditingController _pw = TextEditingController();
    TextEditingController _name = TextEditingController();
    return Column(
      children: <Widget>[
        CupertinoFormSection.insetGrouped(
            header: const Text('Sign Up'),
            children: [
              CupertinoTextFormFieldRow(
                controller: _name,
                prefix: const Icon(CupertinoIcons.person),
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
              await signUp(_mail.text, _pw.text, _name.text);
            },
            child: const Text('Sign up'),
          ),
        ),
      ],
    );
  }

  Future<void> signUp(String email, String password, String name) async {
    Auth _auth = Auth();
    await _auth.signUp(email, password, name);
  }

  // login segment
  Widget loginSegment(context) {
    TextEditingController _mail = TextEditingController();
    TextEditingController _pw = TextEditingController();

    return Column(
      children: <Widget>[
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
              await login(_mail.text, _pw.text, context);
            },
            child: const Text('Login'),
          ),
        ),
      ],
    );
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    Auth _auth = Auth();
    await _auth.signIn(email, password, context);
  }
}
