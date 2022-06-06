import 'package:flutter/material.dart';
import 'package:messenger/services/data.dart';
import 'package:messenger/services/toast.dart';
import 'package:messenger/supabase/db/db.dart';
import 'package:messenger/ui/auth_ui.dart';
import 'package:messenger/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as data_provider;
import 'package:get/get.dart';

class Auth {
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    // provider instance
    var link = data_provider.Provider.of<Data>(context, listen: false);
    var db = data_provider.Provider.of<Database>(context, listen: false);

    final response = await Supabase.instance.client.auth
        .signIn(email: email, password: password);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      final String id = Supabase.instance.client.auth.currentUser!.id;
      final String role = await db.getRole();
      link.connectToServer(email, id, role);
    } else {
      toast(response.error.toString());
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    final response =
        await Supabase.instance.client.auth.signUp(email, password);

    if (response.error == null) {
      try {
        await Supabase.instance.client.from('profiles').insert({
          'id': response.data!.user!.id,
          'name': name,
          'email': response.data!.user!.email,
          'role': 'student',
        }).execute();
      } catch (e) {
        throw Exception(e);
      }
    } else {
      toast(response.error.toString());
    }
  }

  Future<void> out() async {
    await Supabase.instance.client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionID');
    Get.to(() => const AuthUI());
  }
}
