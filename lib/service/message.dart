
import 'dart:convert';

import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Chat/Chat.dart';

import '../models/Message.dart';
import '../models/Msg.dart';
import 'contact.dart';

class MessageService{

  late final Message? senderMessageObject;
  late final Message? receiverMessageObject;
  late final ContactDetail _contactDetail;

  Future init({required ContactDetail contactDetail}) async{
    // senderMessageObject = await queryMessageObject(contactDetail.user.id);
    receiverMessageObject = await queryMessageObject(contactDetail.contact.id);
    _contactDetail = contactDetail;
  }
  /*
    1. get the userID_sender and userID_receiver
    2. save the message in contact table with userID_sender
    3. save the message in contale with userID_receiver
    4. Change the message isUser accoordingly
  */

  Future sendMessage({required Msg message}) async{

    // if(senderMessageObject==null){
    //   print("Sender Message object not available!!!");
    //   return;
    // }

    // appendMessage(message, senderMessageObject, true);

    if(receiverMessageObject==null){
      print("Receiver Message object not available!!!");
      return;
    }

    appendMessage(message, receiverMessageObject!, true);
  }


  Future<Message?> queryMessageObject(String id) async {
    final queryPredicate = Message.CONTACTID.eq(id);

    print("Quering in conatct for contactID = ${id}");

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


  Future<void> appendMessage(Msg message,Message messageObject,bool sender) async {
    
    
    List<Msg> jsonMessages = messageObject.messages??<Msg>[];

    print("before: ${jsonMessages}");

    jsonMessages.add(message);

    print("adding: ${message}");

    print("after: ${jsonMessages}");


    final todoWithNewName = messageObject.copyWith(messages: jsonMessages);

    final request = ModelMutations.update(todoWithNewName);
    final response = await Amplify.API.mutate(request: request).response;
    print('Response: $response');
  }

  /*
  */

  Future getMessages() async{
    /*
      Fetch Receiver messages;
    */

    if(receiverMessageObject==null){
      print("Receiver Message object not available!!!");
      return;
    }

    List<Msg> jsonMessages = receiverMessageObject?.messages??<Msg>[];

    return jsonMessages;
  }
}