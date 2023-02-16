import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/utils/coloors.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/contact/controllers/contacts_controller.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  shareSmsLink(String phoneNumber) async {
    Uri sms = Uri.parse(
        "sms:$phoneNumber&body=${Uri.encodeComponent("Let's chat on WhatsApp! It's a fast, simple, and secure app we can call each other for free. Get it at https://www.whatsapp.com/download")}");

    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            ref.watch(contactsControllerProvider).when(
              data: (allContacts) {
                return Text(
                  '${allContacts[0].length} Contact${allContacts[0].length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 13),
                );
              },
              error: (e, t) {
                return const SizedBox();
              },
              loading: () {
                return const Text('Loading...', style: TextStyle(fontSize: 12));
              },
            ),
          ],
        ),
        actions: [
          CustomIconButton(onTap: () {}, icon: Icons.search),
          CustomIconButton(onTap: () {}, icon: Icons.more_vert),
        ],
      ),
      body: ref.watch(contactsControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            itemCount: allContacts[0].length + allContacts[1].length,
            itemBuilder: (context, index) {
              late UserModel firebaseContact;
              late UserModel phoneContact;

              if (index < allContacts[0].length) {
                firebaseContact = allContacts[0][index];
              } else {
                phoneContact = allContacts[1][index - allContacts[0].length];
              }

              return index < allContacts[0].length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Text(
                              'Contacts on WhatsApp',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ),
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                              left: 20, right: 10, top: 0, bottom: 0),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor:
                                context.theme.greyColor!.withOpacity(0.3),
                            radius: 20,
                            backgroundImage: firebaseContact
                                    .profileImageUrl.isNotEmpty
                                ? NetworkImage(firebaseContact.profileImageUrl)
                                : null,
                            child: firebaseContact.profileImageUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white70,
                                  )
                                : null,
                          ),
                          title: Text(
                            firebaseContact.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Hey there! I am using WhatsApp.',
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == allContacts[0].length)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Text(
                              'Contacts on Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ),
                        ListTile(
                          onTap: () => shareSmsLink(phoneContact.phoneNumber),
                          contentPadding: const EdgeInsets.only(
                              left: 20, right: 10, top: 0, bottom: 0),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor:
                                context.theme.greyColor!.withOpacity(0.3),
                            radius: 20,
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white70,
                            ),
                          ),
                          title: Text(
                            phoneContact.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: () =>
                                shareSmsLink(phoneContact.phoneNumber),
                            style: TextButton.styleFrom(
                              foregroundColor: Coloors.greenDark,
                            ),
                            child: const Text('INVITE'),
                          ),
                        ),
                      ],
                    );
            },
          );
        },
        error: (e, t) {
          return null;
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: context.theme.authAppbarTextColor,
            ),
          );
        },
      ),
    );
  }
}
