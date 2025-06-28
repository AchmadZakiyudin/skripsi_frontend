import 'package:booking_bus/controller/auth_controller.dart';
import 'package:booking_bus/model/user.dart';
import 'package:booking_bus/page/home_page.dart';
import 'package:booking_bus/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      User? user = AuthController.to.firebaseUser.value;
      return user == null ? LoginScreen() : HomePage();
    });
  }
}
