import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Entities/user.dart';
import 'package:farmalog/forms/showBlog.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:farmalog/Entities/blog.dart';
import 'package:farmalog/Entities/comment.dart';
import 'package:farmalog/Database_helper/languages.dart';

class SearchTabBlogs extends StatefulWidget {
  SearchTabBlogs({super.key,required this.query});
  String query;
  @override
  State<SearchTabBlogs> createState() => _SearchTabBlogsState();
}

class _SearchTabBlogsState extends State<SearchTabBlogs> {
  
  Language language = Language();
  final _securedstorage = Securedstorage();
  final Firestore_helper _firestore_helper = Firestore_helper();
  final TextEditingController _comment = TextEditingController();


  Future<String> getUsername() async
  {
    var userID =await _securedstorage.getuserID();
    User user = await _firestore_helper.getUserByID(userID);
    return user.username;
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

  Future<List<Blog>> _search(String query,Future<List<Blog>> bloglist) async
  {
    List<Blog> filteredList = [];
    await bloglist.then((value)
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


  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  LoadingScreen() {
    return showDialog(context: context, builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            color: const Color(0xffe4e2e5),),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF333c3a)),
              SizedBox(height: 10),
              Text("  Processing...", style: TextStyle(fontSize: 12,
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
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        await Future.delayed(const Duration(seconds: 1));
        setState(() {

        });
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            const Icon(Icons.arrow_upward_rounded,color: Colors.black,)
          ],
          title: Text(language.setText("blogs"),style:const  TextStyle(
              color: Color(0xFF333c3a), fontSize: 25,fontWeight: FontWeight.bold),),
          backgroundColor: Color(0xffe4e2e5),
          elevation: 1,
          centerTitle: true,
        ),
        backgroundColor: Color(0xffe4e2e5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom: 20),
                child: Column(
                  children: [
              FutureBuilder(
                future: _search(widget.query, _getAllBlogs()),
                builder: (context,AsyncSnapshot<List<Blog>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator(color: Color(0xFF333c3a),));
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
                  else if(snapshot.hasData)
                  {
                    return AnimatedList(
                      initialItemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index, animation) {
                        return Column(
                          children: [
                            Container(
                              padding:const EdgeInsets.all(0),
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
                                          "${language.setText("by")} ${snapshot.data![index].userid}",
                                          maxLines: 1,
                                          style:const TextStyle(
                                              color: Color(0xFF333c3a), fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Post_buttons
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor:const Color(0xffe4e2e5),
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(16))),
                                            builder: (context) =>
                                                DraggableScrollableSheet(
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
                                                            child: Text(
                                                              language.setText("feedback"),
                                                              style: TextStyle(
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
                                                                          hintText: language.setText("add a comment"),),
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

                                                                        _comment.clear();
                                                                        FocusScope.of(context).unfocus();

                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                ),
                                          );
                                        },
                                        icon:const Icon(
                                          Icons.mode_comment_rounded,
                                          color: Color(0xFF333c3a),
                                          size: 30,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {

                                          Share.share("${snapshot.data![index].title}\n\n${snapshot.data![index].content}");

                                        },
                                        icon:const Icon(
                                          Icons.share_rounded,
                                          color: Color(0xFF333c3a),
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 100,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              const MaterialStatePropertyAll(
                                                  Color(0xFF333c3a)),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10)))),
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowBlog(imageProvider: NetworkImage(snapshot.data![index].imagePath), title: snapshot.data![index].title, content: snapshot.data![index].content, author: snapshot.data![index].userid),),);
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
                        "Blogs not Found!!",
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
      ]
          ),
    ),
    ),
    );
  }
}


