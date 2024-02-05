import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> updateDarkModePreference(String userId, bool isDarkModeEnabled) {
    return users.doc(userId).update({'isDarkModeEnabled': isDarkModeEnabled});
  }

  Future<bool> getDarkModePreference(String userId) async {
    DocumentSnapshot userDoc = await users.doc(userId).get();
    return userDoc.exists ? userDoc['isDarkModeEnabled'] ?? false : false;
  }
}
