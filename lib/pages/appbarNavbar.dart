import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:farmalog/pages/home.dart';
import 'package:farmalog/pages/events.dart';
import 'package:farmalog/chatbot/chatbot.dart';
import 'package:farmalog/pages/community.dart';
import 'profile.dart';
import 'package:farmalog/Database_helper/languages.dart';

class appbarNavbar extends StatefulWidget {
  const appbarNavbar({super.key});

  @override
  State<appbarNavbar> createState() => _appbarNavbarState();
}

class _appbarNavbarState extends State<appbarNavbar> {
  
  Language language = Language();
  List<Widget> Pages = [const Home(), const Community(), const Chatbot(), const Events(), const Profile()];
  int index = 0;

  getLanguageForText()async
  {
    await language.getLanguage();
    setState(() {
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguageForText();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: const Text("Do you really wanted to exit!!!"),
              backgroundColor: const Color(0xFFe4e2e5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF333c3a),
                    ),
                  ),
                  child:const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF333c3a),
                    ),
                  ),
                  child:const Text("Yes"),
                ),
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        backgroundColor:const Color(0xffe4e2e5),
        extendBody: true,
        bottomNavigationBar: SizedBox(
          height: 80,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              backgroundColor:const Color(0xFFc4cfdd),
              elevation: 0,
              selectedIconTheme:const IconThemeData(
                size: 25,
              ),
              unselectedIconTheme:const IconThemeData(
                size: 22,
              ),
              selectedLabelStyle:const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333c3a)),
              selectedItemColor:const Color(0xFF333c3a),
              enableFeedback: true,
              unselectedItemColor:const Color(0xFF333c3a),
              showSelectedLabels: true,
              showUnselectedLabels: false,
              currentIndex: index,
              onTap: (value) {
                setState(
                  () {
                    index = value;
                  },
                );
              },
              items:  [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  activeIcon: Icon(
                    Icons.home_rounded,
                  ),
                  label: language.setText("home"),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.question_answer_outlined),
                  activeIcon: Icon(Icons.question_answer_rounded),
                  label: language.setText("community")
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                  ),
                  label: language.setText("chatbot"),
                  activeIcon: Icon(
                    Icons.chat_bubble_rounded,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.storefront_outlined),
                    activeIcon: Icon(Icons.storefront_rounded),
                    label: language.setText("events")
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline_rounded,
                  ),
                  label: language.setText("profile"),
                  activeIcon: Icon(
                    Icons.person,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Pages[index],
      ),
    );
  }
}
