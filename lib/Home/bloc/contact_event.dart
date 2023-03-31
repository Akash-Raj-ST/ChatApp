// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class ContactInit extends ContactEvent{
  @override
  List<Object> get props => [];
}

class AddContactEvent extends ContactEvent {

  final String email;
  final User user;
  
  AddContactEvent({
    required this.email,
    required this.user,
  });

  @override
  List<Object> get props => [];
}
