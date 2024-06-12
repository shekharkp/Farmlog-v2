import 'package:farmalog/forms/editProfile.dart';
import 'package:farmalog/main.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Entities/user.dart';
import 'package:flutter/material.dart';
import 'package:farmalog/pages/profileTabs/tabBlogs.dart';
import 'package:farmalog/pages/profileTabs/tabEvents.dart';
import 'package:farmalog/pages/profileTabs/tabQuestions.dart';
import 'package:lottie/lottie.dart';
import 'package:farmalog/Database_helper/languages.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final language = Language();
  final _securedstorage = Securedstorage();
  final Firestore_helper _firestore_helper = Firestore_helper();
  final TextEditingController _comment = TextEditingController();

  Future<String> getUsername() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return user.username;
  }

  Future<String> getUserID() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return "@${user.userid}";
  }

  Future<String> getUsergender() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return user.gender;
  }

  Future<String> getUserMobileNo() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return user.mobileNo.toString();
  }

  Future<String> getUserRole() async {
    var userID = await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return user.role;
  }

  String permission = "Event Organiser";

  checkEventPermission() async
  {
    if (await getUserRole() == "Event Organiser")
      {
        permission = "Event Organiser";
        setState(() {

        });
      }
    else
      {
        permission = "Blogger";
        setState(() {

        });
      }

  }

  showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  LoadingScreen() {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xffe4e2e5),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF333c3a)),
                SizedBox(height: 10),
                Text(
                  "  Processing...",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF333c3a),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getLanguageForText() async {
    await language.getLanguage();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguageForText();
    checkEventPermission();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Color(0xffe4e2e5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 300,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: Color(0xFFc4cfdd),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Lottie.asset("lib/assets/Farmer.json"),
                    ),
                    FutureText(
                      getText: getUsername(),
                      style: const TextStyle(
                          color: Color(0xFF333c3a),
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    FutureText(
                      getText: getUserID(),
                      style: const TextStyle(
                        color: Color(0xFF333c3a),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFc4cfdd),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(Icons.verified_rounded,
                              color: Color(0xFF333c3a), size: 30),
                          const SizedBox(
                            width: 10,
                          ),
                          LanguageFutureText(
                            getText: getUserRole(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF333c3a),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFc4cfdd),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(Icons.call,
                              color: Color(0xFF333c3a), size: 30),
                          const SizedBox(
                            width: 10,
                          ),
                          FutureText(
                            getText: getUserMobileNo(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF333c3a),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFc4cfdd),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(Icons.account_box_rounded,
                              color: Color(0xFF333c3a), size: 30),
                          const SizedBox(
                            width: 10,
                          ),
                          LanguageFutureText(
                            getText: getUsergender(),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF333c3a),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.only(
                                    right: 25, left: 25, top: 12, bottom: 12),
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color(0xFF333c3a)),
                              elevation: const MaterialStatePropertyAll(10),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileForm(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: Text(
                              language.setText("edit profile"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.only(
                                      right: 35, left: 35, top: 10, bottom: 10),
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xFFc4cfdd)),
                                elevation: const MaterialStatePropertyAll(10)),
                            onPressed: () {
                              _securedstorage.setLoginout("False");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFF333c3a),
                            ),
                            label: Text(
                              language.setText("logout"),
                              style: TextStyle(
                                color: Color(0xFF333c3a),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Color(0xFF333c3a),
                      tabs: [
                        Icon(Icons.image_rounded),
                        Icon(Icons.question_answer_rounded),
                        Icon(Icons.storefront_rounded)
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                          TabBlogs(),
                          TabQuestions(),
                          permission == "Event Organiser" ? TabEvents() : Align(alignment: Alignment.topCenter,child: Text("You don't have permission...",)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FutureText extends StatefulWidget {
  const FutureText({super.key, required this.getText, required this.style});
  final Future<String> getText;
  final TextStyle style;
  @override
  State<FutureText> createState() => _FutureTextState();
}

class _FutureTextState extends State<FutureText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getText,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading...",
            style: widget.style,
          );
        } else if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: widget.style,
          );
        } else {
          return Text("Failed to fetch", style: widget.style);
        }
      },
    );
  }
}

//for only role and gender
class LanguageFutureText extends StatefulWidget {
  const LanguageFutureText(
      {super.key, required this.getText, required this.style});
  final Future<String> getText;
  final TextStyle style;
  @override
  State<LanguageFutureText> createState() => _LanguageFutureTextState();
}

class _LanguageFutureTextState extends State<LanguageFutureText> {
  final language = Language();

  getLanguageForText() async {
    await language.getLanguage();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguageForText();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getText,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading...",
            style: widget.style,
          );
        } else if (snapshot.hasData) {
          return Text(
            language.setText(snapshot.data!.toLowerCase()),
            style: widget.style,
          );
        } else {
          return Text("Failed to fetch", style: widget.style);
        }
      },
    );
  }
}
