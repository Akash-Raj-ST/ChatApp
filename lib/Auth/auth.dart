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
        },
        builder:(context, state){

          return Scaffold(
                
                body: SafeArea(
                  child: const AuthenticationPage()
                ),
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

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
