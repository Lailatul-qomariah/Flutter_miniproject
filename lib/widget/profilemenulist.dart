import 'package:miniproject/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/models/profilmodel.dart';
// import 'package:miniproject/pages/profilelist.dart';
// import '../models/profilemodel.dart';
import '../style.dart';

class ProfileMenuList extends StatelessWidget {
  final String label;
  final String page;
  final IconData icon;
  final Profile profile;
  final double paddingLeft;
  final VoidCallback? onTap;

  const ProfileMenuList({
    Key? key,
    required this.page,
    required this.label,
    required this.icon,
    required this.profile,
    this.onTap,
    this.paddingLeft = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          profile: profile,
                          viewType: page,
                        )));
          },
      child: IgnorePointer(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: paddingLeft,
                ),
                Icon(
                  icon,
                  size: 20,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Container(
                  padding:
                      EdgeInsets.only(left: 0, right: 15, bottom: 15, top: 15),
                  child: Text(label, style: Styles.Text16),
                )),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Styles.lightgrey,
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
