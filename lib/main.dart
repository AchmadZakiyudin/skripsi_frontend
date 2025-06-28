import 'package:booking_bus/controller/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugPrintRebuildDirtyWidgets = false; // Disable debug print for rebuilds
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Register AuthController
    Get.put(AuthController());

    return GetMaterialApp(
      title: 'Firebase Auth GetX',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // SplashScreen
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
