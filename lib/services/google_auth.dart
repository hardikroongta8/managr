import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthentication{
  String? name, imageUrl, email;

  Future<void> googleSignIn()async{
    final GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();

    if(googleAccount == null){
      print("NO GOOGLE ACCOUNT DETECTED!!");
    }
    else{
      final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

      if((googleAuth.accessToken != null) && (googleAuth.idToken != null)){
        try{
          name = googleAccount.displayName;
          imageUrl = googleAccount.photoUrl;
          email = googleAccount.email;

          await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken
            )
          );
        }
        on FirebaseException catch (error){
          print(error.toString());
        }
        catch(error){
          print(error.toString());
        }
      }
      else{
        print(googleAuth.accessToken);
        print(googleAuth.idToken);
      }
    }
  }

  Future<void> googleLogout()async{
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }
}