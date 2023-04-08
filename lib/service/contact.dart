// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Profile/manageDP.dart';

import 'package:chatapp/models/Message.dart';

import '../models/Msg.dart';
import '../models/User.dart';

class ContactService{
  // email => (email of the contact to be added)
  // user => (Logged in current user)
  Future addContact(String email,User user) async{

    String contactID = await userExists(email);
    bool contactExist = await contactExists(email,user);
    final createdContact;

    if(contactID != "-1" && !contactExist){
      print("Requested contact exists");

      try {

        final userWithNewContact = user.copyWith(contacts: [contactID]);
        final request = ModelMutations.update(userWithNewContact);
        final response = await Amplify.API.mutate(request: request).response;
        print('Response: $response');

        /*
          After adding contact now we have to create a record in Message Table to store the chats.
        */ 
        bool messageObjectExist =  await existMessageObject(user.id,contactID);  
        if(!messageObjectExist){
          createMessageObject(user.id,contactID);
        }else{
          print("Message object not created!!! (Maybe contact has already created it or Error)");
        }

      } on ApiException catch (e) {
          safePrint('Mutation failed: $e');
          return false;
      }

          return true;
    }else{
      if(contactExist){
        print('Contact already in list !!!');
      }else{
        print("No user with that email !!!");
      }
    }

    
  }

  Future userExists(String email) async{
    try {

      final queryPredicate = User.EMAIL.eq(email);

      final request = ModelQueries.list<User>(User.classType, where:queryPredicate);
      final response = await Amplify.API.query(request: request).response;
      final user = response.data;

      if (user== null) {
        print('errors: ${response.errors}');
        return null;
      }
      
      return user.items.first?.id;

    } on ApiException catch (e) {
      print('Query failed: $e');
      return "-1";
    }
  }

  Future contactExists(String email,User user) async{


      final queryPredicate = User.EMAIL.eq(email);

      final request = ModelQueries.list<User>(User.classType, where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;

      final contactsResponse = response.data;

      if (contactsResponse== null) {
          print('errors: ${response.errors}');
          return true;
      }
        
      User contactUser = contactsResponse.items.first!;

      for(var contactID in user.contacts!){
        if(contactID==contactUser.id){
          return true;
        }
      }

      return false;
    
  }

  Future existMessageObject(String user1,String user2) async{
    int res = user1.compareTo(user2);

    if(res>0){
      String temp = user1;
      user1 = user2;
      user2 = temp;
    }

    try {

        final queryPredicate = Message.CHATID.eq(user1+user2);

        final request = ModelQueries.list<Message>(Message.classType, where:queryPredicate);
        final response = await Amplify.API.query(request: request).response;
        final messageList = response.data;

        if (messageList== null) {
          print('errors: ${response.errors}');
          return null;
        }
        
        return messageList.items.isNotEmpty;

    } on ApiException catch (e) {
        safePrint('Mutation failed: $e');
        return true;
    }
  }

  Future createMessageObject(String user1,String user2) async{
    int res = user1.compareTo(user2);

    if(res>0){
      String temp = user1;
      user1 = user2;
      user2 = temp;
    }

    try {

        final messageObject = Message(chatID: user1+user2,messages: <Msg>[]);
        final request = ModelMutations.create(messageObject);
        final response = await Amplify.API.mutate(request: request).response;

        final createdMessage = response.data;

        if (createdMessage == null) {
          safePrint('errors: ${response.errors}');
          return;
        }

        safePrint('Mutation result: ${createdMessage.id}');

    } on ApiException catch (e) {
        safePrint('Mutation failed: $e');
        return ;
    }
  }

  Future getContacts(User user) async{

    late List<User>? contacts = [];

    for(var contactID in user.contacts!){

      final queryPredicate = User.ID.eq(contactID);

      final request = ModelQueries.list<User>(User.classType, where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;

      final contactsResponse = response.data;

      if (contactsResponse== null) {
          print('errors: ${response.errors}');
          return;
      }

      contacts.add(contactsResponse.items.first!);
    }

    print("Contacts :${user.contacts}");
      
    return contacts;

  }

  Future getSingleContact(email) async{
      final queryPredicate = User.EMAIL.eq(email);

      final request = ModelQueries.list<User>(User.classType, where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;

      final contactsResponse = response.data;

      if (contactsResponse== null) {
          print('errors: ${response.errors}');
          return;
      }

      return contactsResponse.items.first!;
  }

}