import 'package:flutter/material.dart';
import 'package:farmalog/Entities/question.dart';
import 'package:farmalog/forms/showAnswer.dart';
import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';


class SearchTabQuestions extends StatefulWidget {
  SearchTabQuestions({super.key,required this.query});
  String query;
  @override
  State<SearchTabQuestions> createState() => _SearchTabQuestionsState();
}

class _SearchTabQuestionsState extends State<SearchTabQuestions> {

   Language language = Language();
   Firestore_helper firestore_helper = Firestore_helper();

  Future<List<Question>> _getAllQuestions() async
  {
    return await firestore_helper.getAllQuestion();
  }
  
   Future<List<Question>> _search(String query,Future<List<Question>> questionlist) async
   {
     List<Question> filteredList = [];
     await questionlist.then((value)
     {
        value.forEach((element) {
         if(element.title.toLowerCase().contains(query.toLowerCase()))
           {
              filteredList.add(element);
           }
       }
       );
     }
     );

     return filteredList;
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
                future: _search(widget.query, _getAllQuestions()),
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
                                      SizedBox(width: 150,),
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
                                            style: TextStyle(
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
              SizedBox(height: 300,)
            ],
          ),
        ),
      ),
    );
  }
}


