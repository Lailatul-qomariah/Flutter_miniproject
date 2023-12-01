import 'package:flutter/material.dart';
import 'package:miniproject/models/forummodel.dart';
import 'package:miniproject/pages/forumdetailpage.dart';
import 'package:miniproject/pages/newforumpage.dart';
import 'package:miniproject/provider/forumprovider.dart';
import 'package:miniproject/widget/menu.dart';

import '../style.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ForumProvider forumprovider;
  late List<Forum> forums = [];
  late bool isLoading = true;

  @override
  void initState() {
    forumprovider = new ForumProvider();
    onGetListForum(context, 1, "", "").then((jsonList) {
      print(jsonList);
      if (jsonList != null && jsonList is List<dynamic>) {
        setState(() {
          forums = jsonList.map((item) => Forum.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print("Error: Invalid JSON data format");
      }
    }).catchError((error) {
      print("Error: $error");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (forums.isEmpty) {
        return Scaffold(
          backgroundColor: Styles.whiteblue,
          key: scaffoldKey,
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
          endDrawer: Menu(
              showProfileMenu:
                  ModalRoute.of(context)?.settings.name == '/forum'),
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: Styles.blue,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForumBaruPage()));
              print('Tombol tambah ditekan!');
            },
            tooltip: 'Buat artikel Baru', // Teks tooltip saat FAB ditekan lama
            child: Icon(
              Icons.add,
              size: 40,
            ), // Ikon tambah
          ),
          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "Forums belum tersedia",
                  style: TextStyle(fontSize: 48),
                  textAlign: TextAlign.center,
                ),
              )),
        );
      } else {
        return Scaffold(
          backgroundColor: Color.fromRGBO(246, 246, 246, 1),
          key: scaffoldKey,
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: Styles.blue,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForumBaruPage()));
              print('Tombol tambah ditekan!');
            },
            tooltip: 'Buat Forum Baru', // Teks tooltip saat FAB ditekan lama
            child: Icon(
              Icons.add,
              size: 40,
            ), // Ikon tambah
          ),
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
          endDrawer: Menu(
              showProfileMenu:
                  ModalRoute.of(context)?.settings.name == '/newforum'),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(
                              243, 244, 246, 1), // Container background color
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          border: Border.all(
                              color: Color.fromRGBO(222, 222, 223, 1))),
                      child: IconButton(
                        icon: Icon(Icons.filter_alt_outlined),
                        onPressed: () {
                          // Add your action here when the suffix button is pressed
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Styles.bgcolor,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: 'Enter text',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.zero),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(222, 222, 223, 1))),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(222, 222, 223, 1)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(
                            48, 86, 211, 1), // Container background color
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search, color: Styles.bgcolor),
                        onPressed: () {
                          // Add your action here when the suffix button is pressed
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: forums.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForumDetailPage(
                                          forumId: forums[index].id,
                                        )));
                          },
                          child: Card(
                            margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    forums[index].title.toString(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Inter"),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '${forums[index].content}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              style: Styles.Text16,
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: "Dibuat Oleh ",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        93, 93, 93, 1),
                                                    fontFamily: "Inter",
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            TextSpan(
                                                text:
                                                    forums[index].author!.name,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        48, 86, 211, 1),
                                                    fontFamily: "Inter",
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400))
                                          ])),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color:
                                                Color.fromRGBO(93, 93, 93, 1),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                              width: 25,
                                              child: Text(
                                                  '${forums[index].totalViews}')),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('${forums[index].createdAt}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(93, 93, 93, 1),
                                              fontFamily: "Inter",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.forum_outlined,
                                            color:
                                                Color.fromRGBO(93, 93, 93, 1),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                              width: 25,
                                              child: Text(
                                                '${forums[index].totalPostComments}',
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  onGetListForum(
      BuildContext context, int page, String filterby, String keyword) async {
    dynamic result = await forumprovider.getlistforums(page, filterby, keyword);

    if (result != null && result['message'] == "Success") {
      print(result["data"]);
      return (result["data"]);
    } else {
      print("error123");
    }
  }
}
