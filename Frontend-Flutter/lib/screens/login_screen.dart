import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicineapp/screens/home_screen.dart';
import 'package:medicineapp/screens/list_presc_screen.dart';
import 'package:medicineapp/services/api_services.dart';

class LoginScreen extends StatelessWidget {
  final ApiService apiService = ApiService();
  final TextEditingController usernameController = TextEditingController(
    text: "kihun22",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "12345678",
  );

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // int uid = 2000;

    return Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor: Colors.grey[100],
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/MM_logo.png',
                      width: 250,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldSet(
                      usernameController: usernameController,
                      passwordController: passwordController,
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            iconSize: 18,
                            onPressed: () {},
                            icon: Icon(
                              Icons.check_circle,
                              color: Colors.deepPurple[200],
                            )),
                        const Text(
                          '자동로그인',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // validateAndSubmit(context, uid);
                          validateAndSubmit(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '아이디 찾기',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            width: 0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '비밀번호 찾기',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            width: 0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '회원가입',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void validateAndSubmit(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    int uid = await apiService.login(username, password);

    log("uid: $uid");

    if (uid > 0) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            uid: uid,
          ),
        ),
      );
    }
  }
}

class TextFieldSet extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const TextFieldSet({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  // text editing controllers

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.deepPurple[50],
      ),
      child: Column(
        children: [
          LoginTextField(
            controller: usernameController,
            hintText: '아이디',
            // initialValue: 'kihun22',
            obscureText: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: const Divider(
              height: 1,
            ),
          ),
          LoginTextField(
            controller: passwordController,
            hintText: '비밀번호',
            // initialValue: '12341234',
            obscureText: true,
          ),
        ],
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  // final String initialValue;
  final bool obscureText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    // required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      //
      // initialValue: initialValue,
      //
      style: const TextStyle(
        fontSize: 15,
      ),
      // textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        // isDense: true,

        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
      ),
    );
  }
}
