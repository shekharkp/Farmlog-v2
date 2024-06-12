import 'dart:io';
import 'package:farmalog/Entities/event.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmalog/Database_helper/languages.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  File? _image;

  final language = Language();
  Securedstorage securedstorage = Securedstorage();
  Firestore_helper firestore_helper = Firestore_helper();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _directionLink = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final GlobalKey<FormState> _createEventkey = GlobalKey<FormState>();

  showMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
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


  Future<String> _createEventId() async
  {
    String userid = await securedstorage.getuserID();
    DateTime dateTime = DateTime.now();
    return "${userid}_Event_${dateTime}";
  }



  _imgFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future<String> uploadAndGetImageUrl() async
  {
    String userid = await securedstorage.getuserID();
    firebase_storage.Reference storagereferance = firebase_storage.FirebaseStorage.instance.ref().child("images/${userid}_image_${DateTime.now()}");

    await storagereferance.putFile(_image!);

    String imgurl = await storagereferance.getDownloadURL();
    return imgurl;
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
              child: Text(
                language.setText("events"),
                style: TextStyle(
                  color: Color(0xFF333c3a),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _createEventkey,
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
                          hintText: language.setText("enter title")),
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
                          hintText: language.setText("enter date")),
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
                          hintText: language.setText("location")),
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
                          hintText: language.setText("enter hyperlink")),
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
                            image: _image == null
                                ?const AssetImage("lib/assets/image_placeholder.png")
                                : Image.file(_image!).image,
                            fit: BoxFit.cover,
                            opacity: 1,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        icon:const Icon(Icons.add),
                        label: Text(language.setText("add image")),
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (20),
                              ),
                            ),
                          ),
                          padding:const MaterialStatePropertyAll(
                            EdgeInsets.only(
                                bottom: 10, top: 10, left: 16, right: 16),
                          ),
                          elevation:const MaterialStatePropertyAll(10),
                          backgroundColor:const MaterialStatePropertyAll(
                            Color(0xFF333c3a),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _imgFromGallery();
                          });
                        },
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.only(left: 10, top: 50),
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
                          hintText: language.setText("enter content")),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ElevatedButton.icon(
                          icon:const Icon(Icons.post_add),
                          label:Text(language.setText("post event")),
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

                            if(_createEventkey.currentState!.validate())
                            {
                              LoadingScreen();
                              String eventId = await _createEventId();
                              String userId = await securedstorage.getuserID();
                              String imgurl = await uploadAndGetImageUrl();
                              FarmEvents event = FarmEvents(eventId, userId, _title.text, imgurl, _location.text, _content.text, _date.text, _directionLink.text);
                              firestore_helper.createEvent(event);
                              showMessage("Event Posted");
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
