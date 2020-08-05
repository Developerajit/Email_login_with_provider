import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sastik_manage/services/auth.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth= Provider.of<AuthBase>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Management App',style: GoogleFonts.aclonica(color: Colors.orangeAccent,wordSpacing: 1.0,fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.show_chart,color: Colors.orangeAccent,), onPressed: ()async{
            await auth.signOut();
          })
        ],
      ),
      body: Container(),
    );
  }
}
