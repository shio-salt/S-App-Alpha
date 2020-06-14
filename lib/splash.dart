import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    /*if (FirebaseAuth.instance.currentUser() != null) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/signin");
    }
    Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/signin');
     */
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("S-App", style: TextStyle(fontSize: 40.0)),
              Text("v1.0-Alpha", style: TextStyle(fontSize: 40.0)),
            ],
          ),
        ),
      ),
    );
  }

init() async {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/signin');
      /*FirebaseAuth.instance.currentUser().then((user) => user != null
              ? Navigator.pushReplacementNamed(context, "/home")
              : Navigator.pushReplacementNamed(context, "/login")
          //Navigator.pushReplacementNamed(context, '/signin');
          switch (_authStatus) {
        case AuthStatus.notSignedIn:
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => new SignInScreen(title: 'SignIn', auth: widget.auth)
          ));
          break;
        case AuthStatus.signedUp:
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => new SignUpScreen(title: 'SignUp', auth: widget.auth)
          ));
          break;
        case AuthStatus.signedIn:
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => new HomeScreen(title: 'Home', auth: widget.auth)
          ));
          break;
      }*/
    });
  }
}
