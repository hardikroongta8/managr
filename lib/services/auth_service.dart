import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _authService = FirebaseAuth.instance;

  

  Future register(String email, String password, String fullName)async{
    try{
      UserCredential result = await _authService.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await user!.updateDisplayName(fullName);
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential result = await _authService.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logout() async {
    try {
      return await _authService.signOut();
    } catch (e) {
      print('ERROR LOGGING OUT');
      return null;
    }
  }
}