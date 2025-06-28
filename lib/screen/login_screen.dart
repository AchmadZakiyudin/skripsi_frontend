import 'package:booking_bus/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Container(
      color: const Color.fromARGB(255, 29, 29, 29),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Background Image
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/dark_pattern.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Top Design
              Container(
                height: MediaQuery.of(context).size.height / 4 - 20,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 29, 29, 29),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),

              // Login/Register Form
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        authC.isLogin.value ? "Login" : "Register",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.green,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Username",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: email,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter your username",
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: password,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter your password",
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (authC.isLogin.value) {
                                      authC.signIn(email.text, password.text);
                                    } else {
                                      authC.register(email.text, password.text);
                                    }
                                  },
                                  child: Text(
                                    authC.isLogin.value ? "Login" : "Register",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  authC.isLogin.value = !authC.isLogin.value;
                                },
                                child: Text(
                                  authC.isLogin.value
                                      ? "Create Account"
                                      : "I Have Account",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
