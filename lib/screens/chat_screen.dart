import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_firebase/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class _ChatScreenState extends State<ChatScreen> {

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit an App'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => exit(0),
            /*Navigator.of(context).pop(true)*/
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  final _auth = FirebaseAuth.instance;
  String message;
  TextEditingController _controller = TextEditingController();

  void getStream() async {
//    final messages = await _fireStore.collection('messages').getDocuments();
//    for(var doc in messages.documents){
//      print(doc.data);
//    }

    await for (var snapShots in _fireStore.collection('messages').snapshots()) {
      for (var message in snapShots.documents) {
        print(message.data);
      }
    }
  }

  getCurrentUser() async {
    final currentUser = await _auth.currentUser();
    if (currentUser != null) {
      loggedInUser = currentUser;
      print(loggedInUser.email);
    }
    else{
      Navigator.pop(context);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: Text('⚡️Chat'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  _auth.signOut();
                  loggedInUser = null;
                  print(loggedInUser);
                  Navigator.pop(context);
                  //getStream();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
               GettingMessagesAndDisplaying(),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              message = value;
                            },
                            decoration: kMessageTextFieldDecoration),
                      ),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          onPressed: () {
                            if (message != null) {
                              _fireStore.collection('messages').add({
                                'text': message,
                                'sender': loggedInUser.email,
                                'time': DateTime.now()

                              });

                              _controller.clear();
                            }
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(
                                color: Colors.lightBlue, fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GettingMessagesAndDisplaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageListData = [];

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final snapshotData = snapshot.data.documents;
        for (var message in snapshotData) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageTime = message.data["time"];
          final currentUser = loggedInUser.email;
          bool value = currentUser == messageSender;
          final messageData =
          MessageBubble(text: messageText, sender: messageSender,isMe: value,time: messageTime);
          messageListData.add(messageData);
          messageListData.sort((a , b ) => b.time.compareTo(a.time));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListView(
              reverse: true,
              children: messageListData,
            ),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {

  final String text;
  final String sender;
  bool isMe;
  final Timestamp time;

  MessageBubble({this.text, this.sender, this.isMe,this.time});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(

        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8.0),
            child: Text(
              '$sender',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Material(
              borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)):
              BorderRadius.only(topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              elevation: 5,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 16,
                      color: isMe ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
