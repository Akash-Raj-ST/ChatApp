// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Profile/uploadDP.dart';

import 'package:chatapp/models/Message.dart';

import '../models/Contact.dart';
import '../models/User.dart';

class ContactDetail {
  final User user;
  final Contact contact;

  ContactDetail({
    required this.user,
    required this.contact,
  });

}

class ContactService{
  // email => (email of the contact to be added)
  // user => (Logged in current user)
  Future addContact(String email,User user) async{

    String userID = await userExists(email);
    bool contactExist = await contactExists(email,user);
    final createdContact;

    if(userID != "-1" && !contactExist){
      print("Requested contact exists");

      try {
            final contact = Contact(contactUserID: userID,userID: user.id);
            final request = ModelMutations.create(contact);
            final response = await Amplify.API.mutate(request: request).response;

            createdContact = response.data;

            if (createdContact == null) {
              safePrint('errors: ${response.errors}');
              return false;
            }

            safePrint('Mutation result: ${createdContact.userID}');
            
          } on ApiException catch (e) {
            safePrint('Mutation failed: $e');
            return false;
          }

          return true;
    }else{
      print("User doesnt exist or already added");
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
      late List<Contact>? contacts = [];


      final queryPredicate = Contact.USERID.eq(user.id);

      final request = ModelQueries.list<Contact>(Contact.classType, where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;

      final contactsResponse = response.data;

      if (contactsResponse== null) {
          print('errors: ${response.errors}');
          return true;
      }
        
      contacts = contactsResponse.items.cast<Contact>();

      for(int i=0;i<contacts.length;i++){
        final queryPredicate = User.ID.eq(contacts[i].contactUserID);

        final request = ModelQueries.list<User>(User.classType, where: queryPredicate);
        final response = await Amplify.API.query(request: request).response;

        final contactsResponse = response.data;

        if (contactsResponse== null) {
            print('errors: ${response.errors}');
            return null;
        }
          

        User contactuser = contactsResponse.items.first!;
        print("${contactuser.email} <-> ${email}");
        if(contactuser.email==email){
          return true;
        }
      }

      return false;
    
  }

  Future getContacts(User user) async{

    late List<Contact>? contacts = [];
    late List<ContactDetail> contactDetails = [];


    final queryPredicate = Contact.USERID.eq(user.id);

    final request = ModelQueries.list<Contact>(Contact.classType, where: queryPredicate);
    final response = await Amplify.API.query(request: request).response;

    final contactsResponse = response.data;

    if (contactsResponse== null) {
        print('errors: ${response.errors}');
        return <Contact>[];
    }
      
    contacts = contactsResponse.items.cast<Contact>();

   for(int i=0;i<contacts.length;i++){
    final queryPredicate = User.ID.eq(contacts[i].contactUserID);

    final request = ModelQueries.list<User>(User.classType, where: queryPredicate);
    final response = await Amplify.API.query(request: request).response;

    final contactsResponse = response.data;

    if (contactsResponse== null) {
        print('errors: ${response.errors}');
        return null;
    }
      

    contactDetails.add(ContactDetail(contact:contacts[i],user:contactsResponse.items.first!));
   }

   return contactDetails;

  }

}