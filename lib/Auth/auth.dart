import 'package:chatapp/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/Home.dart';
import '../components/TabButton.dart';
import 'Login.dart';
import 'Register.dart';
import 'bloc/authentication_bloc.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create:(BuildContext context) => AuthenticationBloc(RepositoryProvider.of<AuthenticationService>(context))..add(AuthenticationInit()),

      child: BlocConsumer<AuthenticationBloc,AuthenticationState>(
        listener: (context, state){
          if(state is AuthenticationInitial){
            print("initial state...");
          }

          if(state is AuthenticationSuccessfulState){
            print("Login success state");
          }
        },
        builder:(context, state){
          if(state is AuthenticationSuccessfulState){ 
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(_)=>BlocProvider.value(
                      value: BlocProvider.of<AuthenticationBloc>(context),
                      child: HomePage(user: state.user),
                    )
                  )
              );
            }
            );
          }

          return Scaffold(
                appBar: AppBar(
                  title: const Text("Chat App"),
                ),
                body: const AuthenticationPage(),
              );
          
        } 
      ),
    );
  }
}

class AuthenticationPage extends StatefulWidget {
  
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  

  String currTab = "Login";

  void changeTab(String clickedTab){
    setState(() {
      currTab = clickedTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          showOptions(currTab,changeTab),

          currTab=="Login"?const LoginPage():const RegisterPage(),
      ],
    );
  }
}


Widget showOptions(currTab,changeTab){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TabButton("Login", currTab, changeTab),

      const SizedBox(
        width: 10,
      ),

      TabButton("Register", currTab, changeTab),
    ],
  );
}