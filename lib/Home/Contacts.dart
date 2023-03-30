// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:amplify_api/model_queries.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Chat/Chat.dart';
import '../models/Contact.dart';
import '../models/ModelProvider.dart';
import '../service/contact.dart';
import 'bloc/contact_bloc.dart';

class Contacts extends StatelessWidget {
  final User user;

  Contacts({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(

      providers: [
        RepositoryProvider(create: (context) => ContactService())
      ],

      child: BlocProvider(
        create: (context) =>
            ContactBloc(RepositoryProvider.of<ContactService>(context), user)..add(ContactInit()),

        child: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {

            if(state is ContactFetchedState){
              
              return Column(
                children: [

                  ElevatedButton(
                    onPressed: (){
                      BlocProvider.of<ContactBloc>(context).add(AddContactEvent(email: "akashraj49070@gmail.com",user:user));
                    }, 
                    child: Text("Add Contact")
                  ),
                  
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.contactDetails.length,
                        itemBuilder: (context, index) {
                          return ContactItem(contact: state.contactDetails[index], index: index);
                        }
                    ),
                  ),
                ],
              );
            }

            return Text("Loading");
          },
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final ContactDetail contact;
  final int index;

  const ContactItem({required this.contact, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return Chat(contact: contact, id: index);
          }));
        },
        child: ListTile(
          leading: Hero(
            tag: index,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
            ),
          ),
          title: Text(
            contact.user.username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // subtitle: Text(
          //   // contact.user.status == 0 ? "Offline" : "Online",
          //   // contact.user.status == 0 ? "Offline" : "Online",
          //   style: TextStyle(
          //     color: contact.status == 0 ? Colors.red[200] : Colors.green[200],
          //   ),
          // ),
        ),
      ),
    );
  }
}
