// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Home/AddContact.dart';
import 'package:chatapp/components/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Chat/Chat.dart';
import '../models/ModelProvider.dart';
import '../service/contact.dart';
import 'SearchBar.dart';
import 'bloc/contact_bloc.dart';

class Contacts extends StatefulWidget {
  final User user;


  Contacts({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<User> contacts = [];
  List<User> filteredContacts = [];
  TextEditingController _searchQuery = TextEditingController();
  
  void filterContactHandler(){
    String query = _searchQuery.text;
    
    print("query $query");
    if(query.length==0){
      setState(() {
        filteredContacts = contacts;
      });
      return;
    }

    List<User> newFilterContacts = [];

    for(var contact in contacts){
      if(contact.username.contains(query)){
        newFilterContacts.add(contact);
      }
    }

    setState(() {
      filteredContacts = newFilterContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(

      providers: [
        RepositoryProvider(create: (context) => ContactService())
      ],

      child: BlocProvider(
        create: (context) =>
            ContactBloc(RepositoryProvider.of<ContactService>(context), widget.user)..add(ContactInit()),

        child: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if(state is ContactFetchedState){
              setState(() {
                contacts = state.contacts;
                filteredContacts = state.contacts;
              });
            }
          },
          builder: (context, state) {
              
              return Column(
                children: [
                    SearchBar(handler:filterContactHandler,searchQuery: _searchQuery,),
          
                    SizedBox(
                      height: 20,
                    ),
                    
            
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: (){
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (_) {
                                return BlocProvider.value(
                                  value:  BlocProvider.of<ContactBloc>(context),
                                  child: AddContact(user: widget.user,)
                                );
                              }
                            );
                          }, 
                          child: Text("Add Contact")
                            
                        ),
                      ),
                    ),
                  
                  state is ContactFetchedState?
                  
                  Expanded(
                    child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          return ContactItem(contact: filteredContacts[index],user:widget.user, index: index);
                        }
                    ),
                  )
                  :
                  Loading("Fetching your Contacts...")
                ],
              );
            }
        
        ),
        ),
      );
  }
}

class ContactItem extends StatelessWidget {
  final User contact;
  final User user;
  final int index;

  const ContactItem({required this.contact,required this.user, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return Chat(contact: contact,user:user,id: index);
          }));
        },
        child: ListTile(
          leading: Hero(
            tag: index,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                radius: 26,
              ),
            
          ),
          title: Text(
            contact.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            contact.email,
            style: TextStyle(
              // color: contact.status == 0 ? Colors.red[200] : Colors.green[200],
            ),
          ),
        ),
      ),
    );
  }
}
