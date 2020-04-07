import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'screens/welcome_screen.dart';



void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        cursorColor: Colors.black,
        accentColor: Colors.pink,
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),

      ),
      home: Hero(
        tag: 'logo_transition',
        child: AnimatedSplash(
          imagePath: 'images/logo.png',
          home: WelcomeScreen(),
          duration: 2500,
          type: AnimatedSplashType.StaticDuration,
        ),
      ),
    );
  }
}


/* theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
    initialRoute: WelcomeScreen.id,
      routes: {
         WelcomeScreen.id      : (context) => WelcomeScreen(),
         LoginScreen.id        : (context) => LoginScreen(),
         ChatScreen.id         : (context) => ChatScreen(),
         RegistrationScreen.id :(context) => RegistrationScreen()
      }*/