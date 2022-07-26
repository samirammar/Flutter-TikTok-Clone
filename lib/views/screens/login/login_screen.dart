import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/constants/app_sizes.dart';
import 'package:tiktok/views/screens/register/register_screen.dart';
import 'package:tiktok/views/widgets/text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  bool isPassword = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TikTok',
              style: TextStyle(
                color: AppColors.red,
                fontSize: FontSize.s34,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Login',
              style: TextStyle(
                fontSize: FontSize.s24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(
                controller: _emailController,
                label: 'email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(
                controller: _passwordController,
                label: 'password',
                icon: Icons.lock,
                isPassword: isPassword,
                suffix: IconButton(
                  icon: isPassword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: AppColors.red,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        authController
                            .login(
                          _emailController.text,
                          _passwordController.text,
                        )
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: FontSize.s20,
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: FontSize.s20,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.offAll(const RegisterScreen()),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: FontSize.s20,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
