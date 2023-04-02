import 'package:bloc/bloc.dart';
import 'package:chatapp/service/contact.dart';
import 'package:equatable/equatable.dart';

import '../../models/User.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {

  late ContactService _contactService;
  late User user;

  ContactBloc(this._contactService,this.user) : super(ContactInitial()) {

    on<ContactInit>((event, emit) async{
      print("Getting contacts...");

      List<User> contacts = await _contactService.getContacts(user)??<User>[];
      print(contacts.length);
      emit(ContactFetchedState(contacts: contacts));
      print("Getting contacts... Done");

    });

    on<AddContactEvent>((event,emt) async{

      bool result = await _contactService.addContact(event.email,event.user);

      if(result){
        emit(AddContactSuccessState());
      }else{
        emit(AddContactFailedState());
      }
      add(ContactInit());
    });

  }
}
