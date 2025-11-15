import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/core/models/user_model.dart';
import 'package:myapp/core/services/database_service.dart';
import 'package:myapp/core/services/storage_service.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = Get.find<DatabaseService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);

  bool get isAuthenticated => currentUser.value != null;

  Future<AuthService> init() async {
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _onAuthStateChanged);
    return this;
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      // User is signed out, ensure guest user exists
      final guestId = await _dbService.getOrCreateUser();
      final guestData = await _dbService.getUserById(guestId);
      if (guestData != null) {
        userModel.value = UserModel.fromMap(guestData);
      }
    } else {
      // User is signed in
      await _updateLocalUser(firebaseUser);
    }
  }

  Future<void> signUpWithEmail(String email, String password, String username) async {
    try {
      if (userModel.value?.isGuest ?? false) {
        await linkGuestAccount(email, password, username);
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await userCredential.user?.updateDisplayName(username);
        await _dbService.createUser(
          userCredential.user!.uid,
          username,
          email: email,
        );
        await _updateLocalUser(userCredential.user);
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      throw _handleAuthException(e);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateLocalUser(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // _onAuthStateChanged will handle creating a new guest user
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> linkGuestAccount(String email, String password, String username) async {
    try {
      final String? oldUserId = await _storageService.getUserId();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final newUserId = userCredential.user!.uid;

      if (oldUserId != null) {
        await _migrateGuestData(oldUserId, newUserId);
      }

      await _dbService.updateUser(newUserId, {
        'username': username,
        'email': email,
        'last_login_at': DateTime.now().toIso8601String(),
      });

      await _updateLocalUser(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> _migrateGuestData(String oldUserId, String newUserId) async {
    await _dbService.migrateUserData(oldUserId, newUserId);
  }

  Future<void> _updateLocalUser(User? firebaseUser) async {
    if (firebaseUser != null) {
      _storageService.setUserId(firebaseUser.uid);
      _storageService.write('isGuest', false);
      
      var userData = await _dbService.getUserById(firebaseUser.uid);
      if (userData == null) {
        // If user exists in Firebase but not locally, create a local record
        await _dbService.createUser(firebaseUser.uid, firebaseUser.displayName ?? 'User', email: firebaseUser.email);
        userData = await _dbService.getUserById(firebaseUser.uid);
      } else {
        // Update last login time
        await _dbService.updateUser(firebaseUser.uid, {'last_login_at': DateTime.now().toIso8601String()});
        userData = await _dbService.getUserById(firebaseUser.uid);
      }

      if (userData != null) {
        userModel.value = UserModel.fromMap(userData);
      }
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل.';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة.';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً.';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح.';
      default:
        return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }
}
