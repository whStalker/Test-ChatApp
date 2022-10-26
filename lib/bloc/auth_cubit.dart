import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      emit(const AuthSignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthFailure(errorMassage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(const AuthFailure(
            errorMassage: 'Wrong password provided for that user.'));
      }
    } catch (error) {
      emit(const AuthFailure(errorMassage: 'An error has occurred'));
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userID': userCredential.user!.uid,
        'userName': username,
        'email': email,
      });

      userCredential.user!.updateDisplayName(username);

      emit(const AuthSignedUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const AuthFailure(
            errorMassage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(const AuthFailure(
            errorMassage: 'The account already exists for that email.'));
      }
    } catch (error) {
      emit(const AuthFailure(errorMassage: 'An error has occurred'));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
