import 'package:flutter/material.dart';
import 'package:farmalog/Entities/answer.dart';
import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';

class ShowAnswer extends StatefulWidget {
  const ShowAnswer(
      {super.key,
        required this.title,
        required this.description,
        required this.author,
        required this.questionId});
  final String title;
  final String description;
  final String author;
  final String questionId;

  @override
  State<ShowAnswer> createState() => _ShowAnswerState();
}

class _ShowAnswerState extends State<ShowAnswer> {

  final language = Language();
  Securedstorage securedStorage = Securedstorage();
  Firestore_helper firestore_helper = Firestore_helper();
  final TextEditingController _content_controller = TextEditingController();

  Future<String> _createAnswerId() async
  {
    String userid = await securedStorage.getuserID();
    DateTime dateTime = DateTime.now();
    return "${userid}_answer_${dateTime}";
  }

  Future<List<Answer>> _getAllAnswers() async
  {
    return await firestore_helper.getQuestionAnswers(widget.questionId);
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
      body: Stack(
        children:[ Padding(
          padding:
          const EdgeInsets.only(top: 50, bottom: 10, right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style:const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333c3a)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("${language.setText("by")} ${widget.author}", style:const TextStyle(color: Colors.grey)),
                SizedBox(height: 10,),
                Text("${language.setText("description")} :", style:const TextStyle(color: Colors.grey)),
                SelectableText(widget.description,
                    style:const TextStyle(
                      color: Colors.black87,

                    ),
                    textAlign: TextAlign.start
                ),
                SizedBox(height: 20,),
                Text(language.setText("answers"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                Divider(thickness: 1),
                FutureBuilder(
                  future: _getAllAnswers(),
                  builder: (context,AsyncSnapshot<List<Answer>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      return Center(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 300),
                          child: CircularProgressIndicator(color: Color(0xFF333c3a),),
                        ),
                      );
                    }
                    else if (snapshot.hasError)
                    {

                      return const Center(
                        heightFactor: 20,
                        child: Text(
                          "Failed to fetch,Check your connection!!!",
                          style: TextStyle(
                              color: Color(0xFF333c3a), fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    else if(snapshot.hasData) {
                      return AnimatedList(
                        initialItemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        physics:const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index, animation) {
                          return Column(
                            children: [
                              Container(
                                padding:const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    //Post_Title
                                    Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.data![index].otherUserId}",
                                            style:const TextStyle(
                                              color: Color(0xFF333c3a),
                                              fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            snapshot.data![index].content,
                                            style:const TextStyle(
                                              color: Color(0xFF333c3a),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else
                    {
                      return const Center(
                        heightFactor: 20,
                        child: Text(
                          "Answers not found!",
                          style: TextStyle(
                              color: Color(0xFF333c3a), fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: _content_controller,
                          cursorColor: Colors.grey,
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffe4e2e5),
                            hintText: language.setText("enter answer"),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                          ),
                          style: const TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FloatingActionButton(
                      backgroundColor:const Color(0xFFc4cfdd),
                      child:const Icon(
                        Icons.send_rounded,
                        color: Color(0xFF333c3a),
                      ),
                      onPressed: ()async {
                        if(_content_controller.text.isEmpty)
                          {
                            return;
                          }
                        String answerId = await _createAnswerId();
                        String userid = await securedStorage.getuserID();
                        Answer answer = Answer(answerId, widget.questionId, userid, _content_controller.text);
                        await firestore_helper.addAnswer(answer);
                        //update answer count
                        List<Answer> answers = await firestore_helper.getQuestionAnswers(widget.questionId);
                        int answerCount = answers.length;
                        await firestore_helper.updateAnswerCount(widget.questionId, answerCount);
                        setState((){
                          _content_controller.clear();
                        },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
      ]
      ),
    );
  }
}
