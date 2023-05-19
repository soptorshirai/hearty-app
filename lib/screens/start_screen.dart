import 'package:flutter/material.dart';
import 'package:hearty_app/screens/signin_screen.dart';
import 'package:hearty_app/screens/survey_screen.dart';
import '../reusable_widgets/reusable_widget.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SurveyScreen())),
            child: Scaffold(
                body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: decor(),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                20,
                                MediaQuery.of(context).size.height * 0.15,
                                20,
                                0),
                            child: Column(children: <Widget>[
                              const Text("Now just a short survey...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(179, 231, 68, 68),
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              logoWidget(
                                  "assets/images/pip_normal.png", 300, 300),
                              const SizedBox(
                                height: 50,
                              ),
                              const Text("Tap anywhere to continue",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(179, 231, 68, 68),
                                      fontSize: 25)),
                            ])))))));
  }
  /*Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 214, 191, 200),
              Color.fromARGB(255, 185, 155, 183),
              Color.fromARGB(255, 138, 116, 137)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.15, 20, 0),
                    child: Column(children: <Widget>[
                      const Text("Welcome to Hearty",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(179, 231, 68, 68),
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      logoWidget("assets/images/pip_normal.png", 300, 300),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text("Tap anywhere to continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(179, 231, 68, 68),
                              fontSize: 25)),
                      GestureDetector(onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      })
                    ])))));
  }*/
}
