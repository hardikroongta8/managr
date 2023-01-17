import 'package:butlr/screens/profile.dart';
import 'package:butlr/screens/progress_report.dart';
import 'package:butlr/services/auth_service.dart';
import 'package:butlr/services/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPopupMenu extends StatelessWidget {

  final User? user;

  const MyPopupMenu({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      onSelected: (value){
        switch (value) {
          case 1:{
            String? photoUrl = user!.photoURL;
            if(photoUrl != null){photoUrl = photoUrl.replaceAll('s96', 's200');}
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:(context) => Profile(
                  photoUrl: photoUrl,
                  email: user!.email,
                  name: user!.displayName
                ),
              )
            );
            break;
          }
          case 2:{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:(context) => ProgressReport(uid: user!.uid),
              )
            );
            break;
          }
          case 3:{
            if(FirebaseAuth.instance.currentUser?.providerData[0].providerId == "google.com"){
              GoogleAuthentication().googleLogout();
            }
            else{
              AuthService().logout();
            }
            break;
          }
          default:
        }
      },
      itemBuilder:(context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const[
              Icon(Icons.person),
              SizedBox(width: 10,),
              Text('Profile'),
            ],
          )
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: const [
              Icon(Icons.data_usage),
              SizedBox(width: 10,),
              Text('Progress Report'),
            ],
          )
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: const [
              Icon(Icons.logout),
              SizedBox(width: 10,),
              Text('Logout'),
            ],
          ),
        ),
      ],
    );
  }
}