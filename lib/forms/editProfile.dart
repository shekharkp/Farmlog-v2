import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Database_helper/firestore_helper.dart';
import 'package:farmalog/Entities/user.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:farmalog/Database_helper/languages.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final storage = Securedstorage();
  final Firestore_helper firestore_helper = Firestore_helper();

  Future<User> getUserInfo() async {
    var userID = await storage.getuserID();
    var user = await firestore_helper.getUserByID(userID);
    return user;
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

  final language = Language();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _mobileno = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

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
    _username.dispose();
    _password.dispose();
    _mobileno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          const Backgroundcolour(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 250, 20, 40),
            child: Container(
              margin:const EdgeInsets.only(bottom: 6),
              padding:const EdgeInsets.all(40),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color:const Color(0xFFe4e2e5),
                  boxShadow: const[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      offset: Offset(3, 2),
                    )
                  ]),
              child: Column(
                children: [
                   Text(
                    language.setText("profile"),
                    style:const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333c3a)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getUserInfo(),
                          builder: (context, AsyncSnapshot<User> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 200),
                                child: CircularProgressIndicator(color: Color(0xFF333c3a),),
                              );
                            } else if (snapshot.hasData) {
                              _username.text = snapshot.data!.username;
                              _mobileno.text = snapshot.data!.mobileNo.toString();
                              _password.text = snapshot.data!.password;
                              return Column(
                                children: [
                                  FormTextFields(
                                      Title: language.setText("username"),
                                      maxlength: 25,
                                      controller: _username),
                                  FormTextFields(
                                    Title: language.setText("phone number"),
                                    maxlength: 10,
                                    controller: _mobileno,
                                    keyboadtype: TextInputType.phone,
                                  ),
                                  FormTextFields(
                                    Title: language.setText("password"),
                                    controller: _password,
                                    maxlength: 15,
                                  ),
                                ],
                              );
                            } else {
                              _username.text = "Failed to fetch";
                              return const Text("Failed to fetch");
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(45, 15, 45, 15),
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              backgroundColor:
                                 const MaterialStatePropertyAll(Color(0xFF333c3a),),),
                          icon:const Icon(Icons.save_rounded),
                          label:Text(language.setText("save")),
                          onPressed: () async {
                            if(_formkey.currentState!.validate())
                              {
                                if(_password.text.contains(" ") && _mobileno.text.contains(" "))
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Don't put spaces in Mobile Number and Password!!!")));
                                    return;
                                  }
                                LoadingScreen();
                                String userID = await storage.getuserID();
                                User getuser = await firestore_helper.getUserByID(userID);
                                User user = User(getuser.userid, _username.text, getuser.gender, int.parse(_mobileno.text), _password.text,getuser.role);
                                firestore_helper.Updateuser(user);
                                Navigator.of(context).pop(context);
                                Navigator.of(context).pop(context);

                              }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class Backgroundcolour extends StatelessWidget {
  const Backgroundcolour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:const Color(0xFFc4cfdd),
      width: double.maxFinite,
      height: 500,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
      child: const Text(
        "FarmLog",
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class FormTextFields extends StatelessWidget {
  FormTextFields(
      {super.key,
      required this.Title,
      required this.maxlength,
      required this.controller,
      this.keyboadtype,
      this.enable});
  final String Title;
  TextEditingController controller;
  int maxlength;
  TextInputType? keyboadtype;
  bool? enable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Title,
          style:const TextStyle(
              color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboadtype,
            maxLength: maxlength,
            enabled: enable,
            cursorColor: Colors.grey,
            cursorHeight: 15,
            validator: (value) {
              if(value == null || value.isEmpty)
                {
                  return "Required Field!!!";
                }
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none),
            ),
            style: const TextStyle(fontSize: 15, color: Color(0xFF333c3a)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
