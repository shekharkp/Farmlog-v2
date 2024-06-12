import 'package:farmalog/pages/appbarNavbar.dart';
import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:flutter/material.dart';
import 'package:farmalog/Database_helper/firestore_helper.dart';
import 'package:farmalog/Database_helper/languages.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final language = Language();
  final storage = Securedstorage();
  final TextEditingController _userid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  LoadingScreen() {
    return showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Center(
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            color: const Color(0xffe4e2e5),),
          child:  Column(
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


  @override
  void dispose() {
    _userid.dispose();
    _password.dispose();
    super.dispose();
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color:const Color(0xFFe4e2e5),
                  boxShadow: const[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      offset: Offset(3, 2),
                    )
                  ],
              ),
              child: Column(
                children: [
                   Text(
                    language.setText("login"),
                    style:const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333c3a),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        FormTextFields(Title: language.setText("userid"),maxlength: 15,controller: _userid,),
                        FormTextFields(Title: language.setText("password"),maxlength: 15,controller: _password,),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () async{
                            if(_formkey.currentState!.validate())
                              {
                                LoadingScreen();
                                Firestore_helper fh = Firestore_helper();
                                final Isuseridpass = await fh.getUserbyIDPass(_userid.text,_password.text);
                                if(Isuseridpass == true)
                                {
                                  await storage.setLoginout("True");
                                  storage.setuserID(_userid.text);
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => appbarNavbar(),),);
                                }
                                else
                                {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong ID or Password")));
                                }
                              }
                          },
                          style: ButtonStyle(
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.fromLTRB(45, 15, 45, 15),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            backgroundColor:const MaterialStatePropertyAll(Color(0xFF333c3a))
                          ),
                          icon:const Icon(Icons.login_rounded),
                          label:Text(language.setText("login")),
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
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold,),
      ),
    );
  }
}

class FormTextFields extends StatelessWidget {
   FormTextFields({super.key,required this.Title,required this.controller,required this.maxlength});
  final String Title;
  TextEditingController controller;
  int maxlength;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(
          Title,
          style:const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.grey,
            cursorHeight: 15,
            maxLength: maxlength,
            validator: (value) {
              if(value == null || value.isEmpty)
                {
                  return "Field is required";
                }
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              counterText: "",
              contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide.none),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
