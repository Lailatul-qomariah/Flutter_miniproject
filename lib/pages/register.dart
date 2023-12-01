import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/pages/login.dart';
import 'package:miniproject/provider/authprovider.dart';
import 'package:miniproject/style.dart';
import 'package:miniproject/widget/custombutton.dart';
import 'package:miniproject/widget/custometextfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _namaLengkap = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tanggalLahir = TextEditingController();
  String? _jenisKelamin;
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  bool obscurePassword = true;
  bool obscurePasswordConfirm = true;
  bool isPassword8c = true;
  bool isPasswordCapital = true;
  bool passwordComfrim = true;

  bool get isRegistrationEnabled =>
      _confirmPassword.text.isNotEmpty &&
      _password.text.isNotEmpty &&
      _namaLengkap.text.isNotEmpty &&
      _tanggalLahir.text.isNotEmpty &&
      _email.text.isNotEmpty &&
      _userName.text.isNotEmpty &&
      _jenisKelamin != null &&
      isPassword8c &&
      isPasswordCapital &&
      passwordComfrim;

  late AuthProvider authProvider;
  @override
  void initState() {
    authProvider = AuthProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 15,
      ),
      child: ListView(
        children: [
          Text(
            "Daftar Akun Baru",
            style: Styles.text32,
          ),
          SizedBox(
            height: 30,
          ),
          CustomTextField(
              label: "Nama Lengkap",
              hint: "Nama Lengkap",
              controller: _namaLengkap),
          SizedBox(
            height: 15,
          ),
          CustomTextField(
              label: "Username", hint: "Username", controller: _userName),
          SizedBox(
            height: 15,
          ),
          CustomTextField(label: "Email", hint: "Email", controller: _email),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextField(
                  label: "Tanggal Lahir",
                  hint: "YYYY-MM-DD",
                  controller: _tanggalLahir,
                  sufficIcon: IconButton(
                    onPressed: () {
                      SelectDate(context);
                    },
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jenis Kelamin",
                    style: Styles.labelTextField,
                  ),
                  DropdownButtonFormField<String>(
                    value: _jenisKelamin,
                    onChanged: (value) {
                      setState(() {
                        _jenisKelamin = value;
                      });
                    },
                    items: ['Laki-Laki', 'Perempuan'].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        hintText: "Pilih",
                        filled: true,
                        fillColor: Styles.bgtextField),
                  ),
                ],
              ))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomTextField(
            label: "Password",
            hint: "Masukkan Password",
            controller: _password,
            onChange: (value) {
              setState(() {
                checkPassword(value);
              });
            },
            obscureText: obscurePassword,
            sufficIcon: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: Styles.lightgrey,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                }),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              if (isPassword8c == false)
                Expanded(
                    child: RichText(
                  text: TextSpan(style: Styles.text10, children: [
                    TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                    TextSpan(text: "Panjang minimal 8 karakter"),
                  ]),
                )),
              if (isPassword8c == false)
                Expanded(
                    child: RichText(
                  text: TextSpan(style: Styles.text10, children: [
                    TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                    TextSpan(
                        text:
                            "Password harus mengandung minimal 1 hurus kapital"),
                  ]),
                ))
            ],
          ),
          CustomTextField(
            label: "Confirm Password",
            hint: "Masukkan Confirm Password",
            controller: _confirmPassword,
            onChange: (value) {
              setState(() {
                if (_password.text != value) {
                  passwordComfrim = false;
                } else {
                  passwordComfrim = true;
                }
              });
            },
            obscureText: obscurePasswordConfirm,
            sufficIcon: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: Styles.lightgrey,
                ),
                onPressed: () {
                  setState(() {
                    obscurePasswordConfirm = !obscurePasswordConfirm;
                  });
                }),
          ),
          if (passwordComfrim == false)
            RichText(
              text: TextSpan(style: Styles.text10, children: [
                TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                TextSpan(text: "Password tidak sama"),
              ]),
            ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
            label: 'Daftar',
            onPressed: () {
              print(_password.text);
              onRegister(context);
            },
          )
        ],
      ),
    ));
  }

  Future<void> SelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _tanggalLahir) {
      final formattedDate = DateFormat("yyyy-MM-dd").format(picked);
      setState(() {
        _tanggalLahir.text = formattedDate;
      });
    }
  }

  checkPassword(String password) {
    bool _isPassword8c = password.length >= 8;
    bool _isPasswordCapital = password.contains(RegExp(r'[A-Z]'));
    isPassword8c = _isPassword8c;
    isPasswordCapital = _isPasswordCapital;
  }

  onRegister(BuildContext context) async {
    if (isRegistrationEnabled) {
      dynamic result = await authProvider.register(
          _email.text,
          _userName.text,
          _jenisKelamin!,
          _tanggalLahir.text,
          _password.text,
          _namaLengkap.text);
      if (result != null && result["message"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Register Successed"),
          duration: Duration(seconds: 3),
        ));
        Navigator.of(context)
            .pop(MaterialPageRoute(builder: (context) => const LoginPage()));
      } else if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result["Failed"]),
          duration: Duration(seconds: 3),
        ));
      } else if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result["message"]),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      print("register gagal");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please fill all field !"),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
