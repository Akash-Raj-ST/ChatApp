// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();
  
  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {

}

class ContactFetchedState extends ContactState {
  final List<User> contacts;

  ContactFetchedState({
    required this.contacts,
  });

  @override
  List<Object> get props => [];
}

class AddContactSuccessState extends ContactState {
  final User newContact;

  AddContactSuccessState({
    required this.newContact,
  });
  
  @override
  List<Object> get props => [];
}

class AddContactFailedState extends ContactState {

  @override
  List<Object> get props => [];
}
