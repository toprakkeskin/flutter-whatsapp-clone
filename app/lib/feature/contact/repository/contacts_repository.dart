import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';

final contactsRepositoryProvider = Provider((ref) {
  return ContactsRepository(firestore: FirebaseFirestore.instance);
});

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<UserModel>>> getAllContacts() async {
    // Contacts have an account on this app
    List<UserModel> firebaseContacts = [];
    // Contacts don't have an account on this app
    List<UserModel> phoneContacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await firestore.collection('users').get();
        final List<Contact> allContactsInThePhone =
            await FlutterContacts.getContacts(withProperties: true);

        bool isContactFound = false;

        // TODO: improve this code below
        for (Contact contact in allContactsInThePhone) {
          var contactPhone = contact.phones[0].number.replaceAllMapped(
              RegExp(r'\D|\s'), (m) => m[0] == '+' ? '+' : '');

          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact = UserModel.fromMap(firebaseContactData.data());

            if (contactPhone == firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              isContactFound = true;
              break;
            }
          }

          if (!isContactFound) {
            phoneContacts.add(
              UserModel(
                uid: '',
                groupId: [],
                username: contact.displayName,
                active: false,
                profileImageUrl: '',
                phoneNumber: contactPhone,
              ),
            );
            isContactFound = false;
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return [firebaseContacts, phoneContacts];
  }
}
