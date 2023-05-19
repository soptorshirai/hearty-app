import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hearty_app/screens/signin_screen.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';
import 'navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    print('Initializing Splash Screen');
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    checkUserStatus();
  }

  checkUserStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user = firebaseAuth.currentUser;
    if (user == null) {
      print('Redirecting to Sign In screen');
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SignInScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(5, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    } else {
      print('Redirecting to Home screen');
      await Future.delayed(Duration(seconds: 2));
      try {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Navigate(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(5, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      } catch (e) {
        print('An error occurred while navigating: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decor(),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "assets/images/pip_normal.png",
                  width: 300,
                  height: 300,
                ),
                const Text(
                  "HeartyApp",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                const SpinKitFadingCube(
                  color: Colors.red,
                  size: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:hearty_app/screens/signin_screen.dart';
// import '../reusable_widgets/reusable_widget.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 2));
//     _animation = Tween(begin: 0.0, end: 6.0).animate(_controller);
//     _controller.forward();

//     Timer(Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (BuildContext context) => const SignInScreen(),
//       ));
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SpinKitFadingCube spinkit;
//     return Scaffold(
//         body: Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(colors: [
//         Color.fromARGB(255, 214, 191, 200),
//         Color.fromARGB(255, 185, 155, 183),
//         Color.fromARGB(255, 138, 116, 137)
//       ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//       child: Center(
//         child: FadeTransition(
//             opacity: _animation,
//             child: Column(
//               children: <Widget>[
//                 const SizedBox(
//                   height: 100,
//                 ),
//                 logoWidget("assets/images/pip_normal.png", 300, 300),
//                 const Text("HeartyApp",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red,
//                     )),
//                 const SizedBox(
//                   height: 150,
//                 ),
//                 spinkit = const SpinKitFadingCube(
//                   color: Colors.red,
//                   size: 50.0,
//                 )
//               ],
//             )),
//       ),
//     ));
//   }
// }

// // class HomeScreens extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Home Screen'),
// //       ),
// //       body: Center(
// //         child: Text('Welcome to the Home Screen!'),
// //       ),
// //     );
// //   }
// // }
