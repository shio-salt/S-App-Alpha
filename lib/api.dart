import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

String uid;
String displayname;
String email;

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final AuthResult authResult = await _firebaseAuth.signInWithCredential(
      credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _firebaseAuth.currentUser();
  assert(user.uid == currentUser.uid);

  assert(user.email != null);
  assert(user.displayName != null);

  uid = user.uid;
  displayname = user.displayName;
  email = user.email;

  DocumentSnapshot value =
  await _firestore.collection('users').document(user.uid).get();

  if (value['uid'] == null) {
    await _firestore.collection("users").document(uid).setData({
      "uid": uid,
      "displayname": displayname,
      "email": email,
    });
  }

  return 'signInWithGoogle succeeded: $user';
}
