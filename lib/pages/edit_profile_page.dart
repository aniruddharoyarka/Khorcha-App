import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final TextEditingController fullNameController =
  TextEditingController(text: "Shakibul Alam");

  final TextEditingController displayNameController = TextEditingController(text: "Shakib");
  final TextEditingController emailController = TextEditingController(text: "shakib@gmail.com");
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isEmailVerified = true;
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Profile Information", style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            _buildTextField(
              controller: fullNameController,
              label: "Full Name",
              icon: Icons.person,
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
              enabled: !isEmailVerified,
              helperText: isEmailVerified
                  ? "Email cannot be changed once verified"
                  : null,
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
                setState(() {
                  obscureCurrent = !obscureCurrent;
                });
              },
            ),
            SizedBox(height: 15),
            _buildPasswordField(
              controller: newPasswordController,
              label: "New Password",
              obscure: obscureNew,
              toggle: () {
                setState(() {
                  obscureNew = !obscureNew;
                });
              },
            ),
            SizedBox(height: 15),
            _buildPasswordField(
              controller: confirmPasswordController,
              label: "Confirm New Password",
              obscure: obscureConfirm,
              toggle: () {
                setState(() {
                  obscureConfirm = !obscureConfirm;
                });
              },
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text("Reset Password"),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03624C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
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