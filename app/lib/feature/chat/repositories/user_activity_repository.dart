import 'dart:async';
import 'package:async/async.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/models/user_activity_model.dart';

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

final userActivityDispatcherProvider = Provider<UserActivityDispatcher>((ref) {
  return UserActivityDispatcher(ref: ref, users: []);
});

final userActivityProvider =
    StreamProvider.autoDispose<UserActiviyModel?>((ref) async* {
  final userActivityService = ref.watch(userActivityDispatcherProvider);

  await for (final event in userActivityService.stream) {
    final Map<dynamic, dynamic> map = event.snapshot.value as Map;
    final UserActiviyModel data = UserActiviyModel.fromMap(map);
    print('UserActivity: ${data.uid} ${data.active} ${data.lastSeen}');
    yield data;
  }
});

class UserActivityDispatcher {
  List<String> users = [];
  final Ref ref;

  UserActivityDispatcher({required this.users, required this.ref});

  Stream<DatabaseEvent> get stream {
    final FirebaseDatabase database = ref.read(firebaseDatabaseProvider);
    if (users.isEmpty) return const Stream.empty();
    return StreamGroup.merge(
      users
          .map((uid) => database.ref().child('$uid/activity').onValue)
          .toList(),
    );
  }

  void subToUsers(List<String> users) {
    print('subToUsers: ${users.join(', ')}');
    this.users = users;
  }

  void dispose() {
    users = [];
  }
}
