import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent successfully")),
      );

      // Optional: go back to login page
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Failed to send reset email";

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'invalid-email') {
        message = "Email is invalid";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 100),
            Icon(Icons.lock_reset, size: 80, color: Color(0xFF03624C)),
            SizedBox(height: 20),
            Text(
              "Forgot your password?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Enter your email address below and we'll send you a link to reset your password.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03624C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Send Reset Email",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back to Login", style: TextStyle(color: Color(0xFF03624C))),
            ),
          ],
        ),
      ),
    );
  }
}