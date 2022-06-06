import 'package:get/get.dart';
import 'package:messenger/admin/minimal.dart';
import 'package:messenger/services/toast.dart';
import 'package:messenger/supabase/db/db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAuth {
  Future<void> signUp(String email, String password, String name) async {
    final response =
        await Supabase.instance.client.auth.signUp(email, password);

    if (response.data == null) {
      try {
        await Supabase.instance.client.from('profiles').insert({
          'id': response.data!.user!.id,
          'name': name,
          'email': response.data!.user!.email,
          'role': 'lecturer',
        }).execute();
      } catch (e) {
        throw Exception(e);
      }
    } else {
      toast(response.error.toString());
    }
  }

  // admin
  Future<void> signIn(
    String email,
    String password,
  ) async {
    final response = await Supabase.instance.client.auth
        .signIn(email: email, password: password);
    if (response.error == null) {
      Database _db = Database();

      final String id = Supabase.instance.client.auth.currentUser!.id;
      final String role = await _db.getRole();
      if (id.isNotEmpty && role == "ADMin") {
        Get.to(() => const Admin());
      } else {
        toast("ayo not admin :( ");
      }
    } else {
      toast(response.error.toString());
    }
  }
}
