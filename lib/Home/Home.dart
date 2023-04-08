import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/Auth/bloc/authentication_bloc.dart';
import 'package:chatapp/Home/Contacts.dart';
import 'package:chatapp/Home/SearchBar.dart';
import 'package:chatapp/Profile/Profile.dart';
import 'package:chatapp/components/Loading.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Profile/manageDP.dart';
import '../models/User.dart';

class HomePage extends StatefulWidget {

  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String dpURL = "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDP();
  }

  Future setDP() async{
    String dpUrl = await getDownloadUrl(widget.user.id);

    if(dpUrl==""){
      return;
    }
    setState(() {
      dpURL = dpUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AuthenticationBloc,AuthenticationState>(

        listener: (context, state) {

          if(state is SignOutSuccessState){
            print("Signing out!!!");
            Future.delayed(Duration.zero,(){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Authentication()), (route) => false);
            });
              
          }
          
        },
        builder: (context, state) {
          if(state is LoadingState){
            return Loading(state.loadingMsg);
          }
          return SafeArea(
            child: Scaffold(
              
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("Messages",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[500]
                                ),
                              ),
                            ),
                          ),
                        ),
          
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:(_)=>BlocProvider.value(
                                          value: BlocProvider.of<AuthenticationBloc>(context),
                                          child: Profile(user: widget.user),
                                      )
                                    )
                                  );
                              
                              },
                              child: Hero(
                                tag: "ProfilePic",
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(dpURL)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: Contacts(user:widget.user)
                  )
                ]
              ),
          
            ),
          );
        },
      );
  }
}