import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:chat_app/bloc/auth_cubit.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/posts_screen.dart';
import 'package:chat_app/screens/create_post_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://bfc352fd380c4981994f19cebd98e81d@o4504072434941952.ingest.sentry.io/4504072444051459';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _buildHomeScreen() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PostsScreen();
          } else {
            return SignInScreen();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: _buildHomeScreen(),
        routes: {
          SignUpScreen.id: (context) => const SignUpScreen(),
          SignInScreen.id: (context) => const SignInScreen(),
          PostsScreen.id: (context) => const PostsScreen(),
          CreatePostScreen.id: (context) => const CreatePostScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
        },
      ),
    );
  }
}
