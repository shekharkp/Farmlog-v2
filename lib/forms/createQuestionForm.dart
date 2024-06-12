import 'package:flutter/material.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Entities/question.dart';
import 'package:farmalog/Database_helper/languages.dart';


class CreateQuestionForm extends StatefulWidget {
  const CreateQuestionForm({super.key});

  @override
  State<CreateQuestionForm> createState() => _CreateQuestionFormState();
}

class _CreateQuestionFormState extends State<CreateQuestionForm> {

  final language = Language();
  final securedStorage = Securedstorage();
  Firestore_helper firestore_helper = Firestore_helper();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final GlobalKey<FormState> _createQuestionkey = GlobalKey<FormState>();

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 110,
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

  Future<String> _createQuestionId() async
  {
    String userid = await securedStorage.getuserID();
    DateTime dateTime = DateTime.now();
    return "${userid}_question_${dateTime}";
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
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffe4e2e5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              padding:const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color:const Color(0xFFc4cfdd),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                language.setText("questions"),
                style: TextStyle(
                  color: Color(0xFF333c3a),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _createQuestionkey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        language.setText("question title"),
                        style:
                        TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
                      ),
                    ),
                    TextFormField(
                      controller: _title,
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: language.setText("enter title")),
                    ),
                     Padding(
                      padding: EdgeInsets.only(left: 10, top: 50),
                      child: Text(
                        language.setText("question description"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF333c3a),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _description,
                      maxLines: 20,
                      maxLength: 2000,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: language.setText("enter description")),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ElevatedButton.icon(
                          icon:const Icon(Icons.post_add),
                          label:Text(language.setText("post Question")),
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  (10),
                                ),
                              ),
                            ),
                            padding:const MaterialStatePropertyAll(
                              EdgeInsets.only(
                                  bottom: 10, top: 10, left: 36, right: 36),
                            ),
                            elevation:const MaterialStatePropertyAll(10),
                            backgroundColor:const MaterialStatePropertyAll(
                              Color(0xFF333c3a),
                            ),
                          ),
                          onPressed: () async {

                            if(_createQuestionkey.currentState!.validate())
                            {
                              try {
                                LoadingScreen();
                                String questionId = await _createQuestionId();
                                String userId = await securedStorage
                                    .getuserID();
                                Question question = Question(
                                    questionId, userId, _title.text,
                                    _description.text, 0);
                                firestore_helper.createQuestion(question);
                                showMessage("Question created");
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                              catch(e) {
                              showMessage("Something Went wrong...");
                              }

                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
