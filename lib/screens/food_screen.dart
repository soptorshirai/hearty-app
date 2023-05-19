import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:intl/intl.dart';

import 'activity_screen.dart';

int num1 = 4;
int num2 = 4;
int num3 = 4;

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  // variables to store user preferences
  late SharedPreferences prefs;
  List<int> foodStarsEachDay = [0, 0, 0, 0, 0, 0, 0];
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  // breakfast
  bool bgrains = false;
  bool bprotein_dairy = false;
  bool bfruits = false;
  bool bchecked = false;
  bool saveb = false;

  // lunch
  bool lgrains = false;
  bool lprotein = false;
  bool lvegetable_fruit = false;
  bool lchecked = false;
  bool savel = false;

  // dinner
  bool dgrains = false;
  bool dprotein = false;
  bool dvegetable = false;
  bool dchecked = false;
  bool saved = false;

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
      foodStarsEachDay = prefs
              .getStringList('${uid}foodStarsEachDay')
              ?.map(int.parse)
              .toList() ??
          foodStarsEachDay;

      bgrains = prefs.getBool('${uid}bgrains') ?? bgrains;
      bprotein_dairy = prefs.getBool('${uid}bprotein_dairy') ?? bprotein_dairy;
      bfruits = prefs.getBool('${uid}bfruits') ?? bfruits;
      bchecked = prefs.getBool('${uid}bchecked') ?? bchecked;
      saveb = prefs.getBool('${uid}saveb') ?? saveb;

      lgrains = prefs.getBool('${uid}lgrains') ?? lgrains;
      lprotein = prefs.getBool('${uid}lprotein') ?? lprotein;
      lvegetable_fruit =
          prefs.getBool('${uid}lvegetable_fruit') ?? lvegetable_fruit;
      lchecked = prefs.getBool('${uid}lchecked') ?? lchecked;
      savel = prefs.getBool('${uid}savel') ?? savel;

      dgrains = prefs.getBool('${uid}dgrains') ?? dgrains;
      dprotein = prefs.getBool('${uid}dprotein') ?? dprotein;
      dvegetable = prefs.getBool('${uid}dvegetable') ?? dvegetable;
      dchecked = prefs.getBool('${uid}dchecked') ?? dchecked;
      saved = prefs.getBool('${uid}saved') ?? saved;
    });
  }

  _savePrefs() async {
    setState(() {
      // save variables to shared preferences
      prefs.setStringList('${uid}foodStarsEachDay',
          foodStarsEachDay.map((e) => e.toString()).toList());

      prefs.setBool('${uid}bgrains', bgrains);
      prefs.setBool('${uid}bprotein_dairy', bprotein_dairy);
      prefs.setBool('${uid}bfruits', bfruits);
      prefs.setBool('${uid}bchecked', bchecked);
      prefs.setBool('${uid}saveb', saveb);

      prefs.setBool('${uid}lgrains', lgrains);
      prefs.setBool('${uid}lprotein', lprotein);
      prefs.setBool('${uid}lvegetable_fruit', lvegetable_fruit);
      prefs.setBool('${uid}lchecked', lchecked);
      prefs.setBool('${uid}savel', savel);

      prefs.setBool('${uid}dgrains', dgrains);
      prefs.setBool('${uid}dprotein', dprotein);
      prefs.setBool('${uid}dvegetable', dvegetable);
      prefs.setBool('${uid}dchecked', dchecked);
      prefs.setBool('${uid}saved', saved);
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

  List<DataRow> _buildRows(List<int> nums) {
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
              for (int q = 0; q < nums[i]; q++)
                Icon(Icons.star, color: Color.fromARGB(255, 244, 231, 115)),
            ]),
          )),
        ]),
      );
    }
    return rows;
  }

  int sumOfBools(bool one, bool two, bool three) {
    int count = 0;
    // print(one);
    // print(two);
    // print(three);
    if (one) {
      count++;
    }
    if (two) {
      count++;
    }
    if (three) {
      count++;
    }
    if (count == 0) {
      count = 4;
    }
    return count;
  }

  int numOfStars(String button) {
    int result = 0;
    int count = 0;

    // if (button == 'Saveb') {
    num1 = sumOfBools(bgrains, bprotein_dairy, bfruits);
    // } else if (button == 'Savel') {
    num2 = sumOfBools(lgrains, lvegetable_fruit, lprotein);
    // } else if (button == 'Saved') {
    num3 = sumOfBools(dgrains, dprotein, dvegetable);
    // }

    if (num1 != 4) {
      result += num1;
      count++;
    } else if (bchecked) {
      count++;
    }
    if (num2 != 4) {
      result += num2;
      count++;
    } else if (lchecked) {
      count++;
    }
    if (num3 != 4) {
      result += num3;
      count++;
    } else if (dchecked) {
      count++;
    }
    print(result);
    if (count != 0) {
      return result ~/ count;
    }
    return count;
  }

  bool isChecked = false;

  void main() {
    var subscription = Stream.periodic(Duration(seconds: 1), (i) => i)
        .asyncMap((_) => DateTime.now())
        .map((now) => DateFormat.E().format(now))
        .distinct()
        .listen((weekday) {
      print("change");
      num1 = 4;
      num2 = 4;
      num3 = 4;
      bchecked = false;
      lchecked = false;
      dchecked = false;
      bgrains = false;
      bprotein_dairy = false;
      bfruits = false;
      saveb = false;
      lgrains = false;
      lprotein = false;
      lvegetable_fruit = false;
      savel = false;
      dgrains = false;
      dprotein = false;
      dvegetable = false;
      saved = false;
      prefs.setBool('${uid}bgrains', false);
      prefs.setBool('${uid}bprotein_dairy', false);
      prefs.setBool('${uid}bfruits', false);
      prefs.setBool('${uid}bchecked', false);
      prefs.setBool('${uid}saveb', false);

      prefs.setBool('${uid}lgrains', false);
      prefs.setBool('${uid}lprotein', false);
      prefs.setBool('${uid}lvegetable_fruit', false);
      prefs.setBool('${uid}lchecked', false);
      prefs.setBool('${uid}savel', false);

      prefs.setBool('${uid}dgrains', false);
      prefs.setBool('${uid}dprotein', false);
      prefs.setBool('${uid}dvegetable', false);
      prefs.setBool('${uid}dchecked', false);
      prefs.setBool('${uid}saved', false);
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
      foodStarsEachDay = [foodStarsEachDay[0], 0, 0, 0, 0, 0, 0];
    }
    // print('grains ${bgrains}');
    // print('pro ${bprotein_dairy}');
    // print('fruit ${bfruits}');

    // main();
    // starsEachDay[now.weekday - 1] = numOfStars('Saveb');
    // starsEachDay[now.weekday - 1] = numOfStars('Savel');
    // starsEachDay[now.weekday - 1] = numOfStars('Saved');

    Transform buildButtons(String text, bool change, bool torf, {bool? col}) {
      return Transform.scale(
        scale: .8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: Size(50, 10), backgroundColor: Colors.white70),
          onPressed: () {
            setState(() {
              if (torf) {
                change = true;
              } else {
                change = false;
              }
            });
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      );
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
            Color.fromARGB(255, 248, 178, 88),
            Color.fromARGB(255, 247, 141, 176),
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
            const Text("Food",
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
                                  height: 290,
                                  child: StickyNote(
                                      // color: Color.fromARGB(
                                      // 255, 244, 172, 196),
                                      color:
                                          Color.fromRGBO(243, 243, 113, 0.824),
                                      child: Container(
                                          width: 240,
                                          height: 290,
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Did your breakfast consist of...'),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: 60,
                                                      child: Text(
                                                        'Grains',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    StatefulBuilder(builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setState) {
                                                      return Switch(
                                                        activeColor:
                                                            Colors.white,
                                                        value: bgrains,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            bgrains = value;
                                                          });
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                            width: 60,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Protein',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  'and',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  'Dairy',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                    StatefulBuilder(builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setState) {
                                                      return Switch(
                                                        activeColor:
                                                            Colors.white,
                                                        value: bprotein_dairy,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            bprotein_dairy =
                                                                value;
                                                          });
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: 60,
                                                      child: Text(
                                                        'Fruit',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    StatefulBuilder(builder:
                                                        (BuildContext context,
                                                            StateSetter
                                                                setState) {
                                                      return Switch(
                                                        activeColor:
                                                            Colors.white,
                                                        value: bfruits,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            bfruits = value;
                                                          });
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize: Size(50, 10),
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        saveb = true;
                                                        bchecked = true;
                                                        Navigator.of(context)
                                                            .pop();
                                                        foodStarsEachDay[
                                                                now.weekday -
                                                                    1] =
                                                            numOfStars('Saveb');
                                                      });
                                                    },
                                                    child: Text(
                                                      'Save',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                )
                                              ]))))));
                    },
                    child: Text('Breakfast'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.white.withOpacity(.75),
                      foregroundColor: Colors.black87,
                    )),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: SizedBox(
                                  width: 200,
                                  height: 290,
                                  child: StickyNote(
                                      // color: Color.fromARGB(
                                      // 255, 244, 172, 196),
                                      color:
                                          Color.fromRGBO(247, 192, 104, 0.824),
                                      child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  'Did your lunch consist of...'),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      'Grains',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                    return Switch(
                                                      activeColor: Colors.white,
                                                      value: lgrains,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          lgrains = value;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                          width: 60,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Vegetable',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                'and',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                'Protein',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                    return Switch(
                                                      activeColor: Colors.white,
                                                      value: lvegetable_fruit,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          lvegetable_fruit =
                                                              value;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      'Protein',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                    return Switch(
                                                      activeColor: Colors.white,
                                                      value: lprotein,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          lprotein = value;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Transform.scale(
                                                    scale: 1.3,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        fixedSize: Size(50, 10),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          savel = true;
                                                          lchecked = true;
                                                          Navigator.of(context)
                                                              .pop();
                                                          foodStarsEachDay[
                                                                  now.weekday -
                                                                      1] =
                                                              numOfStars(
                                                                  'Savel');
                                                        });
                                                      },
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ))))));
                    },
                    child: Text('Lunch'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.white.withOpacity(.75),
                      foregroundColor: Colors.black87,
                    )),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: SizedBox(
                                  width: 200,
                                  height: 290,
                                  child: StickyNote(
                                      // color: Color.fromARGB(
                                      // 255, 244, 172, 196),
                                      color: Color.fromARGB(255, 245, 132, 170),
                                      child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  'Did your dinner consist of...'),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      'Grains',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                    return Switch(
                                                      activeColor: Colors.white,
                                                      value: dgrains,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dgrains = value;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 60,
                                                        child: Text(
                                                          'Protein',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                    return Switch(
                                                      activeColor: Colors.white,
                                                      value: dprotein,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dprotein = value;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      'Vegetable',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                    return Switch(
                                                      activeColor: Colors.white,
                                                      value: dvegetable,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dvegetable = value;
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Transform.scale(
                                                    scale: 1.3,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        fixedSize: Size(50, 10),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          saved = true;
                                                          dchecked = true;
                                                          Navigator.of(context)
                                                              .pop();
                                                          foodStarsEachDay[
                                                                  now.weekday -
                                                                      1] =
                                                              numOfStars(
                                                                  'Saved');
                                                        });
                                                      },
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ))))));
                    },
                    child: Text('Dinner'),
                    style: ElevatedButton.styleFrom(
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
              height: 40,
            ),
            Text(
              'Weekly Log of Food Quality',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            DataTable(
              columns: [
                DataColumn(
                  label: Text('Day', style: TextStyle(color: Colors.white70)),
                ),
                DataColumn(
                    label: Text('Meal Quality',
                        style: TextStyle(color: Colors.white70))),
                // DataColumn(label: Text('Lunch')),
                // DataColumn(label: Text('Dinner')),
              ],
              rows: _buildRows(foodStarsEachDay),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    ));
  }
}
