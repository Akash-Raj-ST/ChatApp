// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/CustomTextField.dart';
import '../models/User.dart';
import 'bloc/contact_bloc.dart';

class AddContact extends StatelessWidget {
  
  final User user;
  
  AddContact({
    Key? key,
    required this.user,
  }) : super(key: key);

  final _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(

      children:[
        CustomTextField(
          controller:_emailTextController,
          label:"Email",
        ),

        ElevatedButton(
          onPressed: (){
              BlocProvider.of<ContactBloc>(context).add(AddContactEvent(email: _emailTextController.text,user:user));
          }, 
          child: Text("Add Contact")
        )
      ]
    );
  }
}
