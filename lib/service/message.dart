
import 'dart:convert';

import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Chat/Chat.dart';

import '../models/Message.dart';
import '../models/Msg.dart';
import '../models/User.dart';
import 'contact.dart';

class MessageService{

  late final Message? chatMessageObject;

  Future init({required User user,required User contact}) async{
    chatMessageObject = await queryMessageObject(user.id,contact.id);

    if(chatMessageObject==null){
      print("Message object null");
    }else{
      print("Message Object found");
    }
  }

  Message? getMessageObject(){
    return chatMessageObject;
  }
 

  Future sendMessage({required Msg message}) async{

    if(chatMessageObject==null){
      print(" Message object not available!!!");
      return;
    }

    appendMessage(message);
  }


  Future<Message?> queryMessageObject(String user1,String user2) async {

    int res = user1.compareTo(user2);

    if(res>0){
      String temp = user1;
      user1 = user2;
      user2 = temp;
    }

    final queryPredicate = Message.CHATID.eq(user1+user2);

    print("Quering in conatct for chatID = ${user1+user2}");

    try {
        final request = ModelQueries.list<Message>(Message.classType, where: queryPredicate);
        final response = await Amplify.API.query(request: request).response;
        final message = response.data;

        if (message == null || message.items == null) {
          print('errors: ${response.errors}');
          return null;
        }
        return message.items.first;

    } on ApiException catch (e) {
        print('Query failed: $e');
        return null;
    }
  }


  Future<void> appendMessage(Msg message) async {
    
    if(chatMessageObject==null) return;

    List<Msg> newMessages = <Msg>[];
    newMessages.add(message);
    
    final messageWithNewMsg = chatMessageObject!.copyWith(messages: newMessages);

    final request = ModelMutations.update(messageWithNewMsg);
    final response = await Amplify.API.mutate(request: request).response;
    print('Message send to server => Response: ${response.data}');
  }

  /*
  */

  Future getMessages() async{
    /*
      Fetch Receiver messages;
    */

    if(chatMessageObject==null){
      print("Receiver Message object not available!!!");
      return;
    }

    List<Msg> jsonMessages = chatMessageObject?.messages??<Msg>[];

    return jsonMessages;
  }


  Future messageInfo(String user1,String user2) async{

    String mainUser = user1;

    int res = user1.compareTo(user2);

    if(res>0){
      String temp = user1;
      user1 = user2;
      user2 = temp;
    }

    var data = {"received":0,"send":0};

    final queryPredicate = Message.CHATID.eq(user1+user2);

    print("Quering in conatct for chatID = ${user1+user2}");

    try {
        final request = ModelQueries.list<Message>(Message.classType, where: queryPredicate);
        final response = await Amplify.API.query(request: request).response;
        final message = response.data;

        if (message == null || message.items == null || message.items.first==null) {
          print('errors: ${response.errors}');
          return data;
        }

        List<Msg>? msgList = message.items.first?.messages;

        if(msgList==null) return data;

        for(var msg in msgList){
          if(msg.userID==mainUser) data["send"] = data["send"]!+1;
          else data["received"] = data["received"]!+1;
        }
        
        return data;

    } on ApiException catch (e) {
        print('Query failed: $e');
        return data;
    }
  }
}