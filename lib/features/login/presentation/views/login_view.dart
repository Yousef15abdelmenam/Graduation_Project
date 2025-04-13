import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/core/utils/app_router.dart';
import 'package:graduation_project/core/utils/show_snack_bar.dart';
import 'package:graduation_project/core/widgets/custom_button.dart';
import 'package:graduation_project/core/widgets/custom_text_field.dart';
import 'package:graduation_project/features/facilities/presentation/views/facilities_view.dart';
import 'package:graduation_project/features/register/presentation/views/register_view.dart';
import 'package:graduation_project/services/login_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static String id = '/LoginView';
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? email;

  String? password;

  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formkey,
            child: ListView(children: [
             const SizedBox(
                height: 75,
              ),
              Image.asset(
                'assets/images/sportsbookinglogo.png',
                height: 100,
              ),
             const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sports',
                        style: TextStyle(
                            fontSize: 35,
                            color: kPrimaryColor,
                            fontFamily: 'Karla'),
                      ),
                      Text(
                        'Booking',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                            fontFamily: 'Karla'),
                      )
                    ],
                  ),
                ],
              ),
             const SizedBox(
                height: 75,
              ),
             const Row(
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 24, color: kPrimaryColor),
                  ),
                ],
              ),
             const SizedBox(
                height: 20,
              ),
              CustomTextField.CustomformTextField(
                onchanged: (data) {
                  email = data;
                },
                hintText: 'Email',
              ),
             const SizedBox(
                height: 10,
              ),
              CustomTextField.CustomformTextField(
                obsecureText: true,
                onchanged: (data) {
                  password = data;
                },
                hintText: 'Password',
              ),
             const SizedBox(
                height: 20,
              ),
              CustomButton(
                ontap: () async {
                  if (formkey.currentState!.validate()) {
                    isloading = true;
                    setState(() {});

                    try {
                      final loginModel = await LoginService().loginUser(
                        email: email!,
                        password: password!,
                      );
                      showSnackBar(context, 'Logged in successfully');
                      // print('User logged in: ${loginModel.toJson()}');

                      // Get.toNamed(FacilitiesView.id, arguments: email);
                      GoRouter.of(context).push(AppRouter.kFacilitiesView);
                    } catch (ex) {
                      showSnackBar(context, 'Error: $ex');
                    }

                    isloading = false;
                    setState(() {});
                  }
                },
                text: 'Login',
              ),
             const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text(
                    "don't have an account ? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Get.toNamed(RegisterView.id);
                        GoRouter.of(context).push(AppRouter.kRegisterView);
                      },
                      child:const Text(
                        'Register',
                        style: TextStyle(color: kPrimaryColor),
                      ))
                ],
              ),
             const SizedBox(
                height: 150,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
