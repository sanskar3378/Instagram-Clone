import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage.dart';
import '../model/user.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //to sign up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        //register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('prifilePics', file, false);

        //add user to our database
        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            following: [],
            followers: []);

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'sucess';
      } else {
        res = 'Please enter all fields correctly';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = 'The email is invalid.';
      } else if (error.code == 'weak-password') {
        res = 'Password should be at least 6 characters.';
      } else if (error.code == 'email-already-in-use') {
        res = 'Entered email already exists.';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  //Logging in the user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error eccoured';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Logged in sucessfully';
      } else {
        res = 'Enter all fields correctly';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        res = 'No user found';
      }
      if (error.code == 'wrong-password') {
        res = 'The password is invalid';
      }
      if (error.code == 'invalid-email') {
        res = 'The email is invalid';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
