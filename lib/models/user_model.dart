// user_model.dart
class User {
  final String uid;
  final String email;
  final String username;

  User({required this.uid, required this.email, required this.username});

  // Convert a User object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }

  // Create a User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
    );
  }
}
