import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

final double goal = 300;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(220, 119, 208, 228),
              Color.fromRGBO(238, 231, 178, 0.824)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Activity",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivityStarScreen()),
                        );
                      },
                      child: Text('See My Stars'),
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.85, 50),
                        // padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Color.fromRGBO(238, 231, 178, 0.824),
                        foregroundColor: Colors.black87,
                      )),
                  const SizedBox(height: 24),
                  createButton(
                      context, Icons.directions_walk, 'Walking/Hiking', '3-5'),
                  const SizedBox(height: 16),
                  createButton(
                      context, Icons.directions_bike, 'Biking', '11-16'),
                  const SizedBox(height: 16),
                  createButton(
                      context, Icons.directions_run, 'Running', '12-18'),
                  const SizedBox(height: 16),
                  createButton(
                      context, Icons.fitness_center, 'Weight Lifting', '4-9'),
                  const SizedBox(height: 16),
                  createButton(context, Icons.pool, 'Swimming', '12'),
                  const SizedBox(height: 16),
                  createButton(context, Icons.question_mark, 'Other', '1-20'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

ElevatedButton createButton(
    BuildContext context, IconData icon, String text, String cal) {
  return ElevatedButton(
      onPressed: () {
        // showDialog()
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondScreen(text, cal)),
        );
      },
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * .75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white.withOpacity(.75),
        foregroundColor: Colors.black87,
      ));
}

class ActivityStarScreen extends StatefulWidget {
  const ActivityStarScreen({Key? key}) : super(key: key);

  @override
  _ActivityStarScreenState createState() => _ActivityStarScreenState();
}

class _ActivityStarScreenState extends State<ActivityStarScreen> {
  late SharedPreferences prefs;
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  List<int> activityStarsEachDay = [0, 0, 0, 0, 0, 0, 0];
  List<DataRow> _buildRows(List<int> stars) {
    List<DataRow> rows = [];
    for (int i = 0; i < _daysOfWeek.length; i++) {
      rows.add(
        DataRow(cells: [
          DataCell(Text(
            _daysOfWeek[i],
            style: TextStyle(color: Colors.white70),
          )),
          DataCell(Container(
            alignment: Alignment.center,
            child: Row(children: [
              for (int q = 0; q < stars[i]; q++)
                Icon(Icons.star, color: Color.fromARGB(255, 244, 231, 115)),
            ]),
          )),
        ]),
      );
    }
    return rows;
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    uid = auth.currentUser!.uid;
    setState(() {
      // load variables from shared preferences
      activityStarsEachDay = prefs
              .getStringList('${uid}activityStarsEachDay')
              ?.map(int.parse)
              .toList() ??
          activityStarsEachDay;
    });
  }

  _savePrefs() async {
    setState(() {
      // save variables to shared preferences
      prefs.setStringList('${uid}activityStarsEachDay',
          activityStarsEachDay.map((e) => e.toString()).toList());
    });
  }

  @override
  void dispose() {
    _savePrefs();
    super.dispose();
  }

