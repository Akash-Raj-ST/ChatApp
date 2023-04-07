// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chatapp/Home/bloc/contact_bloc.dart';
import 'package:chatapp/Profile/manageDP.dart';
import 'package:chatapp/service/contact.dart';
import 'package:chatapp/service/message.dart';

import '../Auth/bloc/authentication_bloc.dart';
import '../components/Loading.dart';
import '../models/User.dart';

class Profile extends StatelessWidget {
  final User user;

  Profile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        
        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
          ),
          body: state is LoadingState?
          Loading(state.loadingMsg)
          :
          Column(
            children: [
              UserInfo(user:user),
              const SignOut(),
            ],
          ),
        );
      },
    );
  }
}

class UserInfo extends StatefulWidget {
  final User user;
  
  const UserInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  String dpURL = "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";

  Future _getFromGallery() async {
    try {
      String newURL = await uploadImage(widget.user.id);
      setState(() {
        dpURL = newURL;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getDP() async{
    String dpUrl = await getDownloadUrl(widget.user.id);
    if(dpUrl==""){ 
      return;
    }    
    setState(() {
      dpURL = dpUrl;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDP();
  }

  @override
  Widget build(BuildContext context) {
    return 
   
    Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _getFromGallery();
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                  dpURL
                ),
            radius: 75,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                widget.user.username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                widget.user.email,
                style: TextStyle( fontSize: 18),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: Info(user:widget.user)
        )
      ],
    ),
  );
  }
}

class Info extends StatefulWidget {
  final User user;

  const Info({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {

  var data = {"received":"0","contacts":"1","send":"2"};
  bool loading = true;

  @override
  void initState() {
    setDataInfo();
  }

  Future setDataInfo() async{
      var newData = {"received":"0","contacts":"1","send":"2"};

      List<User?> contacts = await ContactService().getContacts(widget.user);
      newData["contacts"] = contacts.length.toString();

      var recSendData = {"received":0,"send":0};
      var res = {"received":0,"send":0};

      for(var contact in contacts){
          if(contact==null) continue;

          res = await MessageService().messageInfo(widget.user.id, contact.id);
          recSendData["received"] = recSendData["received"]! + res["received"]!;
          recSendData["send"] = recSendData["send"]! + res["send"]!;
      }


      newData["received"] = recSendData["received"].toString();
      newData["send"] = recSendData["send"].toString();

      setState(() {
        data=newData;
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return 
          loading?
          Text("Loading...",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
          :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoWidget("Received", data["received"]!),
              InfoWidget("Contacts", data["contacts"]!),
              InfoWidget("Sent", data["send"]!),
            ],
          );
          
  }
}


Widget InfoWidget(String title, String count) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          count,
          style: TextStyle(fontSize: 16),
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
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(SignOutEvent());
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
          ),
        ),
      ],
    );
  }
}
