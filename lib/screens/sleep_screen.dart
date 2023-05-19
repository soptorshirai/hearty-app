import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity_screen.dart';
import 'package:intl/intl.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  late SharedPreferences prefs;
  List<int> sleepStarsEachDay = [0, 0, 0, 0, 0, 0, 0];

  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

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
      sleepStarsEachDay = prefs
              .getStringList('${uid}sleepStarsEachDay')
              ?.map(int.parse)
              .toList() ??
          sleepStarsEachDay;
      hours = prefs.getInt('${uid}hours') ?? hours;
    });
  }

  _savePrefs() async {
    setState(() {
      // save variables to shared preferences
      prefs.setStringList('${uid}sleepStarsEachDay',
          sleepStarsEachDay.map((e) => e.toString()).toList());
      prefs.setInt('${uid}hours', hours);
    });
  }

  @override
  void dispose() {
    _savePrefs();
    super.dispose();
  }

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

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

  int hours = 8; // default selected value

  List<int> dropdownValues = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24
  ]; // list of dropdown values

  int numOfStars(int num) {
    if (num < 4 || num > 20) {
      return 1;
    } else if (num < 7 || num > 14) {
      return 2;
    } else {
      return 3;
    }
  }

  void main() {
    var subscription = Stream.periodic(Duration(seconds: 1), (i) => i)
        .asyncMap((_) => DateTime.now())
        .map((now) => DateFormat.E().format(now))
        .distinct()
        .listen((weekday) {
      hours = 8;
      prefs.setInt('${uid}hours', hours);
    });

    // Cancel the subscription after 10 seconds
    Timer(Duration(seconds: 10), () {
      subscription.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // int dayOfWeek = now.weekday;
    if (now.weekday == DateTime.monday) {
      sleepStarsEachDay = [sleepStarsEachDay[0], 0, 0, 0, 0, 0, 0];
    }

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(220, 1, 10, 58),
            Color.fromRGBO(58, 6, 118, 0.824)
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
            const Text("Sleep",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.w900)),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                // ),
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
                                      // color: Color.fromARGB(
                                      // 255, 244, 172, 196),
                                      color:
                                          Color.fromRGBO(243, 233, 159, 0.824),
                                      child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  'How many hours did you sleep last night?',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        25, 4, 101, 0.824),
                                                  )),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              StatefulBuilder(
                                                ///yipeee!!! use this later in food screen!!!
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return Container(
                                                      width: 160,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Color.fromRGBO(
                                                              25,
                                                              4,
                                                              101,
                                                              0.824),
                                                          width: 4,
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          DropdownButton<int>(
                                                        value: hours,
                                                        onChanged:
                                                            (int? newValue) {
                                                          setState(() {
                                                            hours = newValue!;
                                                          });
                                                        },
                                                        items: dropdownValues
                                                            .map<
                                                                DropdownMenuItem<
                                                                    int>>((int value) =>
                                                                DropdownMenuItem<
                                                                    int>(
                                                                  value: value,
                                                                  child: Text(value
                                                                      .toString()),
                                                                ))
                                                            .toList(),
                                                        icon: Icon(Icons
                                                            .arrow_drop_down_circle),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    25,
                                                                    4,
                                                                    101,
                                                                    0.824),
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        underline: Container(
                                                          height: 0,
                                                          color: Colors
                                                              .transparent,
                                                        ),

                                                        // set the icon
                                                      ));
                                                },
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize: Size(50, 10),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      sleepStarsEachDay[
                                                              now.weekday - 1] =
                                                          numOfStars(hours);
                                                    });
                                                  },
                                                  child: Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))))));
                    },
                    child: Text('Log Hours'),
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 60),
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.white.withOpacity(.75),
                      foregroundColor: Colors.black87,
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            DataTable(
              columns: [
                DataColumn(
                  label: Text('Day', style: TextStyle(color: Colors.white54)),
                ),
                DataColumn(
                    label:
                        Text('Hours', style: TextStyle(color: Colors.white54))),
                // DataColumn(label: Text('Lunch')),
                // DataColumn(label: Text('Dinner')),
              ],
              rows: _buildRows(sleepStarsEachDay),
            ),
          ],
        ),
      ),
    ));
  }
}
