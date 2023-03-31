// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccessfulState extends AuthenticationState {

  final User user;

  const AuthenticationSuccessfulState({
    required this.user,
  });

  @override
  List<Object> get props => [];
}

class OTPInputState extends AuthenticationState{
  @override
  List<Object> get props => [];
}


class RegisterSuccessState extends AuthenticationState {

  @override
  List<Object> get props => [];
}

class SignOutSuccessState extends AuthenticationState {

  @override
  List<Object> get props => [];
}

class SignOutFailedState extends AuthenticationState {

  @override
  List<Object> get props => [];
}
