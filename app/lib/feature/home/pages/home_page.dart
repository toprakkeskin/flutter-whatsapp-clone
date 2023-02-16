import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'WhatsApp Clone',
              style: TextStyle(
                letterSpacing: 1,
              ),
            ),
            centerTitle: true,
            elevation: 1,
            actions: [
              CustomIconButton(onTap: () {}, icon: Icons.search),
              CustomIconButton(onTap: () {}, icon: Icons.more_vert),
            ],
            bottom: const TabBar(
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              splashFactory: NoSplash.splashFactory,
              tabs: [
                Tab(text: 'CHATS'),
                Tab(text: 'STATUS'),
                Tab(text: 'CALLS'),
              ],
            ),
          ),
          body: const Center(
            child: Text('Home Page'),
          )),
    );
  }
}
