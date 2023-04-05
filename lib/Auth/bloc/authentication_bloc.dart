import 'dart:ffi';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/service/authentication.dart';
import 'package:equatable/equatable.dart';

import '../../models/User.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final AuthenticationService _authenticationService;

  AuthenticationBloc(this._authenticationService) : super(AuthenticationInitial()) {

    on<AuthenticationInit>((event,emit) async{

      emit(LoadingState(loadingMsg: "Checking Credentials..."));

      await _authenticationService.init();

      bool isSignedIn = await _authenticationService.isUserSignedIn();

      if(isSignedIn){
        AuthUser currUser= await _authenticationService.getCurrentUser();
        User user = await _authenticationService.getUser(currUser.username);

        sleep(Duration(seconds: 3));

        emit(AuthenticationSuccessfulState(user: user));
      }

      sleep(Duration(seconds: 3));
      emit(AuthenticationInitial());
    }
    );
    
    on<LoginEvent>((event, emit) async{
      // TODO: implement event handler
      print("Loggin user");

      emit(LoadingState(loadingMsg: "Logging you in...."));

      bool? result = await _authenticationService.Login(event.username,event.password);

      if(result==null){
        print("error result is null");
        emit(AuthenticationInitial());
      }else{
        print("Login success redirecting...");
        User currUser= await _authenticationService.getUser(event.username);
        emit(AuthenticationSuccessfulState(user: currUser));
      }
    }
    );

    on<RegisterEvent>((event,emit) async{
      emit(LoadingState(loadingMsg: "Registering ${event.username}..."));
      bool result = await _authenticationService.register(event.email, event.username,event.password);

      if(result){ 
        print("Register success");
        emit(OTPInputState());
      }
      else{ 
        print("Register failed");
        emit(AuthenticationInitial());
      }
    }
    );

    on<OTPEvent>((event,emit) async{
        emit(LoadingState(loadingMsg: "Verifying OTP..."));

        bool result = await _authenticationService.OTPVerify(event.username,event.OTP,event.email);
        
        if(result){
          emit(RegisterSuccessState());
          print("OTP success");
        }else{
          emit(AuthenticationInitial());
          print("Register Error OTP faield!!!");
        }
    });
    
    on<SignOutEvent>((event,emit) async{
        emit(LoadingState(loadingMsg: "Logging Out..."));
        bool result = await _authenticationService.signOutCurrentUser();
        sleep(Duration(seconds: 2));

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
