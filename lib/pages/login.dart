import 'package:flutter/material.dart';
import 'package:miniproject/pages/article.dart';
import 'package:miniproject/pages/register.dart';
import 'package:miniproject/provider/authprovider.dart';
import 'package:miniproject/style.dart';
import 'package:miniproject/widget/custombutton.dart';
import 'package:miniproject/widget/custometextfield.dart';
import 'package:miniproject/widget/popupsuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _obscure = true;
  late AuthProvider authProvider;
  bool _ingatsaya = false;

  @override
  void initState() {
    _loadRememberMe();
    authProvider = AuthProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(60),
            width: double.infinity,
            height: 222,
            decoration: ShapeDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/banner.jpg"),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(113, 157, 223, 0.7), BlendMode.srcATop)),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
            ),
            child: Image.asset(
              "assets/logo.png",
            ),
          ),
          Column(
            children: [
              Text('Selamat Datang', style: Styles.text32),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(children: [
                  CustomTextField(
                    label: "Email",
                    controller: _email,
                    hint: "Masukkan Email",
                  ),
                  CustomTextField(
                    label: "Password",
                    controller: _password,
                    hint: "Masukkan Password",
                    obscureText: _obscure,
                    sufficIcon: IconButton(
                      icon: Icon(
                        Icons.visibility,
                        color: Styles.lightgrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _ingatsaya,
                            onChanged: (value) {
                              setState(() {
                                _ingatsaya = value!;
                              });
                            },
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          ),
                          const Text(
                            "Ingat Saya",
                            style: Styles.detailTextStyle,
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Lupa Password?",
                            style: Styles.linkTextStyle,
                          ))
                    ],
                  )
                ]),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(
                      label: 'Masuk',
                      minimumsize: Size.fromHeight(50),
                      onPressed: () {
                        print(_email.text);
                        onLogin(context);
                      },
                    ),
                    Text(
                      "Belum punya akun Metrodata Academy?",
                      style: Styles.text10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ));
                      },
                      child: Text(
                        "Daftar Sekarang!",
                        style: Styles.linktext10,
                      ),
                    )
                  ]))
        ],
      ),
    );
  }

  onLogin(BuildContext context) async {
    dynamic result = await authProvider.login(_email.text, _password.text);
    if (result != null && result["message"] == "Success") {
      PopupSuccess.alertDialog(
        context,
        message: "Berhasil Login",
        submessage: "Klik OK untuk Lanjut",
        onPressed: () {
          _saveRememberMe();
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ArticlePage()));
        },
      );
    } else if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result["message"]),
        duration: Duration(seconds: 3),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error!"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ingatsaya = prefs.getBool('rememberMe') ?? false;
      if (_ingatsaya) {
        _email.text = prefs.getString('email') ?? '';
        _password.text = prefs.getString('password') ?? '';
      }
    });
  }

  _saveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _ingatsaya);
    if (_ingatsaya) {
      prefs.setString('email', _email.text);
      prefs.setString('password', _password.text);
    }
  }
}
