import 'package:chatapp/services/firebaseServices.dart';
import 'package:chatapp/view/chatList.dart';
import 'package:chatapp/view/full_screen_image.dart';
import 'package:chatapp/view/registration_screen.dart';
import 'package:chatapp/view/signin_screen.dart';
import 'package:chatapp/view/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//this is for am
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance)),
      StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChange),
    ], child: AuthenticationRapper());
  }
}

class AuthenticationRapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
      routes: {
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        SignInScreen.screenRoute: (context) => SignInScreen(),
        RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
        ChatScreen.screenRoute: (context) => ChatScreen(),
        FullScreenImage.screenRoute: (context) => FullScreenImage(),
      },
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    return firebaseUser != null ? ChatScreen() : WelcomeScreen();
  }
}
