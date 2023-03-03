import 'package:timeago/timeago.dart' as timeago;
import 'package:whatsapp_clone/common/models/user_activity_model.dart';

String getLastSeenMessage(UserActiviyModel? userActivity) {
  if (userActivity == null) return '';
  final lastSeen = DateTime.fromMillisecondsSinceEpoch(userActivity.lastSeen);
  final now = DateTime.now();
  // log('Time diff: ${now.difference(lastSeen).inSeconds}');
  return userActivity.active && now.difference(lastSeen).inSeconds < 20
      ? 'online'
      : 'last seen ${timeago.format(lastSeen, locale: 'en_short')}';
}
