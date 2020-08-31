import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
User cu;
class ChatScreen extends StatefulWidget {
  static const String id="chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth=FirebaseAuth.instance;
  final store=Firestore.instance;

String message;

  void currentUser()async
  {
    final lu= await auth.currentUser;
    if(lu!=null)
      {
cu=lu;
      }
  }
//  void getMessages ()async
//  {
//  await for(var sanpshots in store.collection('message').snapshots())
//    for(var messages in sanpshots.documents)
//    {
//      print(messages.data());
//    };
//
//  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            StreamBuilder<QuerySnapshot>(stream: store.collection('messages').orderBy('date').snapshots(),builder: (context,snapshot)
              {
                if(!snapshot.hasData){

                Center(child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),);

                }
                final messages=snapshot.data.docs;
                List<Widget> ml=[];
                for(var message in messages)
                  {
                    final messaget=message.get('text');
                    final sender=message.get('email');
                    final widget=Text('$messaget ',style: TextStyle(fontSize: 20),);
                    ml.add(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:send(sender: sender, widget: widget)
                      )
                    );

                  }
                return Expanded(
                  child: ListView(
                    children: ml
                  ),
                );
              },),



            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black
                      ),
                      onChanged: (value) {
                        print(value);
                       message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print("pressed");


                      store.collection('messages').add({'email':cu.email,'text':message,'date':DateTime.now()});
                     
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );





  }
}

class send extends StatelessWidget {
  const send({
    Key key,
    @required this.sender,
    @required this.widget,
  }) : super(key: key);

  final  sender;
  final Text widget;

  @override
  Widget build(BuildContext context) {
    if(sender==cu.email)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(sender),
        Material(


          color: Colors.lightBlueAccent,
          borderRadius:BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
          elevation: 5,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ],
    );


    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender),
          Material(


            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget,
            ),
          ),
        ],
      );
    };

  }
}

