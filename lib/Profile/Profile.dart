import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Profile/uploadDP.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../Auth/bloc/authentication_bloc.dart';
import '../models/User.dart';

class Profile extends StatelessWidget {

  final User user;

  const Profile({required this.user,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          UserInfo(user),
          const SignOut(),
        ],
      ),
    );
  }
}

Widget UserInfo(User user){

  Future  _getFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemp = File(image.path);
      
      print(imageTemp);
      createTodo();

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            _getFromGallery();
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage("https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
            radius: 75,
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        Padding(
          padding: const EdgeInsets.only(bottom:40.0),
          child: Text(
            "Akash Raj ST",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoWidget("Received","12.53K"),
              InfoWidget("Contacts","1875"),
              InfoWidget("Sent","14.67K"),
            ],
          ),
        )
      ],
    ),
  );
}

Widget InfoWidget(String title,String count){
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          count,
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ),
    ],
  );
}

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400]
              ),
              onPressed: (){
                BlocProvider.of<AuthenticationBloc>(context).add(SignOutEvent());
              }, 
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              )
            ),
          ),
        ),
      ],
    );
  }
}
