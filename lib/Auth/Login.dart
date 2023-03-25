import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/Auth/bloc/authentication_bloc.dart';
import 'package:chatapp/components/submitButton.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void onPressed(){
    BlocProvider.of<AuthenticationBloc>(context).add(LoginEvent(username:_usernameController.text,password:_passwordController.text));
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
        ),

        SubmitButton("Login", onPressed)
      ],
    );
  }
}