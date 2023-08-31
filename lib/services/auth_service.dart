import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(String username, String password) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
      if (querySnapshot.size == 1) {
        // Jika ditemukan data pengguna dengan username yang cocok
        String email = querySnapshot.docs[0]["email"];
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<User?> createUser(
      String fullName,
      String username,
      String phoneNumber,
      String email,
      String password,
      String confirmPassword) async {
    if (email.isEmpty || !email.contains('@')) {
      throw "Email must be using '@'";
    }

    if (fullName.length < 5) {
      throw "Full name must be at least 5 characters.";
    }

    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      if (user != null) {
        double initialBalance = 10000.0;

        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'phoneNumber': phoneNumber,
          'balance': initialBalance
        });
      }
      // await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: password);

      return user;
    } catch (e) {
      throw "Registration Failed, Please Try again";
    }
  }

  Future<bool> updateUserProfile(String fullName, String phoneNumber) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // await user.updateDisplayName(fullName);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({"fullName": fullName, "phoneNumber": phoneNumber});
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }

  // Metode untuk mendapatkan pengguna saat ini
  Future<User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      return user;
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
  }

  // Metode untuk logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
