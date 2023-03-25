// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationInit extends AuthenticationEvent{
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthenticationEvent {

  final String username;
  final String password;
  
  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthenticationEvent {

  final String email;
  final String username;
  final String password;
  
  const RegisterEvent({
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [];
}

class OTPEvent extends AuthenticationEvent {
  final String username;
  final String OTP;

  const OTPEvent({
    required this.username,
    required this.OTP,
  });

  @override
  List<Object> get props => [];
}


