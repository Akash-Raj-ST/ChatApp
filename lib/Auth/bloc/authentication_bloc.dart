import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:chatapp/Auth/auth.dart';
import 'package:chatapp/service/authentication.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final AuthenticationService _authenticationService;

  AuthenticationBloc(this._authenticationService) : super(AuthenticationInitial()) {

    on<AuthenticationInit>((event,emit){
      _authenticationService.init();
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
        emit(const AuthenticationSuccessfulState(userID: 1));
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

  }
}
