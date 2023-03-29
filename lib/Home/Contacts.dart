
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/Contact.dart';
import '../Chat/Chat.dart';

class Contacts extends StatelessWidget {
  Contacts({super.key});

  final List<Contact> allContacts = [Contact(name:"Akash Raj",status:0),Contact(name:"Athul Robert",status:1),Contact(name:"Ahilan",status:0),Contact(name:"Christo Sharon Victoria",status:1),Contact(name:"Sai silesh",status:0),Contact(name:"Sujith",status:1)];
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allContacts.length,
      itemBuilder: (context, index) {
          return ContactItem(contact:allContacts[index],index:index);
        }
      
    );
  }
}


class ContactItem extends StatelessWidget {
  final Contact contact;
  final int index;

  const ContactItem({required this.contact,required this.index,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Chat(contact:contact,id:index);
              }
            ));
        },
        child: ListTile(
          leading: Hero(
            tag: index,
            child: CircleAvatar(
                        backgroundImage: NetworkImage("https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                      ),
          ),
      
          title: Text(
            contact.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            contact.status==0?"Offline":"Online",
            style: TextStyle(
              color:contact.status==0?Colors.red[200]:Colors.green[200],
            ),
          ),
        ),
      ),
    );
  }
}