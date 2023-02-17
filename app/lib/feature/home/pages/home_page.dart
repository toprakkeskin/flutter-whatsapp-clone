import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/home/pages/call_home_page.dart';
import 'package:whatsapp_clone/feature/home/pages/chat_home_page.dart';
import 'package:whatsapp_clone/feature/home/pages/status_home_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  Timer? timer;
  bool _isInForeground = true;

  // TODO move all these logic to the app-level
  updateUserPresence(bool isActive) {
    ref.read(authControllerProvider).updateUserPresence(isActive);
  }

  setupUpdateUserPresenceTimer() {
    if (timer != null && timer!.isActive) timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      updateUserPresence(_isInForeground);
      if (_isInForeground) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    updateUserPresence(_isInForeground);
    setupUpdateUserPresenceTimer();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = state == AppLifecycleState.resumed;
    if (_isInForeground) {
      setupUpdateUserPresenceTimer();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              letterSpacing: 1,
            ),
          ),
          centerTitle: false,
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
        body: const TabBarView(
          children: [
            ChatHomePage(),
            StatusHomePage(),
            CallHomePage(),
          ],
        ),
      ),
    );
  }
}