  int findStars(int day) {
    double progress = prefs.getDouble('${uid}progress') ?? 0;
    int streak = prefs.getInt('${uid}streak') ?? 0;
    if (day == 1 && streak == 0) {
      return 2;
    }
    if (day == 2 && progress / goal * 100 < 10) {
      return 1;
    }
    if (day == 2 && progress / goal * 100 < 14) {
      return 2;
    }
    if (day == 3 && progress / goal * 100 < 21) {
      return 1;
    }
    if (day == 3 && progress / goal * 100 < 28) {
      return 2;
    }
    if (day == 4 && progress / goal * 100 < 32) {
      return 1;
    }
    if (day == 4 && progress / goal * 100 < 42) {
      return 2;
    }
    if (day == 5 && progress / goal * 100 < 43) {
      return 1;
    }
    if (day == 5 && progress / goal * 100 < 56) {
      return 2;
    }
    if (day == 6 && progress / goal * 100 < 55) {
      return 1;
    }
    if (day == 6 && progress / goal * 100 < 70) {
      return 2;
    }
    if (day == 7 && progress / goal * 100 < 66) {
      return 1;
    }
    if (day == 7 && progress / goal * 100 < 84) {
      return 2;
    }

    return 3;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // int dayOfWeek = now.weekday;
    if (now.weekday == DateTime.monday) {
      activityStarsEachDay = [activityStarsEachDay[0], 0, 0, 0, 0, 0, 0];
    }
    activityStarsEachDay[now.weekday - 1] = findStars(now.weekday);
    prefs.setStringList('${uid}activityStarsEachDay',
        activityStarsEachDay.map((e) => e.toString()).toList());

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(220, 119, 208, 228),
                Color.fromRGBO(238, 231, 178, 0.824)
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                ),
                const Text("Activity Stars",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 30,
                        fontWeight: FontWeight.w900)),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                DataTable(
                  columns: [
                    DataColumn(
                      label:
                          Text('Day', style: TextStyle(color: Colors.white54)),
                    ),
                    DataColumn(
                        label: Text('Stars',
                            style: TextStyle(color: Colors.white54))),
                  ],
                  rows: _buildRows(activityStarsEachDay),
                ),
              ],
            ),
          ),
        ));
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.text, this.cal);

  String text;
  String cal;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String? _exercise; // need to cast later as int
  TextEditingController _exerciseController = TextEditingController();
  int? _selectedWeather;
  bool _progressUpdated = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  late SharedPreferences prefs;
  double progress = 0;
  int streak = 0;
  DateTime? _lastUpdated;
  bool checked = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    uid = auth.currentUser!.uid;
    setState(() {
      // load variables from shared preferences
      progress = prefs.getDouble('${uid}progress') ?? progress;
      streak = prefs.getInt('${uid}streak') ?? streak;
      _lastUpdated = prefs.containsKey('${uid}lastUpdated')
          ? DateTime.parse(prefs.getString('${uid}lastUpdated')!)
          : null;
      if (_lastUpdated != null &&
          DateTime.now().difference(_lastUpdated!).inHours > 24) {
        streak =
            0; // reset streak if more than 24 hours have passed since last update
        _lastUpdated = DateTime.now();
        prefs.setInt('${uid}streak', streak);
        prefs.setString('${uid}lastUpdated', _lastUpdated!.toIso8601String());
      }
      checked = prefs.getBool('${uid}checked') ?? checked;
    });
  }

  _savePrefs() async {
    setState(() {
      // save variables to shared preferences
      prefs.setDouble('${uid}progress', progress);
      prefs.setInt('${uid}streak', streak);
      prefs.setBool('${uid}checked', checked);
    });
  }

  @override
  void dispose() {
    _savePrefs();
    super.dispose();
  }

  void main() {
    var subscription = Stream.periodic(Duration(seconds: 1), (i) => i)
        .asyncMap((_) => DateTime.now())
        .map((now) => DateFormat.E().format(now))
        .distinct()
        .listen((weekday) {
      if (weekday == 'monday') {
        print("true");
      }
    });

    // Cancel the subscription after 10 seconds
    Timer(Duration(seconds: 10), () {
      subscription.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    if (now.weekday == DateTime.monday) {
      if (!checked) {
        progress = 0;
        checked = true;
      }
    }
    if (now.weekday == DateTime.tuesday) {
      checked = false;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(.8)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(220, 119, 208, 228),
              Color.fromRGBO(238, 231, 178, 0.824)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.17, 20, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white70,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.cal,
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold)),
                                Text('cal/min', style: TextStyle(fontSize: 14))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white70,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.circle, size: 40),
                                    SizedBox(width: 5),
                                    Text(
                                      'Streak',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  '${streak}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: SizedBox(
                                  width: 200,
                                  height: 250,
                                  child: StickyNote(
                                      color:
                                          Color.fromRGBO(179, 242, 171, 0.824),
                                      child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'How many minutes did you exercise?',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                                cursorColor: Colors.black54,
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Enter in minutes",
                                                        labelStyle: TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black54)),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black54))),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _exercise = value;
                                                  });
                                                },
                                                controller: _exerciseController,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white70),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  if (_exercise != null) {
                                                    progress +=
                                                        int.parse(_exercise!);
                                                    streak++;
                                                    _exercise = null;
                                                  }
                                                  _lastUpdated = DateTime.now();
                                                  prefs.setInt(
                                                      '${uid}streak', streak);
                                                  prefs.setString(
                                                      '${uid}lastUpdated',
                                                      _lastUpdated!
                                                          .toIso8601String());
                                                  setState(() {
                                                    _progressUpdated = true;
                                                  });
                                                },
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54)),
                                              ),
                                            ],
                                          ))),
                                ),
                              ),
                              barrierColor: Colors.transparent.withAlpha(200),
                            );
                          },
                          child: Text('Log Time'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(304, 50),
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor:
                                Color.fromRGBO(238, 231, 178, 0.824),
                            foregroundColor: Colors.black87,
                          )),
                      SizedBox(height: 16),
                      Container(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 300.0,
                                  height: 300.0,
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 250.0,
                                          height: 250.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                offset: Offset(0.0, 4.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 1.0,
                                              ),
                                            ],
                                            gradient: SweepGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    220, 119, 208, 228),
                                                Colors.white.withOpacity(.8),
                                              ],
                                              stops: [
                                                0.0,
                                                progress / goal,
                                              ],
                                              startAngle: 0,
                                              endAngle: 2 * pi,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 150.0,
                                                  height: 150.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    "${(progress * 100 / goal).round()}%",
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StickyNote extends StatelessWidget {
  StickyNote({required this.child, this.color = const Color(0xffffff00)});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.01 * pi,
      child: CustomPaint(
          painter: StickyNotePainter(color: color),
          child: Center(child: child)),
    );
  }
}

class StickyNotePainter extends CustomPainter {
  StickyNotePainter({required this.color});

  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    _drawShadow(size, canvas);
    Paint gradientPaint = _createGradientPaint(size);
    _drawNote(size, canvas, gradientPaint);
  }

  void _drawNote(Size size, Canvas canvas, Paint gradientPaint) {
    Path path = new Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    double foldAmount = 0.17;
    path.lineTo(size.width * 3 / 4, size.height);

    path.quadraticBezierTo(size.width * foldAmount * 2, size.height,
        size.width * foldAmount, size.height - (size.height * foldAmount));
    path.quadraticBezierTo(
        0, size.height - (size.height * foldAmount * 1.5), 0, size.height / 4);
    path.lineTo(0, 0);

    canvas.drawPath(path, gradientPaint);
  }

  Paint _createGradientPaint(Size size) {
    Paint paint = new Paint();

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    RadialGradient gradient = new RadialGradient(
        colors: [brighten(color), color],
        radius: 1.0,
        stops: [0.5, 1.1],
        center: Alignment.bottomLeft);
    paint.shader = gradient.createShader(rect);
    return paint;
  }

  void _drawShadow(Size size, Canvas canvas) {
    Rect rect = Rect.fromLTWH(10, 10, size.width - 30, size.height - 30);
    Path path = new Path();
    path.addRect(rect);
    canvas.drawShadow(path, Colors.black.withOpacity(0.7), 10.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

Color brighten(Color c, [int percent = 30]) {
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}
