import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Entities/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditEventForm extends StatefulWidget {
  EditEventForm({super.key,required this.title,required this.content,required this.imagePath,required this.eventId,required this.userId,required this.date,required this.direction, required this.location,required this.imgurl});
  final String eventId;
  final String userId;
  final String title;
  final ImageProvider imagePath;
  final String location;
  final String content;
  final String date;
  final String direction;
  final String imgurl;

  @override
  State<EditEventForm> createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {

  Firestore_helper firestore_helper = Firestore_helper();
  final language = Language();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _directionLink = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final _EditEventkey = GlobalKey<FormState>();

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
  }

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 100,
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
    _title.text = widget.title;
    _date.text = widget.date;
    _location.text = widget.location;
    _directionLink.text = widget.direction;
    _content.text = widget.content;
    super.initState();
    getLanguageForText();
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:const Color(0xffe4e2e5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              padding:const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color:const Color(0xFFc4cfdd),
                  borderRadius: BorderRadius.circular(30)),
              child:Text(
                language.setText("edit event"),
                style:const TextStyle(
                  color: Color(0xFF333c3a),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _EditEventkey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        language.setText("title"),
                        style:
                        TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
                      ),
                    ),
                    TextFormField(
                      controller: _title,
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: "Enter Title"),
                    ),
                     Padding(
                      padding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        language.setText("date"),
                        style:
                        TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
                      ),
                    ),
                    TextFormField(
                      controller: _date,
                      maxLength: 100,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100)
                        );

                        if(pickedDate != null)
                        {
                          String format = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          setState(() {
                            _date.text = format;
                          });
                        }
                      },
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: "Enter Date"),
                    ),
                     Padding(
                      padding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        language.setText("location"),
                        style:
                        TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
                      ),
                    ),
                    TextFormField(
                      controller: _location,
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: "Enter Location"),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        language.setText("map location hyperlink"),
                        style:
                        TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
                      ),
                    ),
                    TextFormField(
                      controller: _directionLink,
                      maxLength: 100,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: "Enter Hyperlink"),
                    ),
                    AspectRatio(
                      aspectRatio: 1 / 0.8,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin:const EdgeInsets.all(20),
                        padding:const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: widget.imagePath,
                            fit: BoxFit.cover,
                            opacity: 1,
                          ),
                        ),
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        language.setText("content"),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF333c3a),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _content,
                      maxLines: 20,
                      maxLength: 2000,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                        {
                          return "This field is required!";
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          counterText: '',
                          hintText: "Enter Content"),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ElevatedButton.icon(
                          icon:const Icon(Icons.post_add),
                          label:Text(language.setText("save")),
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  (10),
                                ),
                              ),
                            ),
                            padding:const MaterialStatePropertyAll(
                              EdgeInsets.only(
                                  bottom: 10, top: 10, left: 36, right: 36),
                            ),
                            elevation:const MaterialStatePropertyAll(10),
                            backgroundColor:const MaterialStatePropertyAll(
                              Color(0xFF333c3a),
                            ),
                          ),
                          onPressed: () async {

                            if(_EditEventkey.currentState!.validate())
                            {
                              LoadingScreen();
                              FarmEvents event = FarmEvents(widget.eventId, widget.userId, _title.text, widget.imgurl, _location.text, _content.text, _date.text, _directionLink.text);
                              await firestore_helper.updateEvent(event);
                              showMessage("Event update success");
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                            }
                          },
                        ),
                      ),
                    ),
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
