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
    ref.read(userActivityDispatcherProvider).dispose();
    super.dispose();
  }

  String getLastSeenMessage() {
    if (userActivity == null) return '';
    final lastSeen =
        DateTime.fromMillisecondsSinceEpoch(userActivity!.lastSeen);
    final now = DateTime.now();
    print('Time diff: ${now.difference(lastSeen).inSeconds}');
    return userActivity!.active && now.difference(lastSeen).inSeconds < 20
        ? 'online'
        : 'last seen ${timeago.format(lastSeen, locale: 'en_short')}';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Remove this. This is just for testing subscription to multiple users' activity
    ref.read(userInfoAuthProvider).whenData((currentUser) {
      if (!subscribed) {
        ref.read(userActivityDispatcherProvider).subToUsers([
          widget.user.uid,
          currentUser!.uid,
        ]);
        setState(() {
          subscribed = true;
        });
      }
    });

    ref.watch(userActivityProvider).whenData((userActivity) {
      if (widget.user.uid == userActivity!.uid) return;
      setState(() {
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
