import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearty_app/screens/store_screen.dart';
import 'package:hearty_app/screens/survey_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_screen.dart';
import 'package:tuple/tuple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences? prefs;
  List<int> foodStars = [0, 0, 0, 0, 0, 0, 0];
  List<int> activityStars = [0, 0, 0, 0, 0, 0, 0];
  List<int> sleepStars = [0, 0, 0, 0, 0, 0, 0];
  int homeStreak = 0;
  bool firstTime = true;
  DateTime? _lastUpdated;

  late List<String> foodOneStar;
  late List<String> foodTwoStar;
  late List<String> sleepOneStar;
  late List<String> sleepTwoStar;
  late List<String> activityOneStar;
  late List<String> activityTwoStar;
  late List<String> allGood;

  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  @override
  void initState() {
    super.initState();
    _loadprefs();
  }

  _loadprefs() async {
    prefs = await SharedPreferences.getInstance();
    uid = auth.currentUser!.uid;
    setState(() {
      // load variables from shared preferences
      homeStreak = prefs?.getInt('${uid}homeStreak') ?? homeStreak;
      _lastUpdated = prefs!.containsKey('${uid}lastUpdated')
          ? DateTime.parse(prefs!.getString('${uid}lastUpdated')!)
          : null;

      foodStars = prefs
              ?.getStringList('${uid}foodStarsEachDay')
              ?.map(int.parse)
              .toList() ??
          foodStars;
      activityStars = prefs!
              .getStringList('${uid}activityStarsEachDay')
              ?.map(int.parse)
              .toList() ??
          activityStars;
      sleepStars = prefs
              ?.getStringList('${uid}sleepStarsEachDay')
              ?.map(int.parse)
              .toList() ??
          sleepStars;
      firstTime = prefs?.getBool('${uid}firstTime') ?? true;
    });
  }

  _saveprefs() async {
    setState(() {
      // save variables to shared preferences
      prefs?.setStringList('${uid}foodStarsEachDay',
          foodStars.map((e) => e.toString()).toList());
      prefs?.setInt('${uid}homeStreak', homeStreak);
      prefs?.setBool('${uid}firstTime', firstTime);
    });
  }

  @override
  void dispose() {
    _saveprefs();
    super.dispose();
  }

  Tuple2<String, String> returnImage(int food, int activity, int sleep) {
    List<String> angryOnes = [
      'assets/images/AngryAndSquinty.png',
      'assets/images/AngryHandsOnHips.png',
      'assets/images/Frown.png',
      'assets/images/UpsetSguigglyArms.png',
      'assets/images/TongueOut.png'
    ];
    List<String> happyOnes = [
      'assets/images/L_Point.png',
      'assets/images/Party.png',
      'assets/images/R_Point.png',
      'assets/images/StarryEyes.png'
    ];
    List<String> hungryOnes = [
      'assets/images/Malnourished.png',
      'assets/images/Drool1.png',
      'assets/images/Drool2.png',
      'assets/images/Winded.png',
      'assets/images/AngryAndSquinty.png',
      'assets/images/AngryHandsOnHips.png',
      'assets/images/Frown.png',
      'assets/images/UpsetSguigglyArms.png',
      'assets/images/TongueOut.png'
    ];
    List<String> sleepyOnes = [
      'assets/images/Winded.png',
      'assets/images/Tired1.png',
      'assets/images/Tired2.png'
    ];
    Future<String> getName() {
      return FirebaseFirestore.instance
          .collection('myCollection')
          .doc('myDocId')
          .get()
          .then((docSnapshot) => docSnapshot.get('message'));
    }

    foodOneStar = [
      "I am STARVING! Please feed me.",
      "I am so hungry…",
      "I need good food NOW!"
    ];
    // print(foodOneStar);
    foodTwoStar = [
      "I am a bit hungry…",
      "I need better quality food, please",
      "I am still not satisfied. Can you feed me?"
    ];
    sleepOneStar = [
      "My eyes will not stay open any longer…",
      "Please fix my sleep schedule",
      "I NEED SLEEP!"
          "Let me sleep please."
    ];
    sleepTwoStar = ["I'm tired", "Zzzzzzzz...."];
    activityOneStar = [
      "I feel so weak. I should do some exercise.",
      "I need to go outside."
    ];
    activityTwoStar = [
      "I want to exercise"
          "Just a little bit more exercise never hurts anyone..."
    ];
    allGood = [
      "Good job!",
      "I feel amazing!",
      "You are on your way to living a Hearty Life!",
      "You are on your way to living a Hearty Life!"
    ];

    if (prefs?.getBool('${uid}firstTime') ?? firstTime) {
      firstTime = false;
      prefs?.setBool('${uid}firstTime', firstTime);
      return Tuple2(happyOnes[Random().nextInt(happyOnes.length)],
          "Hello there! I am Pip, your new friend. There are several ways to improve both my health and yours! Please select the different tabs at the bottom of the screen to explore heart healthy options. Make sure to log sleep, food, and activity daily. Remember to live the Hearty Life!");
    } else if (food == 1) {
      return Tuple2(hungryOnes[Random().nextInt(hungryOnes.length)],
          foodOneStar[Random().nextInt(foodOneStar.length)]);
    } else if (sleep == 1) {
      return Tuple2(sleepyOnes[Random().nextInt(sleepyOnes.length + 1)],
          sleepOneStar[Random().nextInt(sleepOneStar.length)]);
    } else if (food == 2) {
      return Tuple2(hungryOnes[Random().nextInt(hungryOnes.length)],
          foodTwoStar[Random().nextInt(foodTwoStar.length)]);
    } else if (sleep == 2) {
      return Tuple2(sleepyOnes[Random().nextInt(sleepyOnes.length)],
          sleepTwoStar[Random().nextInt(sleepTwoStar.length)]);
    } else if (activity == 1) {
      return Tuple2(angryOnes[Random().nextInt(angryOnes.length)],
          activityOneStar[Random().nextInt(activityOneStar.length)]);
    } else if (activity == 2) {
      return Tuple2(angryOnes[Random().nextInt(angryOnes.length)],
          activityTwoStar[Random().nextInt(activityTwoStar.length)]);
    } else {
      return Tuple2(happyOnes[Random().nextInt(happyOnes.length)],
          allGood[Random().nextInt(allGood.length)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    String lastDateStr = prefs?.getString('${uid}lastDate') ?? '';

// Convert the last date string to a DateTime object
    DateTime lastDate = lastDateStr.isNotEmpty
        ? DateTime.parse(lastDateStr)
        : DateTime.now().subtract(Duration(days: 1));

// Get the current date
    DateTime currentDate = DateTime.now();

// Check if the current date is one day after the last date the user entered a value
    if (currentDate.difference(lastDate).inDays == 1) {
      // If it is, increment the streak count
      int homeStreak = prefs?.getInt('${uid}homeStreak') ?? 0;
      prefs?.setInt('${uid}homeStreak', homeStreak + 1);
      homeStreak++;
    } else {
      // If it is not, reset the streak count to 1
      prefs?.setInt('${uid}homeStreak', 1);
      homeStreak = 1;
    }

// Save the current date as the last date the user entered a value
    prefs?.setString('${uid}lastDate', currentDate.toString());

    DateTime now = DateTime.now();
    Tuple2<String, String> avatar = returnImage(foodStars[now.weekday - 1],
        activityStars[now.weekday - 1], sleepStars[now.weekday - 1]);

    return Scaffold(
        backgroundColor: Color.fromARGB(234, 246, 174, 245),
        body: Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Streak: ${homeStreak}',
                        ),
                      ]),
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        print("pressed");
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.height,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(234, 246, 174, 245)),
                                    icon: Icon(Icons.logout),
                                    label: Text("Logout"),
                                    onPressed: () {
                                      FirebaseAuth.instance
                                          .signOut()
                                          .then((value) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInScreen()));
                                      });
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(234, 246, 174, 245)),
                                    icon: Icon(Icons.store),
                                    label: Text("Store"),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StoreScreen()));
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(234, 246, 174, 245)),
                                    icon: Icon(Icons.info),
                                    label: Text("Edit Information"),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SurveyScreen()));
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              alignment: Alignment.center,
              // width: 160,
              child: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * .8,
                child: SpeechBubble(text: '${avatar.item2}'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                '${avatar.item1}',
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.width * .9,
              ),
            ),
          ],
        ));
  }
}

class SpeechBubble extends StatelessWidget {
  final String text;

  const SpeechBubble({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              painter: TrianglePainter(
                strokeColor: Colors.white,
                strokeWidth: 20,
                paintingStyle: PaintingStyle.fill,
              ),
              child: Container(
                width: 20,
                height: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    required this.strokeColor,
    required this.paintingStyle,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    final path = Path();
    path.moveTo(40, size.height + 25);
    path.lineTo(size.width + 15, size.height);
    path.lineTo(10, 10);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
