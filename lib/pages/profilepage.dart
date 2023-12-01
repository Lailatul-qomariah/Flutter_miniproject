import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/models/profilmodel.dart';
import 'package:miniproject/provider/profileprovider.dart';
import 'package:miniproject/widget/custombutton.dart';
import 'package:miniproject/widget/custometextfield.dart';
import 'package:miniproject/widget/imageutils.dart';
import 'package:miniproject/widget/menu.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../style.dart';

class ProfilePage extends StatefulWidget {
  final String viewType;
  final Profile profile;

  const ProfilePage({Key? key, required this.viewType, required this.profile})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<FormState>();
  late ProfileProvider _profileProvider;

  String? _jenisKelamin;
  bool _passwordconfirmed = true;
  bool _obsecuretext = true;
  bool _obsecuretext1 = true;
  bool _obsecuretext2 = true;
  bool _isPassword8c = true;
  bool get isPassword8c => _isPassword8c;
  bool _isPasswordcapital = true;
  bool get isPasswordcapital => _isPasswordcapital;
  File? profilePicture;
  String? profilePictureUrl;
  bool isLoading = false;
  String? resultupload;

//variable untuk mengisi data dari inputan
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _tanggalLahir = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _oldpassword = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _confirmnewpassword = TextEditingController();

//funtion untuk menyimpan data tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (pickedDate != null && pickedDate != _tanggalLahir) {
      final formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        _tanggalLahir.text = formattedDate;
      });
    }
  }

  void checkPassword(String password) {
    bool isPassword8c = password.length >= 8;
    bool isPasswordcapital = password.contains(RegExp(r'[A-Z]'));
    _isPassword8c = isPassword8c;
    _isPasswordcapital = isPasswordcapital;
  }

  @override
  void initState() {
    _profileProvider = ProfileProvider();
    getAccountSession();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//get data profile
  void getAccountSession() {
    Future.delayed(Duration.zero, () async {
      _name.text = widget.profile.name!;
      _username.text = widget.profile.username!;
      _jenisKelamin = widget.profile.jenisKelamin;
      profilePictureUrl = widget.profile.profilePicture!;
      _tanggalLahir.text = widget.profile.tanggalLahir!;
      _email.text = widget.profile.email!;
      _alamat.text = widget.profile.alamat!;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> child = [];
    if (widget.viewType == 'datapribadi') {
      child = datapribadi();
    } else if (widget.viewType == 'dataAkun') {
      child = dataakun();
    } else if (widget.viewType == 'suscribe') {
      child = Suscribe();
    }

    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Styles.bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Image.asset(
          "assets/logo.png",
          width: 150,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeEndDrawer();
                //close drawer, if drawer is open
              } else {
                scaffoldKey.currentState!.openEndDrawer();
                //open drawer, if drawer is closed
              }
            },
            icon: Icon(
              Icons.menu,
              size: 30,
            ),
            color: Styles.black,
          )
        ],
      ),
      endDrawer: Menu(showProfileMenu: true),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          child: Form(
            key: _key,
            child: ListView(
                padding: EdgeInsets.only(
                    top: 100,
                    left: size.width * 0.05,
                    right: size.width * 0.05),
                children: child),
          ),
        ), // Gantilah ini dengan widget konten Anda
        progressIndicator: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
              strokeWidth: 12,
              color: Styles.blue,
            )), // Gantilah ini dengan indikator progres yang sesuai
      ),
    );
  }

  List<Widget> datapribadi() {
    return <Widget>[
      Center(
        child: Text(
          "Informasi Pribadi",
          style: Styles.HeaderText,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
              minRadius: 30,
              maxRadius: 50,
              backgroundImage: profilePictureUrl != null
                  ? FadeInImage(
                      placeholder: AssetImage(
                          "assets/logo.png"), // Placeholder ketika gambar sedang diambil
                      image: NetworkImage(profilePictureUrl!),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ).image
                  : null,
              child: profilePictureUrl == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                    )
                  : null),
          SizedBox(
            width: 15,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                  label: "Ganti Foto",
                  onPressed: () async {
                    await ImageUtils.pickImage(context,
                        (File selectedImage) async {
                      setState(() {
                        isLoading =
                            true; // Setelah tombol ditekan, atur isLoading menjadi true
                      });
                      dynamic resultupload = await _profileProvider
                          .uploadprofileimage(selectedImage);
                      if (resultupload["message"] == "Success") {
                        setState(() {
                          profilePictureUrl = resultupload["data"];
                          isLoading =
                              false; // Setelah gambar diunggah, atur isLoading menjadi false
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(resultupload["message"]),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    });
                  },
                ),
                Text(
                  "JPG, GIF or PNG. 1MB max.",
                  style: Styles.detailTextStyle,
                )
              ])
        ],
      ),
      SizedBox(
        height: 20,
      ),
      CustomTextField(
        hint: "Nama",
        controller: _name,
        label: "Nama Lengkap",
      ),
      SizedBox(
        height: 20,
      ),
      CustomTextField(
        controller: _username,
        label: "Username",
        hint: 'Username',
      ),
      SizedBox(
        height: 20,
      ),
      CustomTextField(
        controller: _email,
        label: "Email",
        hint: 'Email',
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Expanded(
            child: CustomTextField(
              hint: "YYYY-DD-MM",
              controller: _tanggalLahir,
              readOnly: true,
              label: "Tanggal Lahir",
              sufficIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Styles.black,
                  onPressed: () => _selectDate(context)),
            ),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                      text: TextSpan(style: Styles.Text16, children: <TextSpan>[
                    TextSpan(text: "Gender "),
                    TextSpan(text: "*", style: TextStyle(color: Styles.red))
                  ])),
                  DropdownButtonFormField<String>(
                    value: _jenisKelamin,
                    onChanged: (String? newValue) {
                      setState(() {
                        _jenisKelamin = newValue;
                      });
                    },
                    items: <String>['Laki-laki', 'Perempuan', 'Lainnya']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        hintText: 'Pilih',
                        hintStyle: Styles.inputTextHintDefaultTextStyle,
                        filled: true,
                        fillColor: Styles.inputTextDefaultBackgroundColor),
                    style: Styles.inputTextDefaultTextStyle,
                  ),
                ]),
          ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      CustomTextField(
        controller: _alamat,
        label: "Alamat",
        hint: 'Masukan Alamat',
        // maxLines: 7,
      ),
      SizedBox(
        height: 20,
      ),
      CustomButton(
          label: "Simpan",
          onPressed: () {
            onUpdateProfile(context);
          })
    ];
  }

  List<Widget> dataakun() {
    return <Widget>[
      Center(
        child: Text(
          "Password",
          style: Styles.HeaderText,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTextField(
            hint: "Password Lama",
            controller: _oldpassword,
            label: "Password Lama",
            obscureText: _obsecuretext,
            sufficIcon: IconButton(
              icon: Icon(Icons.visibility),
              color: Styles.lightgrey,
              onPressed: () {
                setState(() {
                  _obsecuretext = !_obsecuretext;
                });
              },
            ),
          ),
          CustomTextField(
            hint: "Password Baru",
            controller: _newpassword,
            label: "Password Baru",
            obscureText: _obsecuretext1,
            onChanged: (_newpassword) => setState(() {
              checkPassword(_newpassword);
            }),
            sufficIcon: IconButton(
              icon: Icon(Icons.visibility),
              color: Styles.lightgrey,
              onPressed: () {
                setState(() {
                  _obsecuretext1 = !_obsecuretext1;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isPassword8c == false)
                // Show error message if password is not valid
                Expanded(
                  child: RichText(
                      text: TextSpan(style: Styles.Text16, children: <TextSpan>[
                    TextSpan(
                        text: "* ",
                        style: TextStyle(color: Styles.red, fontSize: 10)),
                    TextSpan(
                        text: "Panjang Minimal 8 Character",
                        style: Styles.detailTextStyle),
                  ])),
                ),
              if (isPasswordcapital ==
                  false) // Show error message if password is not valid
                Expanded(
                  child: RichText(
                      text: TextSpan(style: Styles.Text16, children: <TextSpan>[
                    TextSpan(
                        text: "* ",
                        style: TextStyle(color: Styles.red, fontSize: 10)),
                    TextSpan(
                        text: "Mengandung minimal 1 huruf kapital",
                        style: Styles.detailTextStyle),
                  ])),
                ),
            ],
          ),
          if (isPassword8c == false || isPasswordcapital == false)
            SizedBox(
              height: 25,
            )
        ],
      ),
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextField(
              hint: "Password",
              controller: _confirmnewpassword,
              label: "Password",
              obscureText: _obsecuretext2,
              onChanged: (_confirmnewpassword) => setState(() {
                if (_newpassword.text != _confirmnewpassword) {
                  _passwordconfirmed = false;
                }
                if (_newpassword.text == _confirmnewpassword) {
                  _passwordconfirmed = true;
                }
              }),
              sufficIcon: IconButton(
                icon: Icon(Icons.visibility),
                color: Styles.lightgrey,
                onPressed: () {
                  setState(() {
                    _obsecuretext2 = !_obsecuretext2;
                  });
                },
              ),
            ),
            if (_passwordconfirmed ==
                false) // Show error message if password is not valid
              RichText(
                  text: TextSpan(style: Styles.Text16, children: <TextSpan>[
                TextSpan(
                    text: "* ",
                    style: TextStyle(color: Styles.red, fontSize: 10)),
                TextSpan(
                    text: "Password tidak sama", style: Styles.detailTextStyle),
              ])),
          ]),
      SizedBox(
        height: 20,
      ),
      CustomButton(label: "Simpan", onPressed: () {}),
    ];
  }

  List<Widget> Suscribe() {
    return <Widget>[
      Center(
        child: Text(
          "Email Langganan",
          style: Styles.HeaderText,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "Disini kamu bisa mengatur Email Langganan yang ingin kamu terima sesuai dengan keinginanmu, Metrodata Academy akan mengirimkan email secara berkala yang berisikan promo, wawasan, dan lainnya. Klik produk dibawah ini untuk menerima email langganan :",
        style: Styles.detailTextStyle,
      ),
      SizedBox(
        height: 20,
      ),
      CustomButton(label: "Simpan", onPressed: () {}),
    ];
  }

  ///////////////////////////////
  onUpdateProfile(BuildContext context) async {
    dynamic resultcreate = await _profileProvider.updateprofile(
        _email.text,
        _username.text,
        _jenisKelamin!,
        _alamat.text,
        _tanggalLahir.text,
        _name.text,
        profilePictureUrl!);
    if (resultcreate != null && resultcreate['message'] == "Success") {
      Navigator.pushReplacementNamed(context, "/profilemenu");
    } else {
      print("error123");
    }
  }
}
