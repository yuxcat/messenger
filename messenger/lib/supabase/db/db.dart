import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:messenger/forum/models/post_model.dart';
import 'package:messenger/forum/models/replies_model.dart';
import 'package:messenger/services/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Database extends ChangeNotifier {
  // fetch posts list from sb
  Future<List<Post>> fetchData(String user) async {
    final response = await Supabase.instance.client
        .from('posts')
        .select()
        .eq('belongs', user)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => Post.toNote(e)).toList();
    } else {
      log('Error fetching threads: ${response.error!.message}');
      return [];
    }
  }

  // fetch 1 post

  Future<List<Post>> onePost(int postid) async {
    final response = await Supabase.instance.client
        .from('posts')
        .select()
        .eq('id', postid)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => Post.toNote(e)).toList();
    } else {
      log('Error fetching one post: ${response.error!.message}');
      return [];
    }
  }

  // realtime stream from replies
  // enable realtime for tables via sb studio
  Stream<List<Reply>> fetchReplies(int threadId) {
    var response = Supabase.instance.client
        .from('replies:thread=eq.$threadId')
        .stream(['id']).execute();
    return response.map((event) => event.map((e) => Reply.toReply(e)).toList());
  }

  // adding threads
  Future<void> addThread(String title, String content, String belongs) async {
    final String id = Supabase.instance.client.auth.currentUser!.id;
    DateTime dt = DateTime.now();
    if (id.isNotEmpty) {
      final response = await Supabase.instance.client.from('posts').insert({
        'belongs': belongs,
        'createdby': id,
        'updated_at': dt.toIso8601String(),
        'title': title,
        'contents': content,
      }).execute();

      if (response.error == null) {
        response;
      } else {
        log('Error creating Thread: ${response.error!.message}');
      }
    } else {
      toast("ID is empty");
    }
  }

  // adding replies
  Future<void> addReply(String title, String content, int thread) async {
    final String id = Supabase.instance.client.auth.currentUser!.id;
    DateTime dt = DateTime.now();
    if (id.isNotEmpty) {
      final response = await Supabase.instance.client.from('replies').insert({
        'thread': thread,
        'createdby': id,
        'updated_at': dt.toIso8601String(),
        'title': title,
        'contents': content,
      }).execute();

      if (response.error == null) {
        response;
      } else {
        log('Error creating reply: ${response.error!.message}');
      }
    } else {
      toast("ID is empty");
    }
  }

  // worst type of code :3
  Future<String> getRole() async {
    final String id = Supabase.instance.client.auth.currentUser!.id;
    final response = await Supabase.instance.client
        .from('profiles')
        .select('role')
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.first['role'];
    } else {
      log('Error fetching role: ${response.error!.message}');
      return "";
    }
  }

  Map<String, dynamic> toPostgrest(String title, String contents,
          String createdby, int thread, DateTime dt) =>
      {
        'thread': thread,
        'title': title,
        'contents': contents,
        'createdby': createdby,
        'updated_at': dt,
      };

  Future<String> nameGetter(id) async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('name')
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.first['name'];
    } else {
      log('Error fetching role: ${response.error!.message}');
      return "";
    }
  }

  // delete reply
  Future<void> delReply(id) async {
    print(id);
    final response = await Supabase.instance.client
        .from('replies')
        .delete()
        .match({'id': id}).execute();
    if (response.error == null) {
      response;
    } else {
      log('Error Deleting : ${response.error!.message}');
    }
  }
}


/*

one times read

Future<List<Reply>> fetchReplies(int threadId) async {
    final response = await Supabase.instance.client
        .from('replies')
        .select()
        .eq('thread', threadId)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;
      return results.map((e) => Reply.toReply(e)).toList();
    }
    log('Error fetching notes: ${response.error!.message}');
    return [];
  }




*/
