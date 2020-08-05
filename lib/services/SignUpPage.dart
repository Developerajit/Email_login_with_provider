import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastik_manage/Animation/FadeAnimation.dart';
import 'package:sastik_manage/services/auth.dart';
import 'dart:io';
import 'loader.dart';
class SignUp extends StatefulWidget {
  final user;

  const SignUp({Key key, this.user}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  bool active=false;
  String _name,_email,_pass;
  final _formkey = GlobalKey<FormState>();
  bool _validate(){
    final form = _formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
  }
  void  _submit() async{
    final auth= Provider.of<AuthBase>(context,listen: false);
    if(_validate()){
      setState(() {
        active=true;
      });
      auth.createUserWithEmailAndPassword(_email, _pass).whenComplete(() {
        auth.updateUser(_name).whenComplete(() {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false).whenComplete(() {
            setState(() {
              active=false;
            });
          });
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.orange[900],
                      Colors.orange[800],
                      Colors.orange[400]
                    ]
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80,),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(1, Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 40),)),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FadeAnimation(1.3, FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18),)))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60,),
                            FadeAnimation(1.4, Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                  )]
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                    ),
                                    child: _buildForm(),
                                  ),
                                ],
                              ),
                            )),
                            SizedBox(height: 40,),
                            FadeAnimation(1.5, Text("Here we Go", style: TextStyle(color: Colors.grey),)),
                            SizedBox(height: 40,),
                            FadeAnimation(1.6, Container(
                              height: 70,
                              width: 300,
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orange[900]
                              ),
                              child: FlatButton(
                                onPressed:_submit,
                                child: Center(
                                  child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            )),
                            SizedBox(height: 50,),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          active?Loader():SizedBox(height: 2,)
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child:  Column(
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget>_buildFormChildren() {
    return[
      TextFormField(
        validator:(val){
          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";
        },
        onSaved: (value)=>_email=value,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: "Email",
            hintStyle:
            TextStyle(color: Colors.grey),
            border: InputBorder.none),
      ),
      TextFormField(
        obscureText: true,
        validator: (value){
          return value.isEmpty || value.length < 6 ? "Enter Password 3+characters" : null;
        },
        onSaved: (value)=>_pass=value,
        decoration: InputDecoration(
            hintText: "Password",
            hintStyle:
            TextStyle(color: Colors.grey),
            border: InputBorder.none),
      ),
      TextFormField(
        validator: (value){
          return value.isEmpty || value.length < 3 ? "Enter greater than 3" : null;
        },
        onSaved: (value)=>_name=value,
        decoration: InputDecoration(
            hintText: "Name",
            hintStyle:
            TextStyle(color: Colors.grey),
            border: InputBorder.none),
      ),

    ];
  }


}
