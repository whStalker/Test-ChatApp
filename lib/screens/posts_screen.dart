import 'package:flutter/material.dart';

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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        child: Text('Post Screen'),
      ),
    );
  }
}
