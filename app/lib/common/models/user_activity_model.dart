class UserActiviyModel {
  final String uid;
  final bool active;
  final int lastSeen;

  UserActiviyModel(
      {required this.uid, required this.active, required this.lastSeen});

  factory UserActiviyModel.fromMap(Map<dynamic, dynamic> map) {
    return UserActiviyModel(
      uid: map['uid'] ?? '',
      active: map['active'] ?? false,
      lastSeen: map['lastSeen'] ?? 0,
    );
  }
}
