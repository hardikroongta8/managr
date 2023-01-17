import 'package:butlr/screens/components/appbar.dart';
import 'package:butlr/services/auth_service.dart';
import 'package:butlr/services/google_auth.dart';
import 'package:butlr/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  final String? email, photoUrl, name;

  const Profile({required this.email, required this.name, required this.photoUrl, super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final errorUrl = 'https://raw.githubusercontent.com/hardikroongta8/posts/main/error.png';
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MyAppBar(title: 'Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(widget.photoUrl ?? errorUrl),
                radius: 70,
                child: const Text('Loading'),
              ),
              const SizedBox(height: 10,),
              Text(widget.name ?? '', style: const TextStyle(fontSize: 24, color: Colors.amber),),
              const SizedBox(height: 5,),
              Text(widget.email ?? '', style: TextStyle(color: Colors.amber.shade900),),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: (){
                  Navigator.pop(context);
                  if(FirebaseAuth.instance.currentUser?.providerData[0].providerId == "google.com"){
                    GoogleAuthentication().googleLogout();
                  }
                  else{
                    _authService.logout();
                  }
                },
                child: const Text('Logout'),
              ),
              const SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}