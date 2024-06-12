import 'package:flutter/material.dart';
import 'package:farmalog/Entities/question.dart';
import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/forms/showAnswer.dart';
import 'package:farmalog/forms/editQuestionForm.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';


class TabQuestions extends StatefulWidget {
  const TabQuestions({super.key});
  @override
  State<TabQuestions> createState() => _TabQuestionsState();
}

class _TabQuestionsState extends State<TabQuestions> {

  final language = Language();
  Securedstorage securedstorage = Securedstorage();
  Firestore_helper firestore_helper = Firestore_helper();


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


  Future<List<Question>> _getAllQuestions() async
  {
    String userid = await securedstorage.getuserID();
    return await firestore_helper.getUserQuestion(userid);
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
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {

        });
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Icon(Icons.arrow_upward_rounded,color: Colors.black,)
          ],
          title: Text(language.setText("questions"),style: TextStyle(
              color: Color(0xFF333c3a), fontSize: 25,fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xffe4e2e5),
          elevation: 1,
          centerTitle: true,
        ),
        backgroundColor: Color(0xffe4e2e5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              FutureBuilder(
                future: _getAllQuestions(),
                builder: (context,AsyncSnapshot<List<Question>> snapshot) {
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
                    print(snapshot.error);
                    return const Center(
                      heightFactor: 20,
                      child: Text(
                        "Failed to fetch,Check your connection!!!}",
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
                      physics:const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, animation) {
                        return Column(
                          children: [
                            Container(
                              padding:const EdgeInsets.all(10),
                              decoration:const BoxDecoration(
                                color: Color(0xffe4e2e5),
                              ),
                              child: Column(
                                children: [
                                  //Post_Title
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          snapshot.data![index].title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style:const TextStyle(
                                            color: Color(0xFF333c3a),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${language.setText("by")} ${snapshot.data![index].userId}",
                                          maxLines: 1,
                                          style:const TextStyle(
                                            color: Color(0xFF333c3a),
                                            fontSize: 12,),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Post_buttons
                                  Row(
                                    children: [
                                      Text(
                                        "${snapshot.data![index].answerCount} ${language.setText("answers")}",
                                      ),
                                      SizedBox(width: 5,),

                                      IconButton(onPressed: () {
                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => EditQuestionForm(Questionid: snapshot.data![index].questionId, title: snapshot.data![index].title, description: snapshot.data![index].description, userid: snapshot.data![index].userId,answerCount: snapshot.data![index].answerCount),));
                                      }, icon: Icon(Icons.edit_note_rounded)),
                                      
                                      IconButton(onPressed: () async{
                                          LoadingScreen();
                                          await firestore_helper.deleteQuestion(snapshot.data![index].questionId);
                                          Navigator.of(context).pop();
                                          setState(() {

                                          });
                                      }, icon: Icon(Icons.delete_rounded)),
                                      

                                      SizedBox(width: 60,),
                                      //Read more button
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                            const MaterialStatePropertyAll(
                                              Color(0xFF333c3a),),
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),),),
                                            elevation:const MaterialStatePropertyAll(
                                                8),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowAnswer(title: snapshot.data![index].title, description: snapshot.data![index].description, author: snapshot.data![index].userId,questionId: snapshot.data![index].questionId,)));
                                          },
                                          child: Text(
                                            language.setText("view answers"),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,fontSize: 12,),
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
                        "Questions not found!",
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
    );
  }
}


