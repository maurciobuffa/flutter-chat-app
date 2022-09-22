import 'package:chat_app/widgets/blue_button.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Logo(title: "Register"),
                  _Form(),
                  Labels(
                    route: 'login',
                    title: "Already have an account?",
                    subtitle: "Login now!",
                  ),
                  Text(
                    "Terms and conditions of use",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
              icon: Icons.perm_identity,
              placeholder: 'Name',
              textController: nameCtrl),
          CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),
          CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              isPassword: true,
              textController: passCtrl),
          BlueButton(
              text: "Register",
              onPressed: () {
                print(emailCtrl.text);
                print(passCtrl.text);
              })
          // CustomInput(
          //   icon: Icons.mail_outline,
          //   placeholder: 'Email',
          //   keyboardType: TextInputType.emailAddress,
          // ),
          // CustomInput(
          //   icon: Icons.lock_outline,
          //   placeholder: 'Password',
          //   keyboardType: TextInputType.text,
          //   isPassword: true,
          // ),
          // BotonAzul(
          //   text: 'Login',
          //   onPressed: () {
          //     print('Hola Mundo');
          //   },
          // )
        ],
      ),
    );
  }
}
