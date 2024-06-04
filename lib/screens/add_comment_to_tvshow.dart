import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../models/tv_show_model.dart';
import '../services/add_comment.dart';

class AddCommentToTvShow extends StatefulWidget {
  final TvShow tvShow;
  const AddCommentToTvShow({super.key, required this.tvShow});

  @override
  State<AddCommentToTvShow> createState() => _AddCommentToTvShowState();
}

class _AddCommentToTvShowState extends State<AddCommentToTvShow> {
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
          id: (widget.tvShow.id).toString(), // Benzersiz kimlik
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