// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_fire/cloud_fire.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String?> signup({
//     required String name,
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(
//             email: email.trim(),
//             password: password.trim(),
//           );
//       await _firestore.collection("users").doc((userCredential.user!.uid)).set({
//         'name': name.trim(),
//         'email': email.trim(),
//         'role': role,
//       });
//       return null;
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//       DocumentSnapshot userDoc =
//           await _firestore
//               .collection("users")
//               .doc(userCredential.user!.uid)
//               .get();
//       return userDoc['role'];
//     } catch (e) {
//       return e.toString();
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup Function
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // Save user info in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
      });

      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unknown error occurred.";
    } catch (e) {
      return e.toString();
    }
  }

  // Login Function
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Fetch user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

      // Return role or some info to identify success
      return userDoc['role'];
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An unknown error occurred.";
    } catch (e) {
      return e.toString();
    }
  }

  // for logout
  logout() {
    _auth.signOut();
  }
}
