import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
class User {
  User({@required this.uid,this.photoUrl,this.displayName});
  final String uid;
  final String displayName;
  final String photoUrl;
}

abstract class AuthBase {
  Stream<User> get onAuthChanged;
  Future<User> createUserWithEmailAndPassword(String email,String password);
  Future<User> signInWithEmailAndPassword(String email,String password);
  Future<User> currentUser();
  Future<String> updateUser(String name);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid,photoUrl: user.photoUrl,displayName: user.displayName);
  }

  @override
  Stream<User> get onAuthChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }
  @override
  Future<String> updateUser(String name) async {
    final user = await _firebaseAuth.currentUser();
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName=name;
    await user.updateProfile(userUpdateInfo);
    await user.reload();
    return user.uid;
  }
  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email,String password) async{
    final authResult=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }
  @override
  Future<User> signInWithEmailAndPassword(String email,String password) async{
    final authResult=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
