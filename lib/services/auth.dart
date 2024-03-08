import 'package:bus_booking_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

//  sign in anon
  Future<User?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email or password

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password

  // Future<User?> signUpWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential credential = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return credential.user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future<String?> signUpWithEmailAndPassword(UserModel user) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      if (credential.user != null) {
        await _db.collection('users').doc(credential.user?.uid).set({
          'email': user.email,
          'nicPassport': user.nic,
          'mobile': user.mobile,
          'gender': user.gender,
        });
        return "Registration successful!";
      } else {
        return "Something went wrong try again later";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

// sign out

  Future<String?> signOut() async {
   await _auth.signOut();
    return "Logout Successfully!";
  }

//  Current User

  Future<User?> currentUser() async {
    try {
      User? user = _auth.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}
