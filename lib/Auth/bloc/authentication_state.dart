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

  final int userID;

  const AuthenticationSuccessfulState({
    required this.userID,
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
