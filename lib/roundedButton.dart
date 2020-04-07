import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final Function onPress;
  final String text;
  final Color color;

  RoundedButton({this.onPress, this.text,this.color});

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: color,
      elevation: 6,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed:onPress,
        child: Text(
          text,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}


/* Navigator.push(context, MaterialPageRoute(
              builder: (context) => LoginScreen()*/