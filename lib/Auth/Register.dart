import 'package:chatapp/Auth/OTP.dart';
import 'package:chatapp/Auth/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/CustomTextField.dart';
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
      OTPEvent(username: _usernameController.text, OTP: _OTPController.text,email:_emailController.text)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc,AuthenticationState>(
      listener: (context, state) {
        if(state is OTPInputState){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:(_)=>BlocProvider.value(
                  value: BlocProvider.of<AuthenticationBloc>(context),
                  child: OTPPage(username:_usernameController.text,password:_passwordController.text,email: _emailController.text),
                )
              )
          );
        }
      },
      builder:(context,state){
        
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                  color: Colors.blue[500]
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        height: 1.5,
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              
              Column(
                children: [
                  CustomTextField(
                    controller: _emailController,
                    label:"Email",
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    label:"Username",
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    label:"Password",
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
                              onPressed: (){
                                
                                BlocProvider.of<AuthenticationBloc>(context).add(
                                  RegisterEvent(
                                    email: _emailController.text ,
                                    username: _usernameController.text  ,
                                    password: _passwordController.text
                                  )
                                );
                              }, 
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                 Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
    
                  InkWell(
                    onTap:() {
                      //navigate to register page
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.blue[500],
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
    
                ],
    
              )
                  ],
                ),
              ),

             
            
            ],
          ),
        );
      } 
    );
  }
}