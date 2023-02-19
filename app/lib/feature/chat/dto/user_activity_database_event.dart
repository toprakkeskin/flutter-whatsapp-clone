
import 'package:firebase_database/firebase_database.dart';

class UserActivityDatabaseEvent {
  final String uid;
  final DatabaseEvent event;

  UserActivityDatabaseEvent({required this.uid, required this.event});
}
