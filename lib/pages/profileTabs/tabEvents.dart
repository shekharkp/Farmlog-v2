import 'package:flutter/material.dart';
import 'package:farmalog/Entities/event.dart';
import 'package:farmalog/forms/showEvent.dart';
import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/forms/editEventForm.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';

class TabEvents extends StatefulWidget {
  const TabEvents({super.key});
  @override
  State<TabEvents> createState() => _TabEventsState();
}

class _TabEventsState extends State<TabEvents> {


  final language = Language();
  Securedstorage securedstorage = Securedstorage();
  Firestore_helper firestore_helper = Firestore_helper();


  Future<List<FarmEvents>> _getUserEvents () async
  {
    String userid = await securedstorage.getuserID();
    return await firestore_helper.getUserEvents(userid);
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
          title: Text(language.setText("events"),style: TextStyle(
              color: Color(0xFF333c3a), fontSize: 25,fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xffe4e2e5),
          elevation: 1,
          centerTitle: true,
        ),
        backgroundColor: Color(0xffe4e2e5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: _getUserEvents(),
                builder: (context,AsyncSnapshot<List<FarmEvents>> snapshot) {
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
                                  //Post_image
                                  AspectRatio(
                                    aspectRatio: 1 / 0.7,
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin:const EdgeInsets.all(10),
                                      padding:const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: Image.network(snapshot.data![index].imagePath).image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
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
                                      SizedBox(height: 5,),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on_rounded,size: 20,color: Colors.grey,),
                                              SizedBox(width: 5,),
                                              Text(
                                                snapshot.data![index].location,
                                                maxLines: 1,
                                                style:const TextStyle(
                                                  color: Color(0xFF333c3a),
                                                  fontSize: 12,),
                                              ),
                                            ],
                                          )
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(Icons.calendar_today_rounded,size: 20,color: Colors.grey,),
                                              SizedBox(width: 5,),
                                              Text(
                                                "${snapshot.data![index].date}",
                                                maxLines: 1,
                                                style:const TextStyle(
                                                  color: Color(0xFF333c3a),
                                                  fontSize: 12,),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),

                                  //Post_buttons
                                  Row(
                                    children: [
                                      SizedBox(width: 5,),

                                      IconButton(onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditEventForm(title: snapshot.data![index].title, content: snapshot.data![index].content, imagePath: Image.network(snapshot.data![index].imagePath).image, eventId: snapshot.data![index].eventId, userId: snapshot.data![index].userId, date: snapshot.data![index].date, direction: snapshot.data![index].direction, location: snapshot.data![index].location, imgurl: snapshot.data![index].imagePath,
                                          ),
                                          ),
                                          );
                                      }, icon: Icon(Icons.edit_note_rounded)),

                                      IconButton(onPressed: () async{
                                        LoadingScreen();
                                        await firestore_helper.deleteEvent(snapshot.data![index].eventId,snapshot.data![index].imagePath);
                                        Navigator.of(context).pop();
                                        setState(() {

                                        });
                                      }, icon: Icon(Icons.delete_rounded)),
                                      SizedBox(width: 40,),
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
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowEvent(imageProvider:NetworkImage(snapshot.data![index].imagePath), title: snapshot.data![index].title, content: snapshot.data![index].content, author: snapshot.data![index].userId, location: snapshot.data![index].location, date: snapshot.data![index].date,direction: snapshot.data![index].direction),));
                                          },
                                          child: Text(
                                            language.setText("read more"),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
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
                        "Events not found!",
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



