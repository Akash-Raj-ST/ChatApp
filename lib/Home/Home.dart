import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/Auth/bloc/authentication_bloc.dart';
import 'package:chatapp/Home/Contacts.dart';
import 'package:chatapp/Home/SearchBar.dart';
import 'package:chatapp/Profile/Profile.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {

  final AuthUser user;

  const HomePage({super.key, required this.user});

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
          return Scaffold(
            appBar: AppBar(
              title: Text("ChitChat ${user.username}!"),
              automaticallyImplyLeading: false,
              actions:<Widget> [
                GestureDetector(
                  onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:(_)=>BlocProvider.value(
                              value: BlocProvider.of<AuthenticationBloc>(context),
                              child: Profile(user: user),
                          )
                        )
                      );
                  
                  },
                  child: Hero(
                    tag: "ProfilePic",
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                    ),
                  ),
                ),
              ],
            
            ),
            body: Column(
              children: [
                SearchBar(),

                SizedBox(
                  height: 20,
                ),
                
                Expanded(
                  child: Contacts()
                )
              ]
            ),
          );
        },
      );
  }
}