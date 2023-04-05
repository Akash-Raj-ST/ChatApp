import 'dart:ui';

import 'package:chatapp/Auth/Register.dart';
import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/Auth/bloc/authentication_bloc.dart';
import 'package:chatapp/components/Loading.dart';
import 'package:chatapp/components/submitButton.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../Home/Home.dart';
import '../components/CustomTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void onPressed() {
    BlocProvider.of<AuthenticationBloc>(context).add(LoginEvent(
        username: _usernameController.text,
        password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
    
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: Colors.blue[500]),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Welcome \nTo \nChat App",
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            state is LoadingState?
            Loading(state.loadingMsg)
            :
            Column(
              children: [
                
                CustomTextField(
                  controller: _usernameController,
                  label: "Username",
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: "Password",
                  obscureText: true,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(LoginEvent(
                                        username: _usernameController.text,
                                        password: _passwordController.text));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      InkWell(
                          onTap: () {
                            //navigate to register page
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<AuthenticationBloc>(
                                              context),
                                      child: const RegisterPage(),
                                    )));
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blue[500],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
