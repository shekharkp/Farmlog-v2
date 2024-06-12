import 'package:flutter/material.dart';
import 'package:farmalog/Database_helper/languages.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowEvent extends StatefulWidget {
  const ShowEvent(
      {super.key,
        required this.imageProvider,
        required this.title,
        required this.content,
        required this.author,
        required this.location,
        required this.date,
        required this.direction
      });
  final ImageProvider imageProvider;
  final String title;
  final String content;
  final String author;
  final String location;
  final String date;
  final String direction;

  @override
  State<ShowEvent> createState() => _ShowEventState();
}

class _ShowEventState extends State<ShowEvent> {

  final language = Language();
  
  getLanguageForText()async
  {
    await language.getLanguage();
    setState(() {
    });
  }

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  Future<void> _launchUrl(_url) async {
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    }
    else
      {
        showMessage("Link is broken...");
      }
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
      body: SafeArea(
        child: Padding(
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
                Text("${language.setText("by")} ${widget.author}", style:const TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10,),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(Icons.location_on_rounded,size: 20,color: Colors.grey,),
                        SizedBox(width: 5,),
                        Text(
                          widget.location,
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
                          "${widget.date}",
                          maxLines: 1,
                          style:const TextStyle(
                            color: Color(0xFF333c3a),
                            fontSize: 12,),
                        ),
                      ],
                    )
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 40,
                  indent: 50,
                  endIndent: 50,
                ),
                AspectRatio(
                  aspectRatio: 1 / 0.7,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin:const EdgeInsets.all(25),
                    padding:const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: widget.imageProvider,
                        fit: BoxFit.cover,
                        opacity: 1,
                      ),
                    ),
                  ),
                ),
                SelectableText(widget.content,
                    style:const TextStyle(
                      color: Colors.black87,

                    ),
                    textAlign: TextAlign.start),
                SizedBox(height:90),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom: 40),
    child: FloatingActionButton.extended(

    backgroundColor:const Color(0xFF333c3a),
    onPressed: () async{
      final Uri _url = Uri.parse(widget.direction);
      _launchUrl(_url);
    },
    label: Text(language.setText("direction")),
    icon: const Icon(
    Icons.directions,
    color: Colors.white,
    ),
    ),),
    );
  }
}

