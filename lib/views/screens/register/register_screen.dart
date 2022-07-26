import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants/app_colors.dart';
import 'package:tiktok/constants/app_global.dart';
import 'package:tiktok/constants/app_sizes.dart';
import 'package:tiktok/views/screens/login/login_screen.dart';
import 'package:tiktok/views/widgets/text_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isPassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                'Register',
                style: TextStyle(
                  fontSize: FontSize.s24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 35),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: const NetworkImage(
                        'https://icon-library.com/images/person-image-icon/person-image-icon-2.jpg'),
                    backgroundColor: AppColors.white,
                    radius: 60,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => authController.imagePic(),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(
                  controller: _usernameController,
                  label: 'username',
                  icon: Icons.email,
                ),
              ),
              const SizedBox(height: 20),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: AppColors.red,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          authController
                              .register(
                            _usernameController.text,
                            _emailController.text,
                            _passwordController.text,
                            authController.profileImage.value,
                          )
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        child: Center(
                          child: Text(
                            'Register',
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
                    "You have an account? ",
                    style: TextStyle(
                      fontSize: FontSize.s20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(const LoginScreen()),
                    child: Text(
                      'Login',
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
      ),
    );
  }
}
