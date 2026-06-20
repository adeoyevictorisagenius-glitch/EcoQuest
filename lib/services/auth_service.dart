import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signIn() async {
    // Already signed in
    if (_auth.currentUser != null) {
      return _auth.currentUser;
    }

    final credential = await _auth.signInAnonymously();

    final user = credential.user;

    if (user == null) return null;

    final doc = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    if (!(await doc.get()).exists) {
      await doc.set({
        "uid": user.uid,

        "username": "Principal",

        "photoUrl": "",

        "email": "",

        "rank": "School Administrator",

        "school": "Greenschool High",

        "soloPoints": 0,

        "questsCompleted": 0,

        "schoolRank": 1,

        "globalRank": 31,

        "communityImpact": 0,

        "wasteCollectedKg": 0,

        "treesSaved": 0,

        "joinedAt": FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}