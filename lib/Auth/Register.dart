import 'package:chatapp/Auth/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/submitButton.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _OTPController = TextEditingController();

  void onPressed(){
    print("Registering... ${_emailController.text} ${_usernameController.text}  ${_passwordController.text}");
  
    BlocProvider.of<AuthenticationBloc>(context).add(
      RegisterEvent(
        email: _emailController.text ,
        username: _usernameController.text  ,
        password: _passwordController.text
      )
    );
  }


  void verifyOTP(){
    print("Verifying OTP ${_OTPController.text}");

    BlocProvider.of<AuthenticationBloc>(context).add(
      OTPEvent(username: _usernameController.text, OTP: _OTPController.text)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc,AuthenticationState>(
      listener: (context, state) {
        
      },
      builder:(context,state){
        
        return Column(
          children: [
            TextField(
              controller: _emailController,
            ),
            TextField(
              controller: _usernameController,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
            ),
      
            SubmitButton("Register", onPressed),

            state is OTPInputState?
            Column(
                children: [
                  TextField(
                    controller: _OTPController,
                  ),
                  SubmitButton("Verify", verifyOTP),
                ],
              )
            :
            Column(
              children: [],
            ),
      
          ],
        );
      } 
    );
  }
}