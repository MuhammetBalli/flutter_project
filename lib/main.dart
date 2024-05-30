import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_app/providers/auth.provider.dart'; // Update the path as needed
import 'package:movies_app/providers/movie_provider.dart';
import 'package:movies_app/screens/home_screen.dart';
import 'package:movies_app/screens/reset_password_screen.dart';
import 'package:movies_app/screens/sign_in_screen.dart';
import 'package:movies_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAuthProvider(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(), // Add the MovieProvider
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase App',
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/signup': (context) => SignUpScreen(),
          '/signin': (context) => SignInScreen(),
          '/home': (context) =>  HomeScreen(),
          '/reset_password': (context) => ResetPasswordPage(),// Replace with your home screen
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);

    return StreamBuilder(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return  HomeScreen();  // Replace with your home screen
        } else {
          return SignInScreen();
        }
      },
    );
  }
}


