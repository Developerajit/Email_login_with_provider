import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sastik_manage/MainSection/Dashboard.dart';
import 'package:sastik_manage/services/SignInPage.dart';
import 'package:sastik_manage/services/SignUpPage.dart';
import 'package:sastik_manage/services/auth.dart';
import 'package:sastik_manage/services/loader.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(create: (context)=>Auth(),
    child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Control(),
      routes: {
        '/home':(_)=>Control(),
        '/SignUp':(_)=>SignUp()
      },
    ),
    );
  }
}

class Control extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user=snapshot.data;
          if(user==null){
            return Provider<User>.value(
                value: user,
                child: SignIn()
            );
          }
          if(user.displayName==null){
            return Provider<User>.value(
                value: user,
                child: SignIn()
            );
          }
          if(user.displayName==''){
            return Provider<User>.value(
                value: user,
                child: SignIn()
            );
          }
          else{
            return Provider<User>.value(
              value: user,
              child: Dashboard()
            );
          }
        }
        return Loader();
      },
    );
  }
}