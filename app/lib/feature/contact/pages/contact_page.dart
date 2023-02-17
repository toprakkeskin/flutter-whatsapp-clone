import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/utils/coloors.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/contact/controllers/contacts_controller.dart';
import 'package:whatsapp_clone/feature/contact/widgets/contact_card.dart';

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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...buildActionList(rendered: index == 0, actions: [
                    buildActionListTile(
                      leading: Icons.group,
                      text: 'New Group',
                    ),
                    buildActionListTile(
                      leading: Icons.contacts,
                      text: 'New Contact',
                      trailing: Icons.qr_code,
                    )
                  ]),
                  // If it's the beginning of a group show the group title
                  if (index == 0 || index == allContacts[0].length)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        index == 0
                            ? 'Contacts on WhatsApp'
                            : 'Contacts on Phone',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: context.theme.greyColor,
                        ),
                      ),
                    ),

                  // Show the contact card according to group it belongs to
                  index < allContacts[0].length
                      ? ContactCard(
                          contactSource: firebaseContact,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.chat,
                              arguments: firebaseContact,
                            );
                          },
                        )
                      : ContactCard(
                          contactSource: phoneContact,
                          onTap: () => shareSmsLink(phoneContact.phoneNumber),
                        )
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

  buildActionList({required bool rendered, required List<Widget> actions}) {
    return rendered ? actions : [];
  }

  ListTile buildActionListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Coloors.greenDark,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        trailing,
        color: Coloors.greyDark,
      ),
    );
  }
}
