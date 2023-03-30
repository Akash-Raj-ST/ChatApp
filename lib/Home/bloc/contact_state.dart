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
  final List<ContactDetail> contactDetails;

  ContactFetchedState({
    required this.contactDetails,
  });

  @override
  List<Object> get props => [];
}

class AddContactSuccessState extends ContactState {

  @override
  List<Object> get props => [];
}

class AddContactFailedState extends ContactState {

  @override
  List<Object> get props => [];
}
