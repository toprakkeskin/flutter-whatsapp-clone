import 'dart:async';
import 'dart:developer';
import 'package:async/async.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/models/user_activity_model.dart';
import 'package:whatsapp_clone/feature/chat/dto/user_activity_database_event.dart';

final userActivityDispatcherProvider = Provider<UserActivityDispatcher>((ref) {
  return UserActivityDispatcher(database: FirebaseDatabase.instance, users: []);
});

final userActivityProvider =
    StreamProvider.autoDispose<UserActiviyModel?>((ref) async* {
  final userActivityService = ref.watch(userActivityDispatcherProvider);

  await for (final activityEvent in userActivityService.stream) {
    final UserActiviyModel data = UserActiviyModel.fromMap({
      ...(activityEvent.event.snapshot.value as Map),
      'uid': activityEvent.uid
    });
    log('[UserActivityProvider NEW EVENT]: ${activityEvent.uid} ${data.active} ${data.lastSeen}');
    yield data;
  }
});

class UserActivityDispatcher {
  List<String> users = [];
  final FirebaseDatabase database;

  UserActivityDispatcher({required this.users, required this.database});

  Stream<UserActivityDatabaseEvent> get stream {
    if (users.isEmpty) return const Stream.empty();
    return StreamGroup.merge(
      users
          .map((uid) => database.ref().child('$uid/activity').onValue.map(
              (event) => UserActivityDatabaseEvent(uid: uid, event: event)))
          .toList(),
    );
  }

  Future<UserActiviyModel?> getUserActivity(String uid) async {
    final DataSnapshot snapshot =
        await database.ref().child('$uid/activity').get();
    if (snapshot.exists) {
      return UserActiviyModel.fromMap({...(snapshot.value as Map), 'uid': uid});
    }
    return null;
  }

  void subToUsers(List<String> users) {
    log('[UserActivityDispatcher->subToUsers]: ${users.join(', ')}');
    this.users = users;
  }

  void dispose() {
    users = [];
  }
}
