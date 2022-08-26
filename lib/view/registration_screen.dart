import 'package:chatapp/services/firebaseServices.dart';
import 'package:chatapp/services/google_auth.dart';
import 'package:chatapp/view/chatList.dart';
import 'package:chatapp/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back),),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                /*     child: Image.asset('images/logo.png'), */
              ),
              Center(
                child: Text(
                  'GroupChat',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2e386b),
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              MyButton(
                color: Colors.blue[800]!,
                title: 'register',
                onPressed: () async {
                  try {
                    await context
                        .read<AuthenticationService>()
                        .signUp(email: email, password: password);
                  } catch (e) {
                    print("this is the error :::::$e");
                  }
                  if (context.read<AuthenticationService>().getuser() != null) {
                    Navigator.pushNamed(context, ChatScreen.screenRoute);
                  } else {
                    print("username or password are wrong!!!");
                  }
                },
              ),
              //Platform.isAndroid==true?
          MyButton(
                color: Colors.blue[800]!,
                title: 'Google Signin',
                onPressed: () async {
                  try {
                    await signInWithGoogle();
                  } catch (e) {
                    print("this is the error :::::$e");
                  }
                  if (context.read<AuthenticationService>().getuser() != null) {
                    Navigator.pushNamed(context, ChatScreen.screenRoute);
                  } else {
                    print("username or password are wrong!!!");
                  }
                },
              )
              //:Container()
            ],
          ),
        ),
      ),
    );
  }
}
