// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chatapp/models/Contact.dart';
import 'package:chatapp/models/Message.dart';

import '../service/contact.dart';

class LocalMessage {
  final String message;
  final bool mine;
  final DateTime time;

  LocalMessage({
    required this.message,
    required this.mine,
    required this.time,
  });
}

class Chat extends StatefulWidget {
  final ContactDetail contact;
  final int id;

  Chat({required this.contact,required this.id,super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<LocalMessage> messages = [];

  @override
  initState(){
    messages.add(LocalMessage(message: "Hi How are You?", mine: true, time: DateTime.now()));
    messages.add(LocalMessage(message: "I am fine what about you?", mine: false, time: DateTime.now()));
    messages.add(LocalMessage(message: "I am fine too", mine: true, time: DateTime.now()));
    messages.add(LocalMessage(message: "What do we have to do for MGT J component????", mine: false, time: DateTime.now()));
  }

  void sendMessage(String message){
    setState((){    
     messages.add(LocalMessage(message: message, mine: true, time: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.user.username),
        leading: Hero(
          tag: widget.id,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
            ),
          )
        ),
      ),

      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      
          Expanded(
            child: DisplayChat(messages:messages)
          ),
      
          SizedBox(
            height: 2,
          ),
      
          MessageField(sendMessage:sendMessage),
        ],
      ),
    );
  }
}


class DisplayChat extends StatelessWidget {

  final List<LocalMessage> messages;

  DisplayChat({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom:2.0),
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.only(top: 3,bottom: 3),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
            child: Align(
              alignment: (messages[messages.length-(1+index)].mine?Alignment.topRight:Alignment.topLeft),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (messages[messages.length-(1+index)].mine?Colors.blue[200]:Colors.grey.shade200),
                ),
                padding: EdgeInsets.all(16),
                child: Text(messages[messages.length-(1+index)].message, style: TextStyle(fontSize: 15),),
              ),
            ),
          );
        }
      ),
    );

  }
}

class MessageField extends StatelessWidget {

  final sendMessage;

  MessageField({required this.sendMessage,super.key});

  TextEditingController _messageText = TextEditingController();


  void send(String message){
    print("messaging ${message}");
    sendMessage(message);
    _messageText.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: TextField(
              controller: _messageText,
          
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decorationThickness: 0
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Message...",
                contentPadding: EdgeInsets.fromLTRB(8, 1, 3, 1),
              
              ),
            ),
          ),
        ),

        IconButton(onPressed: (){
            send(_messageText.text);
          }, 
          icon: Icon(Icons.send)
        )
      ],
    );
  }
}