import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'posts_screen.dart';
import 'sign_in_screen.dart';
import '../bloc/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String id = 'sign_up_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _userName = '';
  String _password = '';

  late final FocusNode _userNameFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _userNameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      // Invalid
      return;
    }

    _formKey.currentState!.save();

    context
        .read<AuthCubit>()
        .signUp(email: _email, username: _userName, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState) {
          if (currentState is AuthSignedUp) {
            Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          }

          if (currentState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(currentState.errorMassage),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          'Chat App',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // email
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Enter email',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_userNameFocusNode); // go next form
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // userName
                      TextFormField(
                        focusNode: _userNameFocusNode,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Enter Username',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        onSaved: (value) {
                          _userName = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // password
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Enter Password',
                        ),
                        obscureText: true, // password like ***
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 8) {
                            return 'Please enter 8 character password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // Sign Up Button
                      TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text('Sign Up'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.id);
                        },
                        child: const Text('Sign In instead'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
