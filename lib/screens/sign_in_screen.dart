import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'posts_screen.dart';
import 'sign_up_screen.dart';
import '../bloc/auth_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String id = 'sign_in_screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
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

    context.read<AuthCubit>().signIn(email: _email, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState) {
          if (currentState is AuthSignedIn) {
            //Navigator.of(context).pushReplacementNamed(PostsScreen.id);
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
        builder: ((context, state) {
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
                        child: Text('Chat App',
                            style: Theme.of(context).textTheme.headline3),
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
                              .requestFocus(_passwordFocusNode); // go next form
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
                      // TODO: ~ Use next Relise
                      // TextFormField(
                      //   focusNode: _userNameFocusNode,
                      //   decoration: InputDecoration(
                      //     enabledBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.black),
                      //     ),
                      //     labelText: 'Enter Username',
                      //   ),
                      //   textInputAction: TextInputAction.next,
                      //   onFieldSubmitted: (_) {
                      //     FocusScope.of(context).requestFocus(_passwordFocusNode);
                      //   },
                      //   onSaved: (value) {
                      //     _userName = value!.trim();
                      //   },
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter username';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 15),

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
                        child: const Text('Sign In'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.id);
                        },
                        child: const Text('Sign Up instead'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
