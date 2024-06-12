import 'package:farmalog/Database_helper/securedStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:farmalog/forms/loginForm.dart';
import 'forms/registerForm.dart';
import 'package:farmalog/pages/appbarNavbar.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:farmalog/Database_helper/languages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final storage = Securedstorage();

  verifyLogin() async {
    String? isLogin = await storage.getLoginout();
    return isLogin;
  }



  @override
  void initState() {
    verifyLogin();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Poppins"),
        home: FutureBuilder(
          future: verifyLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return snapshot.data == "True"
                  ? const appbarNavbar()
                  : const MyHomePage();
            } else {
              return const Scaffold(
                body: Text("Something went wrong"),
              );
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final language = Language();
  final storage = Securedstorage();
  bool isShowingContainer = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: const Text("Do you really wanted to exit!!!"),
              backgroundColor: const Color(0xFFe4e2e5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF333c3a),
                    ),
                  ),
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF333c3a),
                    ),
                  ),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        );
        return true;
      },
      child: Scaffold(
        backgroundColor:const Color(0xFFe4e2e5),
        body: Stack(
          children:[
            SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 500,
                      decoration: const BoxDecoration(
                        color: Color(0xFFc4cfdd),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60),
                        ),
                      ),
                    ),
                    Container(
                      height: 400,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Lottie.asset(
                        "lib/assets/Mv5y4SKQga.json",
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 60),
                  child:  Column(
                    children: [
                      Text(
                        "FarmLog",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Color(0xFF333c3a),
                        ),
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        language.setText("app description"),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: Color(0xFF333c3a), fontFamily: "Sans"),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginForm(),
                                ));
                          },
                          icon:const Icon(
                            Icons.login_outlined,
                            size: 15,
                            color: Color(0xFF333c3a),
                          ),
                          label:Text(
                            language.setText("login"),
                            style:const TextStyle(
                              color: Color(0xFF333c3a),
                            ),
                          ),
                          style: ButtonStyle(
                              padding:const MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(45, 15, 45, 15),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Color(0xFFc4cfdd)),
                              elevation:const MaterialStatePropertyAll(10),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>const RegisterForm(),
                                ));
                          },
                          icon:const Icon(
                            Icons.app_registration_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: Text(
                            language.setText("register"),
                            style:const TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                          ),
                          style: ButtonStyle(
                              padding:const MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(45, 15, 45, 15),
                              ),
                              elevation:const MaterialStatePropertyAll(10),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Color(0xFF333c3a))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

            //language container

            !isShowingContainer ? Container() : Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.black54,
              child: Center(
                child: Container(
                  height: 400,
                  width: 350,
                  decoration: BoxDecoration(color: Color(0xFFe4e2e5),borderRadius: BorderRadius.all(Radius.circular(20),),),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        const Text("Select Language",style: TextStyle(
                            color: Color(0xFF333c3a),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 70,),
                        ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(55, 15, 55, 15),
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              backgroundColor:const MaterialStatePropertyAll(Color(0xFF333c3a))
                          ),
                          onPressed: () async{
                           await storage.setLanguage("Marathi");
                           await language.getLanguage();
                            isShowingContainer = false;
                            setState(() {
                            });
                          }, child: Text("मराठी"),),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.fromLTRB(60, 15, 60, 15),
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              backgroundColor:const MaterialStatePropertyAll(Color(0xFF333c3a))
                          ),
                          onPressed: () async{
                             await storage.setLanguage("Hindi");
                             await language.getLanguage();
                            isShowingContainer = false;
                            Future.delayed(Duration(seconds: 1),() {

                            },);
                            setState(() {
                          });
                          }, child: Text("हिंदी"),),
                        SizedBox(height: 20,),
                        ElevatedButton(
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
                          onPressed: () async{
                            await storage.setLanguage("English");
                            await language.getLanguage();
                            isShowingContainer = false;
                            setState(() {
                            });

                          }, child: Text("English"),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    ],
        ),
      ),
    );
  }
}
