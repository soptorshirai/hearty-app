import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hearty_app/screens/home_screen.dart';

import 'navigation.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  // final _formKey = GlobalKey<FormState>();
  // bool _formSubmitted = false;

  @override
  void initState() {
    super.initState();
  }

  // First screen
  String? _firstName;
  TextEditingController _firstNameController = TextEditingController();
  String? _lastName;
  TextEditingController _lastNameController = TextEditingController();
  int? _selectedSex;
  int? _selectedGender;
  String? _age; // need to cast later as int
  TextEditingController _ageController = TextEditingController();
  String? _height; // need to cast later as int
  TextEditingController _heightController = TextEditingController();
  String? _weight; // need to cast later as int
  TextEditingController _weightController = TextEditingController();
  double _sliderStressLevel = 3;
  bool? _CaloriesIntake;
  String? _sleep; // need to cast later as int
  TextEditingController _sleepController = TextEditingController();
  String? _activity; // need to cast later as int
  TextEditingController _activityController = TextEditingController();
  bool? _selectedFamilyHeartDisease;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedGender(select) {
    if (select == 1) {
      return "Female";
    } else if (select == 2) {
      return "Male";
    } else if (select == 3) {
      return "All";
    } else if (select == 4) {
      return "Prefer not to answer";
    } else {
      return "Not Selected";
    }
  }

  String selectedSex(select) {
    if (select == 1) {
      return "Female";
    } else if (select == 2) {
      return "Male";
    } else {
      return "Not Selected";
    }
  }

  String selectedBloodPressure(select) {
    if (select == 1) {
      return "Low";
    } else if (select == 2) {
      return "Normal";
    } else if (select == 3) {
      return "High";
    } else {
      return "Not Selected";
    }
  }

  String doYouConsume(select) {
    if (select == 1) {
      return "Less";
    } else if (select == 2) {
      return "Equal";
    } else if (select == 3) {
      return "More";
    } else {
      return "Not Selected";
    }
  }

  void addSurveyToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    // setState(() {
    //   _formSubmitted = true;
    // });
    try {
      await FirebaseFirestore.instance
          .collection('SurveyAnswers')
          .doc(user!.email)
          .set({
        'FirstName': _firstName,
        'LastName': _lastName!,
        'Sex': selectedSex(_selectedSex),
        'PreferredGender': selectedGender(_selectedGender),
        'Age': int.parse(_age!),
        'Height': int.parse(_height!),
        'Weight': int.parse(_weight!),
        'Sleep': int.parse(_sleep!),
        'Activity': int.parse(_activity!),
        'FamilyHeartDisease': _selectedFamilyHeartDisease,
        'StressLevel': _sliderStressLevel.toInt(),
        '2000Calories': _CaloriesIntake,
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Survey'),
            content: Text(
                'Part of the survey is incomplete. Please go back and complete them.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _sleepController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(234, 242, 215, 100),
        body: Container(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * .05, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    height: 100,
                    child: const Center(
                      child: Text(
                        // Title of 1st survey screen
                        'Survey',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // First name and last name
                  const Text(
                    'First Name',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        // hintText: 'Answer 2',
                        border: OutlineInputBorder(),
                        labelText: "Enter your first name",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        // fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    controller: _firstNameController,
                    onChanged: (value) {
                      setState(() {
                        _firstName = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Last Name',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  // Sex
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        // hintText: 'Answer 2',
                        border: OutlineInputBorder(),
                        labelText: "Enter your last name",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        // fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    onChanged: (value) {
                      setState(() {
                        _lastName = value;
                      });
                    },
                    controller: _lastNameController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sex assigned at birth',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  // Answer choices for sex
                  SizedBox(height: 10),
                  RadioListTile(
                    title:
                        Text('Female', style: TextStyle(color: Colors.white70)),
                    value: 1,
                    groupValue: _selectedSex,
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value!;
                      });
                      print(_selectedSex);
                    },
                    activeColor: Colors.white70,
                    toggleable: true,
                  ),
                  RadioListTile(
                    title:
                        Text('Male', style: TextStyle(color: Colors.white70)),
                    value: 2,
                    groupValue: _selectedSex,
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value!;
                      });
                      print(_selectedSex);
                    },
                    activeColor: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gender identification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  // Answer choices for sex
                  SizedBox(height: 10),
                  RadioListTile(
                    title:
                        Text('Female', style: TextStyle(color: Colors.white70)),
                    value: 1,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                      print(_selectedGender);
                    },
                    activeColor: Colors.white70,
                    toggleable: true,
                  ),
                  RadioListTile(
                    title:
                        Text('Male', style: TextStyle(color: Colors.white70)),
                    value: 2,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                      print(_selectedGender);
                    },
                    activeColor: Colors.white70,
                  ),
                  RadioListTile(
                    title: Text('All', style: TextStyle(color: Colors.white70)),
                    value: 3,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                      print(_selectedGender);
                    },
                    activeColor: Colors.white70,
                  ),
                  RadioListTile(
                    title: Text('Prefer not to answer',
                        style: TextStyle(color: Colors.white70)),
                    value: 4,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                      print(_selectedGender);
                    },
                    activeColor: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  // Age
                  const Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        // hintText: 'Answer 2',
                        border: OutlineInputBorder(),
                        labelText: "Enter your age",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        // fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _age = value;
                      });
                    },
                    controller: _ageController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Height',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        // hintText: 'Answer 2',
                        border: OutlineInputBorder(),
                        labelText: "Enter your height in inches",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        // fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _height = value;
                      });
                    },
                    controller: _heightController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Weight',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        // hintText: 'Answer 2',
                        border: OutlineInputBorder(),
                        labelText: "Enter your weight in lbs",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        // fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _weight = value;
                      });
                      print(_weight);
                    },
                    controller: _weightController,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Do you generally intake 2000 calories per day?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  RadioListTile(
                    title: Text('Yes', style: TextStyle(color: Colors.white70)),
                    activeColor: Colors.white70,
                    value: true,
                    groupValue: _CaloriesIntake,
                    onChanged: (value) {
                      setState(() {
                        _CaloriesIntake = value!;
                      });
                      print(_CaloriesIntake);
                    },
                  ),
                  RadioListTile(
                    title: Text('No', style: TextStyle(color: Colors.white70)),
                    activeColor: Colors.white70,
                    value: false,
                    groupValue: _CaloriesIntake,
                    onChanged: (value) {
                      setState(() {
                        _CaloriesIntake = value!;
                      });
                      print(_CaloriesIntake);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Time Spent Sleeping Per Night',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter your sleep time in hours",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _sleep = value;
                      });
                    },
                    controller: _sleepController,
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Hours of Activity Per Day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter your activity in hours",
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _activity = value;
                      });
                    },
                    controller: _activityController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Rate your average stress level',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  Slider(
                    activeColor: Colors.white70,
                    inactiveColor: Colors.white12,
                    thumbColor: Colors.white,
                    value: _sliderStressLevel,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _sliderStressLevel.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _sliderStressLevel = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Do you have a family history of hearty disease?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  RadioListTile(
                    title: Text('Yes', style: TextStyle(color: Colors.white70)),
                    activeColor: Colors.white70,
                    value: true,
                    groupValue: _selectedFamilyHeartDisease,
                    onChanged: (value) {
                      setState(() {
                        _selectedFamilyHeartDisease = value!;
                      });
                      print(_selectedFamilyHeartDisease);
                    },
                  ),
                  RadioListTile(
                    title: Text('No', style: TextStyle(color: Colors.white70)),
                    activeColor: Colors.white70,
                    value: false,
                    groupValue: _selectedFamilyHeartDisease,
                    onChanged: (value) {
                      setState(() {
                        _selectedFamilyHeartDisease = value!;
                      });
                      print(_selectedFamilyHeartDisease);
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        if (_firstName != null &&
                            _firstName!.isNotEmpty &&
                            _lastName != null &&
                            _lastName!.isNotEmpty &&
                            _selectedSex != null &&
                            _age != null &&
                            _height != null &&
                            _weight != null &&
                            _activity != null &&
                            _CaloriesIntake != null &&
                            _sleep != null &&
                            _selectedGender != null) {
                          try {
                            addSurveyToFirestore();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navigate()),
                            );
                          } catch (e) {
                            print("catch");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Incomplete Survey'),
                                  content: Text(
                                      'Part of the survey is incomplete. Please go back and complete them.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          print("else");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Incomplete Survey'),
                                content: Text(
                                    'Part of the survey is incomplete. Please go back and complete them.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        print("catch");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Incomplete Survey'),
                              content: Text(
                                  'Part of the survey is incomplete. Please go back and complete them.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      // add code to execute when the button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(234, 242, 215, 100),
                      backgroundColor: Colors.white, // text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Submit"),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              )),
        )));
  }
}
