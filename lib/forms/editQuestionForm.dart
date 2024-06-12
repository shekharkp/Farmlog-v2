import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Entities/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditQuestionForm extends StatefulWidget {
  EditQuestionForm({super.key,required this.Questionid,required this.title,required this.description,required this.userid,required this.answerCount});
  final String title;
  final String description;
  final String Questionid;
  final String userid;
  final int answerCount;

  @override
  State<EditQuestionForm> createState() => _EditQuestionFormState();
}

class _EditQuestionFormState extends State<EditQuestionForm> {

  Firestore_helper firestore_helper = Firestore_helper();
  final language = Language();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final _EditQuestionkey = GlobalKey<FormState>();

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
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

  getLanguageForText()async
  {
    await language.getLanguage();
    setState(() {
    });
  }


  @override
  void initState() {
    _title.text = widget.title;
    _description.text = widget.description;
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
              child:Text(
                language.setText("edit question"),
                style:const TextStyle(
                  color: Color(0xFF333c3a),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _EditQuestionkey,
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
                          label:Text(language.setText("save"),),
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

                            if(_EditQuestionkey.currentState!.validate())
                            {
                              LoadingScreen();
                              Question question = Question(widget.Questionid, widget.userid, _title.text, widget.description, widget.answerCount);
                              await firestore_helper.updateQuestion(question);
                              showMessage("Question update success");
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

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
