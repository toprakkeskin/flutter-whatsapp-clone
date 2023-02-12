import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/widgets/custom_text_field.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late TextEditingController codeController;

  @override
  void initState() {
    codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          title: Text(
            'Verify your number',
            style: TextStyle(
              color: context.theme.authAppbarTextColor,
            ),
          ),
          centerTitle: true,
          actions: [
            CustomIconButton(
              onTap: () {},
              icon: Icons.more_vert,
            ),
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                          color: context.theme.greyColor,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "You've tried to register +123121251. Wait before requesting an SMS or call with your code",
                          ),
                          TextSpan(
                            text: '\nWrong number?',
                            style: TextStyle(
                              color: context.theme.blueColor,
                            ),
                          )
                        ]),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: CustomTextField(
                    controller: codeController,
                    hintText: ' - - -  - - -',
                    fontSize: 30,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter 6-digit code',
                  style: TextStyle(color: context.theme.greyColor),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.message,
                      color: context.theme.greyColor,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Resend SMS",
                      style: TextStyle(color: context.theme.greyColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: context.theme.blueColor!.withOpacity(0.3),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: context.theme.greyColor,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "Call Me",
                      style: TextStyle(color: context.theme.greyColor),
                    ),
                  ],
                ),
              ],
            )));
  }
}
