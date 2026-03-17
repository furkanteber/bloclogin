import 'package:bloclogin/features/auth/presentation/components/my_button.dart';
import 'package:bloclogin/features/auth/presentation/components/my_google_sign_%C4%B1n_button.dart';
import 'package:bloclogin/features/auth/presentation/components/my_textfield.dart';
import 'package:bloclogin/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? tooglePages;
  const LoginPage({super.key, required this.tooglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  late final authCubit = context.read<AuthCubit>();

  void login() {
    final String email = emailController.text;
    final String pw = pwController.text;

    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter both email & password!")));
    }
  }

  void openForgotPasswordBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Forgot Password?"),
              content: MyTextfield(
                  controller: emailController,
                  hintText: "Enter email..",
                  obsecureText: false),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      String message =
                          await authCubit.forgotPassword(emailController.text);

                      if (message == "Password reset email! Check your inbox") {
                        Navigator.pop(context);
                        emailController.clear();
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    },
                    child: Text("Reset"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(
                  Icons.lock_open,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 25),
                Text(
                  "TeberSoft APP",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obsecureText: false,
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: pwController,
                  hintText: "Password",
                  obsecureText: true,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => openForgotPasswordBox(),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                MyButton(onTap: login, text: "Login"),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text("Or sign in with"),
                    ),
                    Expanded(
                        child: Divider(
                      color: Theme.of(context).colorScheme.tertiary,
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyGoogleSignInButton(onTap: () async {
                      authCubit.signInWithGoogle();
                    })
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.tooglePages,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
