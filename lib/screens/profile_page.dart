import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        title: const Text("My profile"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.network(
                  currentUser!.photoUrl!,
                  scale: 0.7,
                ),
              ),
              AdaptiveText(
                currentUser!.displayName!,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
              AdaptiveText(currentUser!.email),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Palette.primary),
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          onPressed: () {
            handleSignOut();
            Navigator.push(
              context,
              MaterialPageRoute<bool>(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
    );
  }
}
