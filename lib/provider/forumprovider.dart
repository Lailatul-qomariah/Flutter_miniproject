import 'dart:convert';
import 'package:miniproject/provider/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miniproject/session.dart';

class ForumProvider extends ChangeNotifier {
  Future<dynamic> getlistforums(
      int page, String filterBy, String keyword) async {
    try {
      final url =
          Uri.parse('${Config.endPoint}/web-forum-service/threads/list');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                "Bearer ${await Session.get(Session.tokenSessionKey)}"
          },
          body: jsonEncode({
            'page': page,
            'filterBy': filterBy,
            'keyword': keyword,
          }));

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        return result;
      } else {
        return result;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }

  Future<dynamic> createforum(String title, String content) async {
    try {
      final url =
          Uri.parse('${Config.endPoint}/web-forum-service/threads/create');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                "Bearer ${await Session.get(Session.tokenSessionKey)}"
          },
          body: jsonEncode({
            'title': title,
            'content': content,
          }));

      print('${url} ${response.body}');

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        return result;
      } else {
        print(result);
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }

  Future<dynamic> getforumdetail(String id) async {
    try {
      final url =
          Uri.parse('${Config.endPoint}/web-forum-service/threads?id=$id');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer ${await Session.get(Session.tokenSessionKey)}"
        },
      );

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        return result;
      } else {
        return result;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }

  Future<dynamic> createpost(String idForums, String content) async {
    try {
      final url =
          Uri.parse('${Config.endPoint}/web-forum-service/threads/comment');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                "Bearer ${await Session.get(Session.tokenSessionKey)}"
          },
          body: jsonEncode({
            'idThreads': idForums,
            'content': content,
          }));

      print('${url} ${response.body}');

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        return result;
      } else {
        print(result);
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }

  Future<dynamic> getlistpost(String forumsId, int page) async {
    try {
      final url = Uri.parse(
          '${Config.endPoint}/web-forum-service/threads/comment?threadsId=$forumsId&page=$page');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer ${await Session.get(Session.tokenSessionKey)}"
        },
      );
      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        return result;
      } else {
        return result;
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return null; // Mengembalikan null jika terjadi kesalahan
    }
  }
}
