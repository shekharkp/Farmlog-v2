import 'package:flutter/material.dart';
import 'chatbotapi.dart';
import 'package:farmalog/Database_helper/languages.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  
  final language = Language();
  List<Message> msg = [Message('r', "Hello, How can i help?"),];
  final TextEditingController _chatbot_controller = TextEditingController();
  
  
  void sendMessage(String message)
  {
    msg.add(Message("s", message),);
  }

  void responceMessage(String message) async
  {
    Responce rp = Responce();
    try{
      msg.add(Message('r', 'Loading...'));
      final respo = await rp.sendMessageToChatGPT(message);
      String respor = respo['choices'][0]['message']['content'];
      setState(() {
        msg.removeLast();
        msg.add(Message("r", respor));
      });

    }
    catch(e)
    {
      setState(() {
        msg.removeLast();
        msg.add(Message('r', 'Check your connection.'),);
      });


    }

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
    return SafeArea(
      child: Scaffold(
        backgroundColor:const Color(0xffe4e2e5),
        appBar: AppBar(
          backgroundColor:const Color(0xffe4e2e5),
          automaticallyImplyLeading: false,
          title: Text(language.setText("chatbot"),style: TextStyle(color: Color(0xFF333c3a),fontWeight: FontWeight.bold,fontSize: 25),),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
          SingleChildScrollView(
            reverse: true,
            child: AnimatedList(
              shrinkWrap: true,
              physics:const NeverScrollableScrollPhysics(),
              initialItemCount: msg.length,
              key: UniqueKey(),
              padding:const EdgeInsets.only(top: 10, bottom: 70),
              itemBuilder: (context, index,animation) {
                return Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Align(
                    alignment: msg[index].message_type == "r"
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: msg[index].message_type == "r"
                            ? const Color(0xFFc4cfdd)
                            :const Color(0xFF333c3a),
                      ),
                      padding:const EdgeInsets.all(16),
                      child: Text(
                        msg[index].message,
                        style: msg[index].message_type == 'r'?const TextStyle(color: Color(0xFF333c3a)):const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        controller: _chatbot_controller,
                        cursorColor: Colors.grey,
                        cursorHeight: 15,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: language.setText("enter message"),
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
                    onPressed: () {
                      setState((){
                        sendMessage(_chatbot_controller.text);
                        responceMessage(_chatbot_controller.text);
                        _chatbot_controller.clear();
                      },
                      );
                    },
                  )
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

class Message {
  String message_type;
  String message;
  Message(this.message_type, this.message);
}
