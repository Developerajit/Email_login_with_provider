import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_text_field/otp_text_field.dart';
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
  Future<User> signInGoogle();
  Future<User> signInWithFacebok();
}

class Auth implements AuthBase {
  String phoneNo, smssent, verificationId, sms, errorMessage;
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


  //Google

  Future<User> signInGoogle()async{
    final googleSIgnIn = GoogleSignIn();
    final account = await googleSIgnIn.signIn();
    if(account !=null){
      GoogleSignInAuthentication googleAuth= await account.authentication;
      if(googleAuth.accessToken !=null && googleAuth.idToken !=null){
        final result =await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        return _userFromFirebase(result.user);
      }
    }
  }
//Facebook
  @override
  Future<User> signInWithFacebok() async{
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['public_profile'],);
    if(result.accessToken != null){
      final authResult= await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token
          )
      );
      return await _userFromFirebase(authResult.user);
    }else{
     print('No access token found');
    }
  }

                                                //________________Phone_______________________//

  
  @override
  Future<void> signOut() async {
    final gsignin= GoogleSignIn();
    await gsignin.signOut();
    final facebookLogin= FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
