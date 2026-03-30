import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isEmailVerified = false;
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isFetching = false);
      return;
    }

    try {
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      displayNameController.text = data?['name'] ?? "User";
      emailController.text = updatedUser?.email ?? "No Email";
      isEmailVerified = updatedUser?.emailVerified ?? false;

    } catch (e) {
      debugPrint("Error fetching user data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  Future<void> saveProfileChanges() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newName = displayNameController.text.trim();
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newName.isEmpty) {
      _showSnackBar("Name cannot be empty");
      return;
    }

    bool isChangingPassword = currentPassword.isNotEmpty ||
        newPassword.isNotEmpty ||
        confirmPassword.isNotEmpty;

    if (isChangingPassword) {
      if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
        _showSnackBar("All password fields are required to change your password");
        return;
      }
      if (newPassword != confirmPassword) {
        _showSnackBar("New passwords do not match");
        return;
      }
      if (newPassword.length < 6) {
        _showSnackBar("Password must be at least 6 characters");
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'name': newName}, SetOptions(merge: true));

      if (isChangingPassword && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      }

      if (!mounted) return;
      _showSnackBar("Profile updated successfully");
      Navigator.pop(context, true);

    } on FirebaseAuthException catch (e) {
      String message = "Failed to update profile";
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = "Current password is incorrect";
      } else if (e.code == 'too-many-requests') {
        message = "Too many attempts. Try again later";
      }
      if (!mounted) return;
      _showSnackBar(message);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar("Something went wrong");
      debugPrint("Update error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> triggerPasswordReset() async {
    final email = emailController.text.trim();
    if (email.isEmpty || email == "No Email") {
      _showSnackBar("No valid email to send reset link to.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar("Password reset email sent to $email!");
    } catch (e) {
      _showSnackBar("Failed to send password reset email.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit Profile")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Profile Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            _buildTextField(
              controller: displayNameController,
              label: "Display Name",
              icon: Icons.badge,
            ),

            SizedBox(height: 15),

            _buildTextField(
              controller: emailController,
              label: "Email",
              icon: Icons.email,
              enabled: false,
            ),

            SizedBox(height: 30),
            Text(
              "Change Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            _buildPasswordField(
              controller: currentPasswordController,
              label: "Current Password",
              obscure: obscureCurrent,
              toggle: () {
                setState(() => obscureCurrent = !obscureCurrent);
              },
            ),
            SizedBox(height: 15),
            _buildPasswordField(
              controller: newPasswordController,
              label: "New Password",
              obscure: obscureNew,
              toggle: () {
                setState(() => obscureNew = !obscureNew);
              },
            ),
            SizedBox(height: 15),
            _buildPasswordField(
              controller: confirmPasswordController,
              label: "Confirm New Password",
              obscure: obscureConfirm,
              toggle: () {
                setState(() => obscureConfirm = !obscureConfirm);
              },
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: triggerPasswordReset,
                child: Text("Reset Password via Email"),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : saveProfileChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03624C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}