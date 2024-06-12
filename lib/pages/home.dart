import 'package:farmalog/Entities/comment.dart';
import 'package:farmalog/forms/createBlogForm.dart';
import 'package:farmalog/feedback/feedbackForm.dart';
import 'package:farmalog/forms/showBlog.dart';
import 'package:flutter/material.dart';
import '../Database_helper/securedStorage.dart';
import '../Database_helper/firestore_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:farmalog/Entities/user.dart';
import '../Entities/blog.dart';
import 'package:farmalog/pages/searchBar.dart';
import 'package:farmalog/Database_helper/languages.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final language = Language();
  final Securedstorage _securedstorage = Securedstorage();
  final Firestore_helper _firestore_helper = Firestore_helper();

  TextEditingController _comment = TextEditingController();


  Future<String> getUsername()async
  {
    var userID = await _securedstorage.getuserID();
    User userInfo = await _firestore_helper.getUserByID(userID);
    print(userInfo.username);
    return userInfo.username;
  }


  Future<List<Blog>> _getAllBlogs() async
  {
    return await _firestore_helper.getAllBlogs();
  }

  Future<String> _createCommentId() async
  {
    String userid = await _securedstorage.getuserID();
    DateTime dateTime = DateTime.now();
    return "${userid}_comment_${dateTime}";
  }

  Future<List<Comments>> getBlogComment(String Blogid)async
  {
    final Comment = await _firestore_helper.getBlogComments(Blogid);
    return Comment;
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
        backgroundColor: Color(0xffe4e2e5),
        body: SingleChildScrollView(
          child:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 70,
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          language.setText("welcome"),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder(future: getUsername(), builder: (context,AsyncSnapshot<String> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting)
                            {
                                 return const Text(
                                   "Loading...",
                                   style: TextStyle(
                                       color: Color(0xFF333c3a),
                                       fontSize: 30,
                                       fontWeight: FontWeight.bold),
                                 );
                            }
                          else if(snapshot.hasData)
                            {
                              return Text(
                                "${snapshot.data} 👋",
                                style:const TextStyle(
                                    color: Color(0xFF333c3a),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          else if(snapshot.hasError)
                            {
                              return const Text(
                                "Failed to fetch",
                                style: TextStyle(
                                    color: Color(0xFF333c3a),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          else
                            {
                              return const Text("Failed to fetch");
                            }
                        },
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox(width: 1,),),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchBarPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 25,
                        color: Color(0xFF333c3a),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Feedbackform(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.feedback_rounded,
                        size: 25,
                        color: Color(0xFF333c3a),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: _getAllBlogs(),
                builder: (context,AsyncSnapshot<List<Blog>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 300),
                        child: CircularProgressIndicator(color: Color(0xFF333c3a),),
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
                                    aspectRatio: 1 / 0.8,
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
                                          "${language.setText("by")} ${snapshot.data![index].userid}",
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
                                      !snapshot.data![index].showComments ? IconButton(onPressed: () {}, icon:const Icon(Icons.mode_comment_rounded,color: Colors.grey,size: 30,),) : IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor:const Color(0xffe4e2e5),
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(16))),
                                           builder: (context) {
                                             return DraggableScrollableSheet(
                                               initialChildSize: 0.7,
                                               minChildSize: 0.4,
                                               maxChildSize: 0.85,
                                               expand: false,
                                               builder: (context,
                                                   controller) =>
                                                   Column(
                                                     children: [
                                                       Icon(
                                                         Icons.remove,
                                                         color: Colors
                                                             .grey[600],
                                                       ),
                                                       Container(
                                                         padding:const EdgeInsets
                                                             .all(10),
                                                         child:Text(
                                                           language.setText("feedback"),
                                                           style:const TextStyle(
                                                               fontSize: 20,
                                                               fontWeight: FontWeight
                                                                   .bold,
                                                               color: Color(
                                                                   0xFF333c3a)),
                                                         ),
                                                       ),
                                                       FutureBuilder(
                                                         future: getBlogComment(snapshot.data![index].blog_id),
                                                         builder: (context1,AsyncSnapshot<List<Comments>> snapshot1) {
                                                           if(snapshot1.connectionState == ConnectionState.waiting)
                                                           {
                                                             return const Padding(
                                                               padding: EdgeInsets.all(25.0),
                                                               child: CircularProgressIndicator(color: Color(0xFF333c3a),),
                                                             );
                                                           }
                                                           else if(snapshot1.hasError)
                                                           {
                                                             return const Expanded(
                                                               child: Center(
                                                                 child: Text(
                                                                   "Failed to fetch,Check your Connection!",
                                                                   style: TextStyle(
                                                                       color: Color(0xFF333c3a), fontSize: 18,fontWeight: FontWeight.bold),
                                                                 ),
                                                               ),
                                                             );
                                                           }
                                                           else if(snapshot1.hasData)
                                                           {
                                                             return Expanded(
                                                               child: ListView
                                                                   .builder(
                                                                 controller: controller,
                                                                 itemCount: snapshot1.data!.length,
                                                                 itemBuilder: (
                                                                     context,
                                                                     index) {
                                                                   return Padding(
                                                                     padding: const EdgeInsets
                                                                         .all(10),
                                                                     child: Column(
                                                                       crossAxisAlignment:
                                                                       CrossAxisAlignment
                                                                           .start,
                                                                       children: [
                                                                         Text(
                                                                           snapshot1.data![index].commentUserId,
                                                                           style:const TextStyle(
                                                                               color: Colors
                                                                                   .blueGrey),
                                                                         ),
                                                                         Container(
                                                                           padding:
                                                                           const EdgeInsets
                                                                               .all(
                                                                               5),
                                                                           child: Text(
                                                                               snapshot1.data![index].content),
                                                                         ),
                                                                         Container(
                                                                             padding:
                                                                            const EdgeInsets
                                                                                 .only(
                                                                                 left: 40,
                                                                                 top: 5,
                                                                                 right: 5,
                                                                                 bottom: 5),
                                                                             child:snapshot1.data![index].replyContent == ""? null : Text(
                                                                                 snapshot1.data![index].replyContent)
                                                                         ),
                                                                         const Divider(
                                                                           color:
                                                                           Colors
                                                                               .blueGrey,
                                                                           thickness: 2,
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   );
                                                                 },
                                                               ),
                                                             );
                                                           }
                                                           else
                                                           {
                                                             return const Center(
                                                               heightFactor: 20,
                                                               child: Text(
                                                                 "No comments found",
                                                                 style: TextStyle(
                                                                     color: Color(0xFF333c3a), fontSize: 18,fontWeight: FontWeight.bold),
                                                               ),
                                                             );
                                                           }
                                                         },
                                                       ),
                                                       Padding(
                                                         padding: EdgeInsets
                                                             .only(
                                                           bottom: MediaQuery
                                                               .of(context)
                                                               .viewInsets
                                                               .bottom,
                                                         ),
                                                         child: Row(
                                                           children: [
                                                             Expanded(
                                                               child: Padding(
                                                                 padding:
                                                                 const EdgeInsets
                                                                     .all(10),
                                                                 child: TextFormField(
                                                                   controller: _comment,
                                                                   maxLength: 100,
                                                                   keyboardType:
                                                                   TextInputType
                                                                       .text,
                                                                   decoration: InputDecoration(
                                                                       counterText: '',
                                                                       hintText:
                                                                       language.setText("add a comment")),
                                                                 ),
                                                               ),
                                                             ),
                                                             Padding(
                                                               padding:
                                                               const EdgeInsets
                                                                   .only(
                                                                   right: 10),
                                                               child: IconButton(
                                                                 icon:const Icon(
                                                                   Icons
                                                                       .send_rounded,
                                                                   color: Color(
                                                                       0xFF333c3a),),
                                                                 onPressed: () async{
                                                                   if(_comment.text.isNotEmpty)
                                                                   {
                                                                     String commentId = await _createCommentId();
                                                                     String userName = await getUsername();
                                                                     String replyContent = "";
                                                                     String blogId = snapshot.data![index].blog_id;

                                                                     Comments comment = Comments(commentId, blogId, _comment.text, userName, replyContent);
                                                                     await _firestore_helper.addComment(comment);
                                                                     setState(() {
                                                                       _comment.clear();
                                                                       FocusScope.of(context).unfocus();
                                                                     });

                                                                   }
                                                                 },
                                                               ),
                                                             ),
                                                           ],
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                             );
                                           },
                                          );
                                        },
                                        icon:const Icon(
                                          Icons.mode_comment_rounded,
                                          color: Color(0xFF333c3a),
                                          size: 30,
                                        ),
                                      ),
                                      IconButton(
                                        icon:const Icon(
                                          Icons.share_rounded,
                                          color: Color(0xFF333c3a),
                                          size: 30,
                                        ),
                                        onPressed: () {
                                            Share.share("${snapshot.data![index].title}\n\n${snapshot.data![index].content}");
                                        },
                                      ),
                                      const SizedBox(
                                        width: 160,
                                      ),
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
                                            Navigator.push(context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowBlog(title: snapshot.data![index].title,content: snapshot.data![index].content,imageProvider: NetworkImage(snapshot.data![index].imagePath),author: snapshot.data![index].userid),),);
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
                          "Blogs not found!",
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton(
            backgroundColor:const Color(0xFF333c3a),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>const CreateBlogForm(),));
            },
            child:const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


