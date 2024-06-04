import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/comment_model.dart';
import '../models/movie_model.dart';
import '../services/add_comment.dart';

class AddCommentToMovie extends StatefulWidget {
  final Movie movie;
  const AddCommentToMovie({super.key, required this.movie});

  @override
  State<AddCommentToMovie> createState() => _AddCommentToMovieState();
}

class _AddCommentToMovieState extends State<AddCommentToMovie> {
  final TextEditingController _commentController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CommentService _commentService = CommentService();

  void _addComment() async {
    final String content = _commentController.text;
    if (content.isNotEmpty) {
      final User? user = _auth.currentUser;
      if (user != null) {
        final String userId = user.uid;
        final String userName = await _commentService.getUserName(userId);

        final Comment comment = Comment(
          id: (widget.movie.id).toString(), // Benzersiz kimlik
          userId: userId, // Kullanıcının kimliği
          userName: userName, // Kullanıcının adı
          content: content,
          timestamp: DateTime.now(),
        );
        await _commentService.addComment(comment);
        _commentController.clear();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 15),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(hintText: 'Yorumunuzu yazın'),
            ),
            ElevatedButton(
              onPressed: _addComment,
              child: Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}