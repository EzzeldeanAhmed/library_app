import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart' as app_models;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<app_models.User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('Starting login for email: $email');

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = result.user;
      print('Firebase user created: ${firebaseUser?.uid}');

      if (firebaseUser != null) {
        // Return a basic user object first, then try to get full data
        app_models.User basicUser = app_models.User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
        );

        try {
          print('Trying to fetch user data from Firestore...');
          // Try to get additional user data from Firestore
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(firebaseUser.uid).get();

          print('Firestore document exists: ${userDoc.exists}');

          if (userDoc.exists) {
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;
            print('User data retrieved: $userData');
            return app_models.User(
              id: firebaseUser.uid,
              name: userData['name'] ?? firebaseUser.displayName ?? 'User',
              email: firebaseUser.email ?? '',
              phone: userData['phone'] ?? '',
              address: userData['address'] ?? '',
              profileImage: userData['profileImage'] ?? '',
            );
          } else {
            print('User document does not exist, creating one...');
            // Create user document if it doesn't exist
            await createUserDocument(basicUser);
            return basicUser;
          }
        } catch (firestoreError) {
          print('Firestore error during login: $firestoreError');
          // If Firestore fails, return the basic user object
          return basicUser;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Unexpected error during login: $e');
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<app_models.User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = result.user;
      if (firebaseUser != null) {
        // Update display name
        await firebaseUser.updateDisplayName(name);

        // Create user document in Firestore
        app_models.User newUser = app_models.User(
          id: firebaseUser.uid,
          name: name,
          email: email,
        );

        await createUserDocument(newUser);
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument(app_models.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'address': user.address,
        'profileImage': user.profileImage,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create user profile: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(app_models.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'phone': user.phone,
        'address': user.address,
        'profileImage': user.profileImage,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update Firebase Auth display name
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(user.name);
      }
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // Get user data from Firestore
  Future<app_models.User?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return app_models.User(
          id: uid,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          phone: userData['phone'] ?? '',
          address: userData['address'] ?? '',
          profileImage: userData['profileImage'] ?? '',
        );
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      // Return null instead of throwing to prevent crashes
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
