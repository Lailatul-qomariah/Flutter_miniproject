import 'package:flutter/material.dart';
import 'package:miniproject/models/profilmodel.dart';
import 'package:miniproject/pages/login.dart';
import 'package:miniproject/provider/profileprovider.dart';
import 'package:miniproject/session.dart';
import 'package:miniproject/style.dart';
import 'package:miniproject/widget/menu.dart';
import 'package:miniproject/widget/profilemenulist.dart';

class ProfileMenuPage extends StatefulWidget {
  const ProfileMenuPage({Key? key}) : super(key: key);

  State<ProfileMenuPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileMenuPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ProfileProvider _profileProvider;
  Profile? profile;

  @override
  void initState() {
    _profileProvider = new ProfileProvider();
    fetchprofile();
    super.initState();
  }

  Future<void> fetchprofile() async {
    try {
      dynamic response = await _profileProvider.getprofile();

      if (response != null && response['message'] == 'Success') {
        Map<String, dynamic> profileData = response['data'];
        setState(() {
          profile = Profile.fromJson(profileData);
        });
      } else {
        print("Error fetching profile: Invalid response format");
        // Handle error appropriately, e.g., show an error message to the user
      }
    } catch (error) {
      print("Error fetching profile: $error");
      // Handle error appropriately, e.g., show an error message to the user
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white),
      );
    } else {
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
        body: ListView(children: [
          Container(
            color: Color.fromRGBO(241, 245, 253, 1),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: Styles.HeaderText,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CircleAvatar(
                        minRadius: 30,
                        maxRadius: 50,
                        backgroundImage: profile!.profilePicture != null
                            ? FadeInImage(
                                placeholder: AssetImage(
                                    "assets/logo.png"), // Placeholder ketika gambar sedang diambil
                                image: NetworkImage(profile!.profilePicture!),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ).image
                            : null,
                        child: profile!.profilePicture == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                              )
                            : null),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      profile!.name!,
                      style: Styles.Text16,
                    )
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                ProfileMenuList(
                  label: "Data Pribadi",
                  icon: Icons.person,
                  page: 'datapribadi',
                  profile: profile!,
                ),
                ProfileMenuList(
                  label: "Data Akun",
                  icon: Icons.dataset,
                  page: 'dataAkun',
                  profile: profile!,
                ),
                ProfileMenuList(
                  label: "Email Langganan",
                  icon: Icons.mail,
                  page: "suscribe",
                  profile: profile!,
                ),
                ProfileMenuList(
                  label: "keluar",
                  icon: Icons.logout,
                  page: "",
                  profile: profile!,
                  onTap: () async {
                    print("object");
                    await Session.logout(Session.tokenSessionKey);
                    print("aa");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ]),
      );
    }
  }
}
