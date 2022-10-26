import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../bloc/auth_cubit.dart';
import 'create_post_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  static const String id = 'post_screen';

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Create Post
          IconButton(
            onPressed: () {
              final picker = ImagePicker();
              picker
                  .pickImage(source: ImageSource.gallery, imageQuality: 50)
                  .then(
                (xFile) {
                  if (xFile != null) {
                    final File file = File(xFile.path);
                    Navigator.of(context)
                        .pushNamed(CreatePostScreen.id, arguments: file);
                  }
                },
              );
            },
            icon: const Icon(Icons.add),
          ),

          // Log out
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut().then(
                    (_) => Navigator.of(context)
                        .pushReplacementNamed(SignInScreen.id),
                  );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            if (snapshot.hasError) {
              return Center(child: Text('Loading...'));
            }
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(doc['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      doc['userName'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 5),
                    Text(
                      doc['description'],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
