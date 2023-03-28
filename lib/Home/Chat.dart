import 'package:chatapp/models/Contact.dart';
import 'package:chatapp/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Chat extends StatelessWidget {
  final Contact contact;

  const Chat({required this.contact,super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Akash Raj ST"),
        leading: Hero(
          tag: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(backgroundImage: NetworkImage("https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")),
          )
        ),
      ),

      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      
          Expanded(child: DisplayChat()),
      
          SizedBox(
            height: 2,
          ),
      
          MessageField(),
        ],
      ),
    );
  }
}


class DisplayChat extends StatelessWidget {
  DisplayChat({super.key});

   List<Message> messages = [
      Message(message: "hi... How are you???", isUser: true, createdAt: DateTime.now()),
      Message(message: "I am Fine.", isUser: false, createdAt: DateTime.now()),
      Message(message: "What about you?", isUser: false, createdAt: DateTime.now()),
      Message(message: "I am fine too. What happened at MG auditorium during Orientation", isUser: true, createdAt: DateTime.now()),
       Message(message: "hi... How are you???", isUser: true, createdAt: DateTime.now()),
      Message(message: "I am Fine.", isUser: false, createdAt: DateTime.now()),
      Message(message: "What about you?", isUser: false, createdAt: DateTime.now()),
      Message(message: "I am fine too. What happened at MG auditorium during Orientation", isUser: true, createdAt: DateTime.now()),
       Message(message: "hi... How are you???", isUser: true, createdAt: DateTime.now()),
      Message(message: "I am Fine.", isUser: false, createdAt: DateTime.now()),
      Message(message: "What about you?", isUser: false, createdAt: DateTime.now()),
      Message(message: "I am fine too. What happened at MG auditorium during Orientation", isUser: true, createdAt: DateTime.now()),
    ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:2.0),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 3,bottom: 3),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
            child: Align(
              alignment: (messages[index].isUser?Alignment.topRight:Alignment.topLeft),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (messages[index].isUser?Colors.blue[200]:Colors.grey.shade200),
                ),
                padding: EdgeInsets.all(16),
                child: Text(messages[index].message, style: TextStyle(fontSize: 15),),
              ),
            ),
          );
        }
      ),
    );
  }
}

class MessageField extends StatelessWidget {

  MessageField({super.key});

  TextEditingController _messageText = TextEditingController();


  void sendMessage(String message){
    print("messageing ${message}");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
            sendMessage(_messageText.text);
          }, 
          icon: Icon(Icons.send)
        )
      ],
    );
  }
}