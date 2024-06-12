import 'package:farmalog/feedback/feedback.dart';
import 'package:farmalog/Entities/user.dart';
import 'package:farmalog/Entities/comment.dart';
import '../Entities/blog.dart';
import 'package:farmalog/Entities/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmalog/Entities/event.dart';
import 'package:farmalog/Entities/answer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class Firestore_helper {
  final db = FirebaseFirestore.instance;

  //Methods for user

  Future<void> addUser(User user) async {
    await db.collection("Users").add(user.toJson());
  }

  Future<dynamic> getUser(User user) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query =
    await ref.where("userid", isEqualTo: user.userid).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      User user = User(
          element["userid"],
          element["username"],
          element["gender"],
          element['mobileNo'],
          element["password"],
          element["role"]);
      return user;
    } else {
      return null;
    }
  }

  Future<dynamic> getUserByID(String userID) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query = await ref.where("userid", isEqualTo: userID).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      User user = User(element["userid"], element["username"],
          element["gender"], element['mobileNo'], element["password"],element["role"]);
      return user;
    } else {
      return null;
    }
  }

  Future<bool> getUserbyIDPass(String userid, String password) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query = await ref.where("userid", isEqualTo: userid).get();

    if (query.docs.isNotEmpty) {
      var element = query.docs.first;
      if (element["userid"] == userid && element["password"] == password) {
        return true;
      }
    }
    return false;
  }

  Updateuser(User user) async {
    CollectionReference ref = await db.collection("Users");
    QuerySnapshot query =
    await ref.where("userid", isEqualTo: user.userid).get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.update(user.toJson());
  }

  //Methods for blog
  createBlog(Blog blog) async {
    await db.collection("Blog").add(blog.toJson());
  }

  Future<List<Blog>> getAllBlogs() async {
    CollectionReference collectionReference = await db.collection("Blog");
    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Blog> Blogs = [];
    querySnapshot.docs.forEach(
          (element) {
        Blogs.add(
          Blog(
            element["blogid"],
            element["title"],
            element["content"],
            element["userid"],
            element["showcomments"],
            element["img"],
          ),
        );
      },
    );
    return Blogs;
  }


  Future<List<Blog>> getUserBlogs(String userid) async {
    CollectionReference collectionReference = await db.collection("Blog");
    QuerySnapshot querySnapshot = await collectionReference.where(
        "userid", isEqualTo: userid).get();

    List<Blog> Blogs = [];
    querySnapshot.docs.forEach(
          (element) {
        Blogs.add(
          Blog(
            element["blogid"],
            element["title"],
            element["content"],
            element["userid"],
            element["showcomments"],
            element["img"],
          ),
        );
      },
    );
    return Blogs;
  }


  updateBlog(Blog blog) async {
    CollectionReference ref = await db.collection("Blog");
    QuerySnapshot query = await ref.where("blogid", isEqualTo: blog.blog_id)
        .get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.update(blog.toJson());
  }

  deleteBlog(String blogId,String url) async {
    CollectionReference ref = await db.collection("Blog");
    QuerySnapshot query = await ref.where("blogid", isEqualTo: blogId).get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.delete();
    var getimg = await firebase_storage.FirebaseStorage.instance.refFromURL(url);
    await getimg.delete();
  }


  //methods for comment
  addComment(Comments comment) async {
    await db.collection("Comment").add(comment.toJson());
  }

  Future<List<Comments>> getBlogComments(String blogId) async
  {
    CollectionReference collectionReference = await db.collection("Comment");
    QuerySnapshot querySnapshot = await collectionReference.where(
        "blogId", isEqualTo: blogId).get();

    List<Comments> Comment = [];

    querySnapshot.docs.forEach((element) {
      Comments comments = Comments(
          element["commentId"], element["blogId"], element["content"],
          element["commentUserId"], element["replyContent"]);
      Comment.add(comments);
    }
    );
    return Comment;
  }

  updateComment(String commentId,String reply) async {
    CollectionReference ref = await db.collection("Comment");
    QuerySnapshot query = await ref.where("commentId", isEqualTo: commentId).get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.update({"replyContent" : reply});
  }




  //Methods for Question

  createQuestion(Question question) async {
    await db.collection("Question").add(question.toJson());
  }

  Future<List<Question>> getAllQuestion() async {
    CollectionReference collectionReference = await db.collection("Question");
    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Question> question = [];
    querySnapshot.docs.forEach(
          (element) {
        question.add(
          Question(
            element["questionid"],
            element["userid"],
            element["title"],
            element["description"],
            element["answerCount"]
          ),
        );
      },
    );
    return question;
  }


  Future<List<Question>> getUserQuestion(String userid) async {
    CollectionReference collectionReference = await db.collection("Question");
    QuerySnapshot querySnapshot = await collectionReference.where("userid", isEqualTo: userid).get();

    List<Question> question = [];
    querySnapshot.docs.forEach(
          (element) {
        question.add(
          Question(
            element["questionid"],
            element["userid"],
            element["title"],
            element["description"],
            element["answerCount"]
          ),
        );
      },
    );
    return question;
  }


  updateQuestion(Question question) async {
    CollectionReference ref = await db.collection("Question");
    QuerySnapshot query = await ref.where("questionid", isEqualTo: question.questionId)
        .get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.update(question.toJson());
  }

  deleteQuestion(String questionid) async {
    CollectionReference ref = await db.collection("Question");
    QuerySnapshot query = await ref.where("questionid", isEqualTo: questionid).get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.delete();
  }



  //Methods for answer
  addAnswer(Answer answer) async {
    await db.collection("Answer").add(answer.toJson());
  }

  updateAnswerCount(String questionid,int answerCount) async
  {
    CollectionReference ref = await db.collection("Question");
    QuerySnapshot query = await ref.where("questionid", isEqualTo: questionid).get();
    DocumentSnapshot documentSnapshot = query.docs.first;
    DocumentReference documentReference = ref.doc(documentSnapshot.id);
    documentReference.update({"answerCount" : answerCount});
  }

  Future<List<Answer>> getQuestionAnswers(String questionId) async
  {

    CollectionReference collectionReference = await db.collection("Answer");
    QuerySnapshot querySnapshot = await collectionReference.where(
        "questionId", isEqualTo: questionId).get();

    List<Answer> answer = [];

    querySnapshot.docs.forEach((element) {
      answer.add( Answer(
          element["answerId"], element["questionId"], element["otherUserId"],
          element["content"])
      );
    }
    );
    return answer;
  }




  //Methods for Event

  createEvent(FarmEvents event) async {
    await db.collection("Event").add(event.toJson());
  }

  Future<List<FarmEvents>> getAllEvents() async {
    CollectionReference collectionReference = await db.collection("Event");
    QuerySnapshot querySnapshot = await collectionReference.get();

    List<FarmEvents> events = [];
    querySnapshot.docs.forEach(
          (element) {
        events.add(
          FarmEvents(
            element["eventId"],
            element["userId"],
            element["title"],
            element["imagePath"],
            element["Location"],
            element["content"],
            element["dateTime"],
            element["direction"],
          ),
        );
      },
    );
    return events;
  }

  Future<List<FarmEvents>> getUserEvents(String userid) async {
    CollectionReference collectionReference = await db.collection("Event");
    QuerySnapshot querySnapshot = await collectionReference.where("userId",isEqualTo: userid).get();

    List<FarmEvents> events = [];
    querySnapshot.docs.forEach(
          (element) {
        events.add(
          FarmEvents(
            element["eventId"],
            element["userId"],
            element["title"],
            element["imagePath"],
            element["Location"],
            element["content"],
            element["dateTime"],
            element["direction"],
          ),
        );
      },
    );
    return events;
  }

  updateEvent(FarmEvents event) async {
    CollectionReference ref = await db.collection("Event");
    QuerySnapshot query = await ref.where("eventId", isEqualTo: event.eventId)
        .get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.update(event.toJson());
  }

  deleteEvent(String eventid, String url) async {
    CollectionReference ref = await db.collection("Event");
    QuerySnapshot query = await ref.where("eventId", isEqualTo: eventid).get();
    DocumentSnapshot documentSnapshot = await query.docs.first;
    DocumentReference documentReference = await ref.doc(documentSnapshot.id);
    await documentReference.delete();
    var getimg = await firebase_storage.FirebaseStorage.instance.refFromURL(url);
    await getimg.delete();
  }




  //Feedback
  sendFeedback(Feedbacks feedbacks)async
  {
       await db.collection("Feedback").add(feedbacks.toJson());
  }
}

