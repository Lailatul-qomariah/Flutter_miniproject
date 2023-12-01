import 'dart:async';
import 'package:miniproject/session.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/pages/login.dart';
import 'package:miniproject/pages/article.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkAccountData();
  }

  Future<void> checkAccountData() async {
    bool _isLogged =
        await Session.get(Session.tokenSessionKey) != null ? true : false;

    if (_isLogged) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ArticlePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
