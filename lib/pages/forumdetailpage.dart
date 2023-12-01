import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/models/forummodel.dart';
import 'package:miniproject/models/postmodel.dart';
import 'package:miniproject/provider/forumprovider.dart';
import 'package:miniproject/style.dart';
import 'package:miniproject/widget/menu.dart';

class ForumDetailPage extends StatefulWidget {
  final String forumId;

  const ForumDetailPage({
    Key? key,
    required this.forumId,
  }) : super(key: key);
  @override
  State<ForumDetailPage> createState() => _ThreadDetailPageState();
}

class _ThreadDetailPageState extends State<ForumDetailPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late ForumProvider forumProvider;
  Forum? thread;
  List<Post>? posts;
  String? formattedTimestamp;

  @override
  void initState() {
    super.initState();
    forumProvider = ForumProvider();
    fetchthread();
    super.initState();
  }

  Future<void> fetchthread() async {
    try {
      dynamic response = await onGetdetailThread(context, widget.forumId);
      if (response != null && response['message'] == 'Success') {
        Map<String, dynamic> threadData = response['data'];
        setState(() {
          thread = Forum.fromJson(threadData);
          DateTime timestamp = DateTime.parse(thread!.createdAt);
          formattedTimestamp = DateFormat(']MMM d').format(timestamp);
        });
      } else {
        print("Error fetching thread: Invalid response format");
        // Handle error appropriately, e.g., show an error message to the user
      }
    } catch (error) {
      print("Error fetching thread: $error");
      // Handle error appropriately, e.g., show an error message to the user
    }
    await onGetListPost(context, widget.forumId, 1).then((jsonList) {
      if (jsonList != null && jsonList is List<dynamic>) {
        setState(() {
          posts = jsonList.map((item) => Post.fromJson(item)).toList();
        });
      } else {
        print("Error: Invalid JSON data format");
      }
    }).catchError((error) {
      print("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (thread == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
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
            showProfileMenu: ModalRoute.of(context)?.settings.name == '/forum'),
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                    decoration: const BoxDecoration(
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
              Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: Styles.Text16,
                                  children: <TextSpan>[
                                TextSpan(
                                    text: "Dibuat Oleh ",
                                    style: TextStyle(
                                        color: Color.fromRGBO(93, 93, 93, 1),
                                        fontFamily: "Inter",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: thread!.author!.name,
                                    style: TextStyle(
                                        color: Color.fromRGBO(48, 86, 211, 1),
                                        fontFamily: "Inter",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                              ])),
                          SizedBox(
                            width: 20,
                          ),
                          Text(formattedTimestamp!,
                              style: TextStyle(
                                  color: Color.fromRGBO(93, 93, 93, 1),
                                  fontFamily: "Inter",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        thread!.title,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter"),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        thread!.content,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Color.fromRGBO(93, 93, 93, 1),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                  width: 25,
                                  child: Text('${thread!.totalViews}')),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.forum_outlined,
                                color: Color.fromRGBO(93, 93, 93, 1),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                  width: 25,
                                  child: Text(
                                    '${thread!.totalPostComments}',
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Berikan Komentar",
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            onSubmitted: (value) {
                              onCreatePost(context, widget.forumId, value);
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(209, 213, 219, 1)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(209, 213, 219, 1)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                hintText: "Inputan",
                                hintStyle: Styles.inputTextHintDefaultTextStyle,
                                filled: true,
                                fillColor: Color.fromRGBO(249, 250, 251, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: posts?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(posts![index].author.name,
                                    style: TextStyle(
                                        color: Color.fromRGBO(48, 86, 211, 1),
                                        fontFamily: "Inter",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              posts![index].content,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Icon(
                            //       Icons.remove_red_eye_outlined,
                            //       color: Color.fromRGBO(93, 93, 93, 1),
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     SizedBox(
                            //         width: 25, child: Text('${widget.viewer}')),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<dynamic> onGetdetailThread(BuildContext context, String id) async {
    dynamic result = await forumProvider.getforumdetail(id);

    if (result != null && result['message'] == "Success") {
      return result;
    } else {
      print("error123");
    }
  }

  Future<dynamic> onCreatePost(
      BuildContext context, String id, String content) async {
    dynamic result = await forumProvider.createpost(id, content);

    if (result != null && result['message'] == "Success") {
      print("post success");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ForumDetailPage(forumId: id)));
    } else {
      print("error123");
    }
  }

  Future<dynamic> onGetListPost(
      BuildContext context, String id, int page) async {
    dynamic result = await forumProvider.getlistpost(id, page);

    if (result != null && result['message'] == "Success") {
      return result["data"];
    } else {
      print("error123");
    }
  }
}
