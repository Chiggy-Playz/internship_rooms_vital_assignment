import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHandler {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DatabaseHandler({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> createUserDocument(User? user) async {
    if (user == null) {
      throw Exception("Cant create user document for null user");
    }

    DocumentReference userRef = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName ?? "Unnamed User",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String?> getUserIdByEmail(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }

  /// Fetches user IDs (UIDs) from Firestore based on partial email match for autocomplete
  Future<List<Map<String, dynamic>>> searchUsersByEmail(String query) async {
    if (query.isEmpty) return [];

    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: '$query\uf8ff')
        .where('email', isNotEqualTo: _auth.currentUser!.email!)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> shareDeviceAccess(String deviceId, String userId) async {
    String? ownerId = _auth.currentUser?.uid;
    if (ownerId == null) return;

    DocumentReference deviceRef = _firestore
        .collection('users')
        .doc(ownerId)
        .collection('devices')
        .doc(deviceId);
    await deviceRef.set({
      "access_group": FieldValue.arrayUnion([userId])
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getSharedDevices() async {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    List<Map<String, dynamic>> sharedDevices = [];
    final usersCollection = _firestore.collection('users');
    final usersSnapshot = await usersCollection.get();

    for (var userDoc in usersSnapshot.docs) {
      final devicesSnapshot =
          await userDoc.reference.collection('devices').get();
      for (var deviceDoc in devicesSnapshot.docs) {
        List<dynamic> accessGroup = deviceDoc['access_group'] ?? [];
        if (accessGroup.contains(userId)) {
          sharedDevices.add(deviceDoc.data());
        }
      }
    }
    return sharedDevices;
  }

  /// Fetches emails of users who have access to a given device
  Future<List<String>> getSharedUsersEmails(String deviceId) async {
    String? ownerId = _auth.currentUser?.uid;
    if (ownerId == null) return [];

    DocumentReference deviceRef = _firestore
        .collection('users')
        .doc(ownerId)
        .collection('devices')
        .doc(deviceId);

    DocumentSnapshot deviceDoc = await deviceRef.get();
    if (!deviceDoc.exists) return [];

    List<dynamic> accessGroup = deviceDoc['access_group'] ?? [];
    if (accessGroup.isEmpty) return [];

    List<String> emails = [];
    for (String userId in accessGroup) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc['email'] != null) {
        emails.add(userDoc['email']);
      }
    }
    return emails;
  }
}
