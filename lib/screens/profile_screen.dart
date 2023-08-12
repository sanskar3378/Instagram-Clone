import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                'https://i.pinimg.com/474x/66/ff/cb/66ffcb56482c64bdf6b6010687938835.jpg'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Text('Log out', style: TextStyle(fontSize: 20),),

          )
        ]),
      ),
    );
  }
}
