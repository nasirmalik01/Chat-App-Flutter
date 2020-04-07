import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_firebase/roundedButton.dart';
import 'package:flash_chat_firebase/screens/chat_screen.dart';
import 'package:flash_chat_firebase/screens/login_screen.dart';
import 'package:flash_chat_firebase/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  AnimationController animation;

  static const String id = 'welcome_screen'; //static field can only be accessed by its class and not by its object

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;

  void checkUser() async{
    final currentUser = await _auth.currentUser();
    if(currentUser != null){
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ChatScreen()
      ));
    }
  }
  @override
  void initState() {
    super.initState();

    checkUser();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = ColorTween(begin: Colors.white70, end: Colors.white)
        .animate(controller);

    controller.forward();

//    animation.addStatusListener((status){
//      if(status == AnimationStatus.completed){
//        controller.reverse(from: 1.0);
//      }else if(status == AnimationStatus.dismissed){
//        controller.forward();
//      }
//    });

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: animation.value,
        /*Colors.white.withOpacity(controller.value)*/
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                      tag: 'logo_transition',
                      child: Container(
                          child: Image(
                            image: AssetImage('images/logo.png'),
                          ),
                          height: controller.value * 85)),
                  SizedBox(
                    width: 250.0,
                    child: ColorizeAnimatedTextKit(
                        text: ['Flash Chat'],
                        textStyle: TextStyle(
                            fontSize: 45.0, fontWeight: FontWeight.w900),
                        colors: [
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                        ],
                        textAlign: TextAlign.start,
                        alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              RoundedButton(onPress: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LoginScreen()
                ));
              },
                text: 'Log In',
                color:Color(0xFF40C4FF),
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton(onPress: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RegistrationScreen()
                ));
              },
                text: 'Register',
                color:Color(0xFF448AFF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


