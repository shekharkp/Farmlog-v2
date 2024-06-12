import 'feedback.dart';
import 'package:farmalog/Entities/user.dart';
import 'package:flutter/material.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Database_helper/languages.dart';

class Feedbackform extends StatefulWidget {
  const Feedbackform({super.key});

  @override
  State<Feedbackform> createState() => _FeedbackformState();
}

class _FeedbackformState extends State<Feedbackform> {
  final language = Language();
  final TextEditingController _feedbackcontroller = TextEditingController();
  final Securedstorage securedstorage = Securedstorage();
  final Firestore_helper firestore_helper = Firestore_helper();

  Future<List<String>> getFeedbackDetails()async
  {
    List<String> feedbackList = [];
    String userid = await securedstorage.getuserID();
    feedbackList.add(userid);
    User username = await firestore_helper.getUserByID(userid);
    feedbackList.add(username.username);
    return feedbackList;
  }

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            color: const Color(0xffe4e2e5),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF333c3a)),
              SizedBox(height: 10),
              Text("  ${language.setText("processing")}", style: TextStyle(fontSize: 12,
                  color: Color(0xFF333c3a),
                  fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      );
    },);
  }

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

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
    return Scaffold(
      backgroundColor:const Color(0xffe4e2e5),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(language.setText("feedback"),
                style: TextStyle(
                    color: Color(0xFF333c3a),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _feedbackcontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                padding:const MaterialStatePropertyAll(
                  EdgeInsets.only(right: 20, left: 20, top: 12, bottom: 12),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor:const MaterialStatePropertyAll(Color(0xFF333c3a)),
                elevation:const MaterialStatePropertyAll(10),
              ),
              onPressed: ()async {
                if(_feedbackcontroller.text.isNotEmpty)
                  {
                    LoadingScreen();
                    List<String> Feedback_details = await getFeedbackDetails();
                    Feedbacks feedback = Feedbacks(Feedback_details[0], Feedback_details[1], _feedbackcontroller.text);
                    await firestore_helper.sendFeedback(feedback);
                    showMessage("Feedback sent successfully!");
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
              },
              icon:const Icon(Icons.feedback_rounded),
              label: Text(language.setText("send feedback")),
            ),
          ],
        ),
      ),
    );
  }
}
