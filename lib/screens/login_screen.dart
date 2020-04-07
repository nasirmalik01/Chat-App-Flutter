import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_firebase/constants.dart';
import 'package:flash_chat_firebase/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
final _scaffoldKey = GlobalKey<ScaffoldState>();
final _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        //resizeToAvoidBottomPadding: false,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo_transition',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email field is mandatory';
                    }
                    return null;
                  },
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kInputDecorationTextField,
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password field is mandatory';
                    }
                    return null;
                  },
                  controller: _controller2,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputDecorationTextField.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {}
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final signInUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (signInUser != null) {
                            print('Log in Successfully');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen()));
                            _controller.clear();
                            _controller2.clear();
                            email = null;
                            password = null;
                            setState(() {
                              showSpinner = false;
                            });
                          } else {
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        } catch (e) {
                          print('error ' + e.toString());
                          setState(() {
                            showSpinner = false;
                          });


                          if(e.message == 'There is no user record corresponding to this identifier. The user may have been deleted.')
                            {
                              SnackbarError(errorMessage: 'You are not registered');
                            }
                          if(e.message == 'The password is invalid or the user does not have a password.'){
                           SnackbarError(errorMessage: 'Password invalid. Try again');
                          }

                          if(e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.'){
                           SnackbarError(errorMessage: 'Connection Timeout. Try Again');
                          }

                          if(e.message =='The email address is badly formatted.'){
                           SnackbarError(errorMessage: 'Email Address is bady formatted');
                          }



//                          if (password.length < 6) {
//
//                            _scaffoldKey.currentState.showSnackBar(
//                                new SnackBar(
//                                    content: new Text('Password should be more than 6 characters',
//                                    style: TextStyle(
//                                      color:Colors.white
//                                    ),),
//                                   backgroundColor: Color(0xFF323232),
//                                )
//                            );
//                          }
                        }
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


void SnackbarError({String errorMessage}){
  _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: new Text(errorMessage,
          style: TextStyle(
              color:Colors.white
          ),),
        backgroundColor: Color(0xFF323232),
      )
  );
}
