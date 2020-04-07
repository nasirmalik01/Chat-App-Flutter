import 'package:flash_chat_firebase/constants.dart';
import 'package:flash_chat_firebase/screens/chat_screen.dart';
import 'package:flash_chat_firebase/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

final _scaffoldKey = GlobalKey<ScaffoldState>();
final _formKey = GlobalKey<FormState>();

class _RegistrationScreenState extends State<RegistrationScreen> {
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
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: 'logo_transition',
                      child: Container(
                        height: 200.0,
                        child: Image.asset('images/logo.png'),
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
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kInputDecorationTextField),
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
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kInputDecorationTextField.copyWith(
                            hintText: 'Enter your password')),
                    SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {}
                            setState(() {
                              showSpinner = true;
                            });

                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);

                              if (newUser != null) {
                                print('User registered successfully');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen()));
                                setState(() {
                                  showSpinner = false;
                                  _controller.clear();
                                  _controller2.clear();
                                });
                              } else {
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                              setState(() {
                                showSpinner = false;
                              });

                              if(e.message == 'The given password is invalid. [ Password should be at least 6 characters ]')
                              SnackbarError(errorMessage: 'Password should be atleast 6 characters');

                              if(e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.'){
                                SnackbarError(errorMessage: 'Connection Timeout. Try Again');
                              }


                              if(e.message =='The email address is badly formatted.'){
                                SnackbarError(errorMessage: 'Email Address is bady formatted');
                              }

                              if(e.message == 'The email address is already in use by another account.'){
                                SnackbarError(errorMessage: 'The Email Address is already in use by another account');
                              }


                            }



                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
