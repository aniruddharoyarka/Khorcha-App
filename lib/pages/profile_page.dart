import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser;

  String name = "Loading...";

  Future<void> fetchName() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users').doc(currentUser.uid).get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          name = doc['name'] ?? "User";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchName();
  }



  @override
  Widget build(BuildContext context) {
    DateTime registrationDate = DateTime.now();


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
                          name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.verified, color: Color(0xFF03624C)),
                      ],
                    ),

                    SizedBox(height: 5),
                    Text(user?.email ?? "No Email"),
                    SizedBox(height: 5),

                    ElevatedButton(
                      onPressed: () async {
                        print(user);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );

                        fetchName();
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
                      onTap: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        final docRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid);

                        int currentBudget = 0;

                        try {
                          final doc = await docRef.get();
                          if (doc.exists && doc.data() != null) {
                            currentBudget = doc['budget'] ?? 0;
                          }
                        } catch (e) {
                          print("Error fetching budget: $e");
                        }

                        final TextEditingController budgetController =
                        TextEditingController(
                            text: currentBudget.toString());

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding:
                              EdgeInsets.symmetric(horizontal: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Color(0xFF03624C),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final newBudget = int.tryParse(
                                              budgetController.text.trim());

                                          if (newBudget == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Enter a valid number")),
                                            );
                                            return;
                                          }

                                          try {
                                            await docRef.set(
                                              {'budget': newBudget},
                                              SetOptions(merge: true),
                                            );

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Budget saved successfully")),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Failed to save budget")),
                                            );
                                          }
                                        },
                                        child: Text("Save Budget",
                                            style: TextStyle(
                                                color: Colors.white)),
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

                    //Divider(),

                    //daily reminder
                    /*
                    SettingsTile(
                      icon: Icons.notifications,
                      title: "Daily Reminder",
                      onTap: () {
                        bool isReminderOn = true;
                        TimeOfDay selectedTime =
                        TimeOfDay(hour: 20, minute: 0);

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
                                            contentPadding:
                                            EdgeInsets.zero,
                                            title: Text("Reminder Time"),
                                            subtitle: Text(
                                              selectedTime.format(context),
                                            ),
                                            trailing:
                                            Icon(Icons.access_time),
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
                                              backgroundColor:
                                              Color(0xFF03624C),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Save",
                                                style: TextStyle(
                                                    color: Colors.white)),
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
                     */

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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text("About Khorcha",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  Text("Version 1.0.0",
                                      style: TextStyle(
                                          color: Colors.grey[600])),
                                  Divider(height: 30),
                                  Text(
                                      "Khorcha is your personal finance companion. Developed by Ushriba Rahman & Aniruddha Roy Arka"),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    Divider(),

                    SettingsTile(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.logout,
                                      color: Color(0xFF03624C)),
                                  SizedBox(width: 10),
                                  Text("Logout"),
                                ],
                              ),
                              content: Text(
                                  "You will need to login again to access your account."),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Color(0xFF03624C)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await FirebaseAuth.instance
                                        .signOut();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Logout",
                                      style: TextStyle(
                                          color: Colors.white)),
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