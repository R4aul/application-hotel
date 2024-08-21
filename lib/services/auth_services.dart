import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createAccunt(String email, String password) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user);
      return(userCredential.user?.uid);
    } on FirebaseAuthException catch(e) {
      if(e.code == 'weak-password') {
        print('the password provider is to weak');
        return 1;
      } else if (e.code == 'email-already-in-use'){
        print('The accout alredy exist');
        return 2;
      }
    } catch(e){
      print(e);
    }
  }

  Future singInEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user?.uid != null) {
        return user?.uid;
      }
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        return 1;
      } else if(e.code == 'wrong-password'){
        return 2;
      }
    }
  }
}