// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:farmalog/chatbot/chatbotapi.dart';

void main()async {

  test("Test Verify Blog Content False",() async{
    Responce responce = Responce();
    var rsp = await responce.verifyBlogContent("Hello, i am not an agricultulist.");
    expect(rsp, "False");
  },);

  test("Test Verify Blog Content True",() async{
    Responce responce = Responce();
    var rsp = await responce.verifyBlogContent("Mahadhan helps farmers to get good pomgranate produce.");
    expect(rsp, "True");
  },
  );


}
