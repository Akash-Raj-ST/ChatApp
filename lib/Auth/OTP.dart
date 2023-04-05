// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatapp/Auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../components/Loading.dart';
import 'bloc/authentication_bloc.dart';

class OTPPage extends StatelessWidget {
  final String username;
  final String password;
  final String email;

  OTPPage({
    Key? key,
    required this.username,
    required this.password,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is RegisterSuccessState){
          print("Register success loading screen now");
          Future.delayed(Duration(seconds: 2),(){
            print("navigating...");
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });;
          });
        }
      },
      builder: (context, state) {
        
        return Scaffold(
          body: 
          state is RegisterSuccessState?
            Success("Account Created!!!")
          :
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Colors.blue[500]),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Verify OTP",
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

              state is LoadingState?
              Loading(state.loadingMsg)
              :
              Center(
                child: SafeArea(
                  child: OtpTextField(
                    numberOfFields: 6,

                    focusedBorderColor: Colors.blue[500]!,
                    borderColor: Colors.black,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      BlocProvider.of<AuthenticationBloc>(context).add(OTPEvent(
                          username: username,
                          OTP: verificationCode,
                          email: email));
                    }, // end onSubmit
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Verify OTP",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
