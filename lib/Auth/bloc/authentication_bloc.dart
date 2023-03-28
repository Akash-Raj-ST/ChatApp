import 'dart:ffi';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/service/authentication.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final AuthenticationService _authenticationService;

  AuthenticationBloc(this._authenticationService) : super(AuthenticationInitial()) {

    on<AuthenticationInit>((event,emit) async{
      await _authenticationService.init();

      bool isSignedIn = await _authenticationService.isUserSignedIn();

      if(isSignedIn){
        AuthUser currUser= await _authenticationService.getCurrentUser();
        emit(AuthenticationSuccessfulState(user: currUser));
      }
    }
    );
    
    on<LoginEvent>((event, emit) async{
      // TODO: implement event handler
      print("Loggin user");
      bool? result = await _authenticationService.Login(event.username,event.password);

      if(result==null){
        print("error result is null");
      }else{
        print("Login success redirecting...");
        AuthUser currUser= await _authenticationService.getCurrentUser();
        emit(AuthenticationSuccessfulState(user: currUser));
      }
    }
    );

    on<RegisterEvent>((event,emit) async{
      bool result = await _authenticationService.register(event.email, event.username,event.password);
    
      if(result){ 
        print("Register success");
        emit(OTPInputState());
      }
      else print("Register failed");
    }
    );

    on<OTPEvent>((event,emit) async{
        bool result = await _authenticationService.OTPVerify(event.username,event.OTP);

        if(result){
          emit(RegisterSuccessState());
          print("OTP success");
        }else{
          print("Register Error OTP faield!!!");
        }
    });
    
    on<SignOut>((event,emit) async{
        bool result = await _authenticationService.signOutCurrentUser();

        if(result){
          emit(SignOutSuccessState());
          print("SignOut Success");
        }else{
          print("SignOut faield!!!");
          emit(SignOutFailedState());
        }
    });

  }
}
