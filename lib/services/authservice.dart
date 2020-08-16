import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sastik_manage/MainSection/Dashboard.dart';
import 'package:sastik_manage/services/phone.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Dashboard();
          } else {
            return LoginPage();
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    try{
      FirebaseAuth.instance.signInWithCredential(authCreds);
    }catch (e){
      BotToast.showText(
        text: '${e.message}',
        textStyle: TextStyle(color: Colors.white, fontSize: 16),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        duration: Duration(seconds: 15),
        animationDuration: Duration(seconds: 2),
        clickClose: true,
      );
    }
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}
