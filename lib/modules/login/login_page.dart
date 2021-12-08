import 'package:app_filmes/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/bg_splash.png',
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black45,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Image.asset('assets/images/logo_filmes.png'),
                const SizedBox(height: 50),
                SizedBox(
                  width: Get.width * 0.9,
                  height: 42,
                  child: SignInButton(
                    Buttons.Google,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(75),
                    ),
                    text: 'Entrar com o Google',
                    onPressed: () => controller.login(),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
