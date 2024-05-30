import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.provider.dart';
 // Replace with the correct import path

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  Provider.of<MyAuthProvider>(context, listen: false)
                      .sendPasswordResetEmail(email, context);
                }
              },
              child: Text('Send Reset Password Email'),
            ),
          ],
        ),
      ),
    );
  }
}
