import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future signUp() async {
    if (!passwordConfirmed()) return;

    print("Email: ${_emailController.text.trim()}");
    print("Password: ${_passwordController.text.trim()}");

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);
      return;
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),
              SizedBox(height: 15),
              Text(
                "Create Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Fill in the details below to set up your new account",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 25),

              /*

              //name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Full Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

               */

              //SizedBox(height: 15),

              //email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 15),

              //pass
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 15),

              //rewrite pass
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_reset),
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 25),

              //reg button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    signUp();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF03624C),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),

              // Back to Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Color(0xFF03624C), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
