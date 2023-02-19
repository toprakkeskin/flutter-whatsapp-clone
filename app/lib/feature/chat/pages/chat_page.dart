import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/models/user_activity_model.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/chat/config/last_seen_timeago_lookup_messages.dart';
import 'package:whatsapp_clone/feature/chat/repositories/user_activity_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.user});
  final UserModel user;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  UserActiviyModel? userActivity;
  bool subscribed = false;

  @override
  void initState() {
    timeago.setLocaleMessages('en_short', LastSeenTimeAgoLookupMessages());
    super.initState();
  }

  @override
  void dispose() {
    // todo fix "Looking up a deactivated widget's ancestor is unsafe." exception
    ref.read(userActivityDispatcherProvider).dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // This is just for testing subscription to multiple users' activity
    // Get current logged in user and subscribe to user activity
    ref.read(userInfoAuthProvider).whenData((currentUser) {
      log('[CURRENT USER]: ${currentUser?.uid}');

      if (!subscribed) {
        final usersToSub = [widget.user.uid, currentUser!.uid];

        UserActivityDispatcher userActivityDispatcher =
            ref.read(userActivityDispatcherProvider);

        // Get current states of user activity and set initial state
        userActivityDispatcher
            .getUserActivity(widget.user.uid)
            .then((fetchedUserActivity) {
          setState(
            () {
              userActivity = fetchedUserActivity;
              log('[Chat -> set initial state -> user activity]: ${userActivity?.uid} ${userActivity?.active} ${userActivity?.lastSeen}');
            },
          );
        });

        // Subscribe for activity changes of multiple users
        userActivityDispatcher.subToUsers(usersToSub);
        setState(() {
          subscribed = true;
        });
      }
    });

    super.didChangeDependencies();
  }

  String getLastSeenMessage() {
    if (userActivity == null) return '';
    final lastSeen =
        DateTime.fromMillisecondsSinceEpoch(userActivity!.lastSeen);
    final now = DateTime.now();
    // log('Time diff: ${now.difference(lastSeen).inSeconds}');
    return userActivity!.active && now.difference(lastSeen).inSeconds < 20
        ? 'online'
        : 'last seen ${timeago.format(lastSeen, locale: 'en_short')}';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userActivityProvider).whenData((userActivity) {
      if (userActivity?.uid == null || widget.user.uid != userActivity!.uid) {
        return;
      }

      setState(() {
        log('[Chat -> set state -> user activity]: ${userActivity.uid} ${userActivity.active} ${userActivity.lastSeen}');
        this.userActivity = userActivity;
      });
    });
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.user.profileImageUrl),
              ),
            ],
          ),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.username,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            if (userActivity != null)
              FittedBox(
                child: Text(
                  getLastSeenMessage(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        actions: [
          CustomIconButton(
            onTap: () {},
            icon: Icons.video_call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {},
            icon: Icons.call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {},
            icon: Icons.more_vert,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
