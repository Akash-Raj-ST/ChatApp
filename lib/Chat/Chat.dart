// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chatapp/models/Message.dart';

import '../models/Msg.dart';
import '../models/User.dart';
import '../service/contact.dart';
import '../service/message.dart';


class Chat extends StatefulWidget {
  final User contact;
  final User user;
  final int id;

  Chat({required this.contact,required this.user,required this.id,super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Msg> messages = [];
  late MessageService _messageService;

  StreamSubscription<GraphQLResponse<Message>>? subscription;

  @override
  initState(){

    _messageService = MessageService();
    initialize();
    print("initialized");
  }

  Future initialize() async{

    await _messageService.init(user: widget.user,contact: widget.contact);

    // messages.add(Msg(message: "Hi How are You?", mine: true, time: DateTime.now()));
    // messages.add(Msg(message: "I am fine what about you?", mine: false, time: DateTime.now()));
    // messages.add(Msg(message: "I am fine too", mine: true, time: DateTime.now()));
    // messages.add(Msg(message: "What do we have to do for MGT J component????", mine: false, time: DateTime.now()));

    List<Msg> allMessages = await _messageService.getMessages();
    setState(() {
      messages = allMessages;
      print(messages);
    });

    String user1 = widget.user.id;
    String user2 = widget.contact.id; 

    int res = user1.compareTo(user2);

    if(res>0){
      String temp = user1;
      user1 = user2;
      user2 = temp;
    }

    String chatID = user1+user2;

    String messageID = _messageService.chatMessageObject?.id??"";
    await subscribeByMessageID(messageID);
  }

  Future<void> subscribeByMessageID(String messageID) async {
    const graphQLDocument = r'''
        subscription MySubscription {
          onUpdateMessage(filter: {id: {eq: "5156e203-25eb-4640-8618-b0392f0d1333"}}) {
            messages {
              message
              time
              userID
            }
          }
        }
      ''';
    final Stream<GraphQLResponse<String>> operation = Amplify.API.subscribe(
      GraphQLRequest<String>(
        document: graphQLDocument, 
        variables: <String, String>{'id': messageID},
      ),
      onEstablished: () => print('Subscription established'),
    );

    try {
      await for (var event in operation) {
        print('Subscription event data received: ${event.data}');
        
        if(event==null){
          print("Event in null!!!");
        }else{
          var tagObjsJson = jsonDecode(event.data!)["onUpdateMessage"]["messages"] as List;
          print("tags: $tagObjsJson");
          
          List<Msg> newMessages = tagObjsJson.map((tagJson) => Msg.fromJson(tagJson)).toList();

          print("Formatted: $newMessages");
          setState(() {
            messages = newMessages;
            print(messages);
          });
        }
      }
    } on Exception catch (e) {
      print('Error in subscription stream: $e');
    }
  }


  void subscribeByChatId(String chatID) {
    Message? chatMessageObject = _messageService.getMessageObject();

    if(chatMessageObject==null){
      print("Cannot establish subsription because chatMessageObject in null");
      return;
    }

    final subscriptionRequest = ModelSubscriptions.onUpdate(Message.classType);

    final Stream<GraphQLResponse<Message>> operation = Amplify.API.subscribe(
      subscriptionRequest,
      onEstablished: () => print('Subscription established SUCCESSFULLY'),
    );

    subscription = operation.listen(
      (event) {
        print('Subscription event data received: ${event.data}');
      },
      onError: (Object e) => print('Error in subscription stream: $e'),
    );
  }

  void unsubscribe() {
    subscription?.cancel();
  }

  void sendMessage(String message) async{

    Msg _localMessage = Msg(message: message, userID: widget.user.id, time: TemporalDateTime(DateTime.now()));
    

    setState((){    
      messages = [...messages,_localMessage];
    });
    print("another");
    _messageService.sendMessage(message:_localMessage);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.username),
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
            child: DisplayChat(messages:messages,user: widget.user,)
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

  final List<Msg> messages;
  final User user;

  DisplayChat({
    Key? key,
    required this.messages,
    required this.user,
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
              alignment: (messages[messages.length-(1+index)].userID==user.id?Alignment.topRight:Alignment.topLeft),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (messages[messages.length-(1+index)].userID==user.id?Colors.blue[200]:Colors.grey.shade200),
                ),
                padding: EdgeInsets.all(16),
                child: Text(messages[messages.length-(1+index)].message!, style: TextStyle(fontSize: 15),),
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