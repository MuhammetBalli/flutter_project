import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment_model.dart';


class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(Comment comment) async {
    await _firestore.collection('comments').add(comment.toJson());
  }

  Stream<List<Comment>> getComments(String itemId) {
    return _firestore
        .collection('comments')
        .where('id', isEqualTo: itemId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Comment.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['username'];
    } else {
      return 'Anonymous';
    }
  }
}
