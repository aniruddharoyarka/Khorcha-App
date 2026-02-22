import 'package:flutter/material.dart';

import '../widgets/settings_tile.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    DateTime registrationDate = DateTime.now();

    String registeredSince =
        "${registrationDate.day}-${registrationDate.month}-${registrationDate.year}";

    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F5F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFF03624C),
                      child: Icon(Icons.person, color: Colors.white, size: 35),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Shakibul Alam",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.verified, color: Color(0xFF03624C)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("User since $registeredSince"),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                      child: Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF03624C),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F5F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.flag,
                      title: "Monthly Budget",
                      onTap: () {
                        final TextEditingController budgetController =
                            TextEditingController(text: "5000");

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Monthly Budget",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    TextField(
                                      controller: budgetController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Enter Budget Amount",
                                        prefixText: "৳ ",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 25),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF03624C),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Save Budget",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Divider(),
                    SettingsTile(
                      icon: Icons.notifications,
                      title: "Daily Reminder",
                      onTap: () {
                        bool isReminderOn = true;
                        TimeOfDay selectedTime = TimeOfDay(hour: 20, minute: 0);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Daily Reminder",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Enable Reminder"),
                                            Switch(
                                              value: isReminderOn,
                                              activeColor: Color(0xFF03624C),
                                              onChanged: (value) {
                                                setState(() {
                                                  isReminderOn = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),

                                        if (isReminderOn) ...[
                                          SizedBox(height: 5),

                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text("Reminder Time"),
                                            subtitle: Text(
                                              selectedTime.format(context),
                                            ),
                                            trailing: Icon(Icons.access_time),
                                            onTap: () async {
                                              final picked =
                                                  await showTimePicker(
                                                    context: context,
                                                    initialTime: selectedTime,
                                                  );

                                              if (picked != null) {
                                                setState(() {
                                                  selectedTime = picked;
                                                });
                                              }
                                            },
                                          ),
                                        ],

                                        SizedBox(height: 25),

                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(
                                                0xFF03624C,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    Divider(),
                    SettingsTile(
                      icon: Icons.info,
                      title: "About Khorcha",
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.all(25),
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Sheet only takes needed space
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "About Khorcha",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Version 1.0.0",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Divider(height: 30),
                                  Text(
                                    "Khorcha is your personal finance companion that makes tracking expenses simple, budgeting smarter, and saving easier through intelligent insights and clean visual reports.",
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Developed by Ushriba Rahman & Aniruddha Roy Arka",
                                  ),
                                  SizedBox(height: 30),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    Divider(),

                    // 🚪 Logout
                    SettingsTile(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.logout, color: Color(0xFF03624C)),
                                  SizedBox(width: 10),
                                  Text("Logout"),
                                ],
                              ),
                              content: Text(
                                "You will need to login again to access your account.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF03624C),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      trailing: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
