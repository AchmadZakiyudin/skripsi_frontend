import 'package:booking_bus/page/home_page.dart';
import 'package:booking_bus/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;
  final email = ''.obs;
  final password = ''.obs;
  final isLogin = true.obs;

  static var to;

  @override
  void onInit() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
    //  Stream<User?>  user => _auth.authStateChanges();
    super.onInit();
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomePage());
    }
  }

  // Registrasi
  void register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Login
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => LoginScreen());
  }
}
