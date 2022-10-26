import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:chat_app/bloc/auth_cubit.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/posts_screen.dart';
import 'package:chat_app/screens/create_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const SignUpScreen(),
        routes: {
          SignUpScreen.id: (context) => const SignUpScreen(),
          SignInScreen.id: (context) => const SignInScreen(),
          PostsScreen.id: (context) => const PostsScreen(),
          CreatePostScreen.id: (context) => const CreatePostScreen(),
        },
      ),
    );
  }
}
